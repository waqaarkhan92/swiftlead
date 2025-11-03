import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// MoneyFilterSheet - Filter money transactions
/// Exact specification from UI_Inventory_v2.5.1
class MoneyFilterSheet {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    Map<String, dynamic>? initialFilters,
  }) async {
    Map<String, dynamic> filters = {
      'type': initialFilters?['type'] ?? 'All',
      'status': initialFilters?['status'] ?? 'All',
      'dateRange': initialFilters?['dateRange'] ?? 'All',
    };

    return await SwiftleadBottomSheet.show<Map<String, dynamic>>(
      context: context,
      title: 'Filter Transactions',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Type Filter
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: ['All', 'Invoice', 'Payment', 'Quote', 'Expense'].map((type) {
                      final isSelected = filters['type'] == type;
                      return SwiftleadChip(
                        label: type,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            filters['type'] = type;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Status Filter
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: ['All', 'Paid', 'Pending', 'Overdue', 'Cancelled'].map((status) {
                      final isSelected = filters['status'] == status;
                      return SwiftleadChip(
                        label: status,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            filters['status'] = status;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Date Range Filter
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date Range',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: ['All', 'Today', 'This Week', 'This Month', 'This Year'].map((range) {
                      final isSelected = filters['dateRange'] == range;
                      return SwiftleadChip(
                        label: range,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            filters['dateRange'] = range;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Apply Filters',
                    onPressed: () => Navigator.pop(context, filters),
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

