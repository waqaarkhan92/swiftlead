import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// DataTableColumn - Column definition for DataTable
class DataTableColumn {
  final String label;
  final double? width;
  final bool sortable;
  final TextAlign alignment;

  const DataTableColumn({
    required this.label,
    this.width,
    this.sortable = true,
    this.alignment = TextAlign.left,
  });
}

/// DataTableRow - Row data for DataTable
class DataTableRow {
  final List<Widget> cells;
  final VoidCallback? onTap;

  const DataTableRow({
    required this.cells,
    this.onTap,
  });
}

/// SortDirection - Column sort direction
enum SortDirection {
  none,
  ascending,
  descending,
}

/// SwiftleadDataTable - Sortable, paginated table component
/// Exact specification from UI_Inventory_v2.5.1
class SwiftleadDataTable extends StatefulWidget {
  final String title;
  final List<DataTableColumn> columns;
  final List<DataTableRow> rows;
  final int itemsPerPage;
  final bool showLoadMore;
  final VoidCallback? onLoadMore;
  final VoidCallback? onExport;
  final Function(int columnIndex, SortDirection direction, List<DataTableRow> rows)? sortComparator;

  const SwiftleadDataTable({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.itemsPerPage = 10,
    this.showLoadMore = true,
    this.onLoadMore,
    this.onExport,
    this.sortComparator,
  });

  @override
  State<SwiftleadDataTable> createState() => _SwiftleadDataTableState();
}

class _SwiftleadDataTableState extends State<SwiftleadDataTable> {
  int _currentPage = 0;
  int? _sortedColumnIndex;
  SortDirection _sortDirection = SortDirection.none;
  String _searchQuery = '';

  List<DataTableRow> get _displayRows {
    var rows = List<DataTableRow>.from(widget.rows);

    // Apply search if needed
    if (_searchQuery.isNotEmpty) {
      // TODO: Implement search functionality
    }

    // Apply sorting
    if (_sortedColumnIndex != null && _sortDirection != SortDirection.none) {
      rows = _sortRows(rows);
    }

    // Apply pagination
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, rows.length);
    return rows.sublist(startIndex, endIndex);
  }

  bool get _hasMorePages {
    return (_currentPage + 1) * widget.itemsPerPage < widget.rows.length;
  }

  List<DataTableRow> _sortRows(List<DataTableRow> rows) {
    if (_sortedColumnIndex == null || _sortDirection == SortDirection.none) {
      return rows;
    }

    // Use custom sort comparator if provided
    if (widget.sortComparator != null) {
      return widget.sortComparator!(_sortedColumnIndex!, _sortDirection, List.from(rows));
    }

    // Default sorting: Extract text from first cell and sort alphabetically
    // This is a basic implementation - for production, use sortComparator
    final sorted = List<DataTableRow>.from(rows);
    sorted.sort((a, b) {
      if (a.cells.isEmpty || b.cells.isEmpty || _sortedColumnIndex! >= a.cells.length || _sortedColumnIndex! >= b.cells.length) {
        return 0;
      }

      final aWidget = a.cells[_sortedColumnIndex!];
      final bWidget = b.cells[_sortedColumnIndex!];

      // Extract text from Text widgets
      String aText = '';
      String bText = '';

      if (aWidget is Text) {
        aText = aWidget.data ?? '';
      }
      if (bWidget is Text) {
        bText = bWidget.data ?? '';
      }

      // Try to parse as numbers
      final aNum = double.tryParse(aText.replaceAll(RegExp(r'[£,\s]'), ''));
      final bNum = double.tryParse(bText.replaceAll(RegExp(r'[£,\s]'), ''));
      
      if (aNum != null && bNum != null) {
        final comparison = aNum.compareTo(bNum);
        return _sortDirection == SortDirection.ascending ? comparison : -comparison;
      }

      // String comparison
      final comparison = aText.compareTo(bText);
      return _sortDirection == SortDirection.ascending ? comparison : -comparison;
    });

    return sorted;
  }

  void _onColumnTap(int columnIndex) {
    if (!widget.columns[columnIndex].sortable) return;

    setState(() {
      if (_sortedColumnIndex == columnIndex) {
        // Cycle: ascending → descending → none
        switch (_sortDirection) {
          case SortDirection.none:
            _sortDirection = SortDirection.ascending;
            break;
          case SortDirection.ascending:
            _sortDirection = SortDirection.descending;
            break;
          case SortDirection.descending:
            _sortDirection = SortDirection.none;
            _sortedColumnIndex = null;
            break;
        }
      } else {
        _sortedColumnIndex = columnIndex;
        _sortDirection = SortDirection.ascending;
      }
    });
  }

  void _loadMore() {
    if (_hasMorePages) {
      setState(() {
        _currentPage++;
      });
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayRows = _displayRows;

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (widget.onExport != null)
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: widget.onExport,
                  tooltip: 'Export',
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Table
          if (displayRows.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceXL),
                child: Text(
                  'No data available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Column Headers
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: widget.columns.asMap().entries.map((entry) {
                      final index = entry.key;
                      final column = entry.value;
                      final isSorted = _sortedColumnIndex == index;
                      final width = column.width ?? (1.0 / widget.columns.length);

                      return Expanded(
                        flex: (width * 100).toInt(),
                        child: GestureDetector(
                          onTap: column.sortable ? () => _onColumnTap(index) : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SwiftleadTokens.spaceS,
                              vertical: SwiftleadTokens.spaceM,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  column.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSorted
                                            ? const Color(SwiftleadTokens.primaryTeal)
                                            : null,
                                      ),
                                  textAlign: column.alignment,
                                ),
                                if (isSorted && column.sortable) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    _sortDirection == SortDirection.ascending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 16,
                                    color: const Color(SwiftleadTokens.primaryTeal),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Table Rows
                ...displayRows.map((row) {
                  return InkWell(
                    onTap: row.onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: widget.columns.asMap().entries.map((entry) {
                          final index = entry.key;
                          final column = entry.value;
                          final width = column.width ?? (1.0 / widget.columns.length);
                          final cell = index < row.cells.length
                              ? row.cells[index]
                              : const SizedBox.shrink();

                          return Expanded(
                            flex: (width * 100).toInt(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SwiftleadTokens.spaceS,
                                vertical: SwiftleadTokens.spaceM,
                              ),
                              child: Align(
                                alignment: column.alignment == TextAlign.right
                                    ? Alignment.centerRight
                                    : column.alignment == TextAlign.center
                                        ? Alignment.center
                                        : Alignment.centerLeft,
                                child: cell,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ],
            ),

          // Pagination / Load More
          if (widget.showLoadMore && _hasMorePages) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            Center(
              child: PrimaryButton(
                label: 'Load More',
                onPressed: _loadMore,
                icon: Icons.expand_more,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

