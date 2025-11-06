import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// JobsFilterSheet - Filter jobs by status, date, service type, etc.
/// Exact specification from UI_Inventory_v2.5.1
class JobsFilterSheet {
  static Future<JobsFilters?> show({
    required BuildContext context,
    JobsFilters? initialFilters,
  }) async {
    // Create a new instance to avoid mutating the original
    JobsFilters filters = JobsFilters();
    if (initialFilters != null) {
      filters.statusFilters = List.from(initialFilters.statusFilters);
      filters.serviceTypeFilters = List.from(initialFilters.serviceTypeFilters);
      filters.dateRange = initialFilters.dateRange;
    }

    return await SwiftleadBottomSheet.show<JobsFilters>(
      context: context,
      title: 'Filter Jobs',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Status Filters
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
              children: [
                'All',
                'Proposed',
                'Booked',
                'In Progress',
                'Completed',
                'Cancelled',
              ].map((status) {
                final isSelected = filters.statusFilters.contains(status);
                return SwiftleadChip(
                  label: status,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (status == 'All') {
                        filters.statusFilters = ['All'];
                      } else {
                        // Remove 'All' if it's selected
                        filters.statusFilters.remove('All');
                        if (isSelected) {
                          // Deselect this status
                          filters.statusFilters.remove(status);
                          // If nothing is selected now, add 'All' back
                          if (filters.statusFilters.isEmpty) {
                            filters.statusFilters.add('All');
                          }
                        } else {
                          // Select this status
                          filters.statusFilters.add(status);
                          // Ensure 'All' is not in the list
                          filters.statusFilters.remove('All');
                        }
                      }
                      print('[JOBS FILTER] Chip tapped: $status -> filters: ${filters.statusFilters}');
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Service Type Filters
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
              children: [
                'All',
                'Plumbing',
                'Electrical',
                'Heating',
                'Other',
              ].map((type) {
                final isSelected = filters.serviceTypeFilters.contains(type);
                return SwiftleadChip(
                  label: type,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (type == 'All') {
                        filters.serviceTypeFilters = ['All'];
                      } else {
                        filters.serviceTypeFilters.remove('All');
                        if (isSelected) {
                          filters.serviceTypeFilters.remove(type);
                          if (filters.serviceTypeFilters.isEmpty) {
                            filters.serviceTypeFilters.add('All');
                          }
                        } else {
                          filters.serviceTypeFilters.add(type);
                          filters.serviceTypeFilters.remove('All');
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Date Range
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
              children: [
                'All Time',
                'Today',
                'This Week',
                'This Month',
                'Custom',
              ].map((range) {
                final isSelected = filters.dateRange == range;
                return SwiftleadChip(
                  label: range,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      filters.dateRange = range;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceXL),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Return empty filters (cleared)
                      final clearedFilters = JobsFilters();
                      Navigator.pop(context, clearedFilters);
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Apply Filters',
                    onPressed: () {
                      print('[JOBS FILTER] Apply button clicked: statusFilters=${filters.statusFilters}, serviceTypeFilters=${filters.serviceTypeFilters}, dateRange=${filters.dateRange}');
                      Navigator.pop(context, filters);
                    },
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

class JobsFilters {
  List<String> statusFilters = ['All'];
  List<String> serviceTypeFilters = ['All'];
  String dateRange = 'All Time';
}

