import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// CalendarFilterSheet - Filter calendar bookings
/// Exact specification from UI_Inventory_v2.5.1
class CalendarFilterSheet {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    Map<String, dynamic>? initialFilters,
  }) async {
    Map<String, dynamic> filters = {
      'status': initialFilters?['status'] ?? 'All',
      'serviceType': initialFilters?['serviceType'] ?? 'All',
      'teamMember': initialFilters?['teamMember'] ?? 'All',
      'dateRange': initialFilters?['dateRange'] ?? 'All',
    };

    return await SwiftleadBottomSheet.show<Map<String, dynamic>>(
      context: context,
      title: 'Filter Bookings',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
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
                    children: ['All', 'Confirmed', 'Pending', 'Cancelled', 'Completed'].map((status) {
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

            // Service Type Filter
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: ['All', 'Repairs', 'Installation', 'Maintenance'].map((type) {
                      final isSelected = filters['serviceType'] == type;
                      return SwiftleadChip(
                        label: type,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            filters['serviceType'] = type;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Team Member Filter
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Member',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: ['All', 'Alex', 'Sarah', 'Mike'].map((member) {
                      final isSelected = filters['teamMember'] == member;
                      return SwiftleadChip(
                        label: member,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            filters['teamMember'] = member;
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

