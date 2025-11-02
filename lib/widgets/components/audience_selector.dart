import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/badge.dart';

/// AudienceSelector - Select target segments
/// Exact specification from UI_Inventory_v2.5.1
class AudienceSegment {
  final String id;
  final String name;
  final int contactCount;
  final String? description;

  AudienceSegment({
    required this.id,
    required this.name,
    required this.contactCount,
    this.description,
  });
}

class AudienceSelector extends StatefulWidget {
  final List<AudienceSegment> segments;
  final Function(List<String> selectedIds)? onSelectionChanged;
  final bool showCount;

  const AudienceSelector({
    super.key,
    required this.segments,
    this.onSelectionChanged,
    this.showCount = true,
  });

  @override
  State<AudienceSelector> createState() => _AudienceSelectorState();
}

class _AudienceSelectorState extends State<AudienceSelector> {
  final Set<String> _selectedIds = {};

  void _toggleSegment(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
    widget.onSelectionChanged?.call(_selectedIds.toList());
  }

  int _getTotalCount() {
    return widget.segments
        .where((s) => _selectedIds.contains(s.id))
        .fold(0, (sum, s) => sum + s.contactCount);
  }

  @override
  Widget build(BuildContext context) {
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
                'Select Audience',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showCount && _selectedIds.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedIds.length} selected',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.showCount && _selectedIds.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              'Total: ${_getTotalCount()} contacts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Segment list
          if (widget.segments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
                child: Column(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 48,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Text(
                      'No segments available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...widget.segments.map((segment) {
              final isSelected = _selectedIds.contains(segment.id);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: GestureDetector(
                  onTap: () => _toggleSegment(segment.id),
                  child: FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    backgroundColor: isSelected
                        ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                        : null,
                    child: Row(
                      children: [
                        // Checkbox
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(SwiftleadTokens.primaryTeal)
                                  : Colors.black.withOpacity(0.2),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceM),
                        
                        // Segment info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                segment.name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (segment.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  segment.description!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        // Contact count
                        if (widget.showCount)
                          SwiftleadBadge(
                            label: '${segment.contactCount}',
                            variant: BadgeVariant.secondary,
                            size: BadgeSize.small,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

