import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';
import '../../models/message.dart';

/// InboxFilterSheet - Filter messages by date, status, channel, etc.
/// Exact specification from UI_Inventory_v2.5.1
class InboxFilterSheet {
  static Future<InboxFilters?> show({
    required BuildContext context,
    InboxFilters? initialFilters,
  }) async {
    // Create a mutable copy of filters to avoid modifying const sets
    InboxFilters filters = InboxFilters(
      statusFilters: initialFilters != null ? Set<String>.from(initialFilters.statusFilters) : null,
      channelFilters: initialFilters != null ? Set<String>.from(initialFilters.channelFilters) : null,
      priorityFilters: initialFilters != null ? Set<String>.from(initialFilters.priorityFilters) : null,
      leadSourceFilters: initialFilters != null ? Set<String>.from(initialFilters.leadSourceFilters) : null,
      dateRange: initialFilters?.dateRange ?? 'All Time',
      customStartDate: initialFilters?.customStartDate,
      customEndDate: initialFilters?.customEndDate,
    );
    bool hasChanges = false;

    return await SwiftleadBottomSheet.show<InboxFilters>(
      context: context,
      title: 'Filter Messages',
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
                'Unread',
                'Read',
                'Archived',
                'Pinned',
              ].map((status) {
                final isSelected = filters.statusFilters.contains(status);
                return SwiftleadChip(
                  label: status,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      hasChanges = true;
                      if (status == 'All') {
                        filters.statusFilters = {'All'};
                      } else {
                        filters.statusFilters.remove('All');
                        if (isSelected) {
                          filters.statusFilters.remove(status);
                          if (filters.statusFilters.isEmpty) {
                            filters.statusFilters.add('All');
                          }
                        } else {
                          filters.statusFilters.add(status);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Channel Filters
            Text(
              'Channels',
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
                'SMS',
                'WhatsApp',
                'Email',
                'Facebook',
                'Instagram',
              ].map((channel) {
                final isSelected = filters.channelFilters.contains(channel);
                return SwiftleadChip(
                  label: channel,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      hasChanges = true;
                      if (channel == 'All') {
                        filters.channelFilters = {'All'};
                      } else {
                        filters.channelFilters.remove('All');
                        if (isSelected) {
                          filters.channelFilters.remove(channel);
                          if (filters.channelFilters.isEmpty) {
                            filters.channelFilters.add('All');
                          }
                        } else {
                          filters.channelFilters.add(channel);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Priority Filters
            Text(
              'Priority',
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
                'High',
                'Medium',
                'Low',
              ].map((priority) {
                final isSelected = filters.priorityFilters.contains(priority);
                return SwiftleadChip(
                  label: priority,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      hasChanges = true;
                      if (priority == 'All') {
                        filters.priorityFilters = {'All'};
                      } else {
                        filters.priorityFilters.remove('All');
                        if (isSelected) {
                          filters.priorityFilters.remove(priority);
                          if (filters.priorityFilters.isEmpty) {
                            filters.priorityFilters.add('All');
                          }
                        } else {
                          filters.priorityFilters.add(priority);
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
                      hasChanges = true;
                      filters.dateRange = range;
                      if (range == 'Custom') {
                        // TODO: Show date picker
                      } else {
                        filters.customStartDate = null;
                        filters.customEndDate = null;
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (filters.dateRange == 'Custom' && filters.customStartDate != null)
              Padding(
                padding: const EdgeInsets.only(top: SwiftleadTokens.spaceS),
                child: Text(
                  '${filters.customStartDate!.toLocal().toString().split(' ')[0]} to ${filters.customEndDate?.toLocal().toString().split(' ')[0] ?? "..."}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Lead Source Filters (Marketing Attribution)
            Text(
              'Lead Source',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: Text(
                'Marketing attribution source (distinct from message channel)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: [
                'All',
                'Google Ads',
                'Facebook Ads',
                'Website',
                'Referral',
                'Direct',
              ].map((source) {
                final isSelected = filters.leadSourceFilters.contains(source);
                return SwiftleadChip(
                  label: source,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      hasChanges = true;
                      if (source == 'All') {
                        filters.leadSourceFilters = {'All'};
                      } else {
                        filters.leadSourceFilters.remove('All');
                        if (isSelected) {
                          filters.leadSourceFilters.remove(source);
                          if (filters.leadSourceFilters.isEmpty) {
                            filters.leadSourceFilters.add('All');
                          }
                        } else {
                          filters.leadSourceFilters.add(source);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        hasChanges = true;
                        // Reset to defaults with mutable sets
                        filters = InboxFilters();
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Apply Filters',
                    onPressed: () {
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

/// Filter state model
class InboxFilters {
  Set<String> statusFilters;
  Set<String> channelFilters;
  Set<String> priorityFilters;
  Set<String> leadSourceFilters;
  String dateRange;
  DateTime? customStartDate;
  DateTime? customEndDate;

  InboxFilters({
    Set<String>? statusFilters,
    Set<String>? channelFilters,
    Set<String>? priorityFilters,
    Set<String>? leadSourceFilters,
    this.dateRange = 'All Time',
    this.customStartDate,
    this.customEndDate,
  }) : statusFilters = statusFilters ?? {'All'},
       channelFilters = channelFilters ?? {'All'},
       priorityFilters = priorityFilters ?? {'All'},
       leadSourceFilters = leadSourceFilters ?? {'All'};

  int get activeFilterCount {
    int count = 0;
    if (!statusFilters.contains('All')) count += statusFilters.length;
    if (!channelFilters.contains('All')) count += channelFilters.length;
    if (!priorityFilters.contains('All')) count += priorityFilters.length;
    if (!leadSourceFilters.contains('All')) count += leadSourceFilters.length;
    if (dateRange != 'All Time') count += 1;
    return count;
  }
}

