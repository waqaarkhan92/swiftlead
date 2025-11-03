import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';
import '../../models/contact.dart';

/// ContactsFilters - Filter criteria for contacts
class ContactsFilters {
  List<ContactStage> stageFilters = [];
  List<String> scoreFilters = [];
  List<String> sourceFilters = [];
  List<String> tagFilters = [];
  DateTimeRange? dateRange;

  ContactsFilters();
}

/// ContactsFilterSheet - Filter contacts by stage, score, source, tags, date range
/// Exact specification from UI_Inventory_v2.5.1
class ContactsFilterSheet {
  static Future<ContactsFilters?> show({
    required BuildContext context,
    ContactsFilters? initialFilters,
  }) async {
    // Create a new instance to avoid mutating the original
    ContactsFilters filters = ContactsFilters();
    if (initialFilters != null) {
      filters.stageFilters = List.from(initialFilters.stageFilters);
      filters.scoreFilters = List.from(initialFilters.scoreFilters);
      filters.sourceFilters = List.from(initialFilters.sourceFilters);
      filters.tagFilters = List.from(initialFilters.tagFilters);
      filters.dateRange = initialFilters.dateRange;
    }

    return await SwiftleadBottomSheet.show<ContactsFilters>(
      context: context,
      title: 'Filter Contacts',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Stage Filters
            Text(
              'Lifecycle Stage',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ContactStage.values.map((stage) {
                final isSelected = filters.stageFilters.contains(stage);
                return SwiftleadChip(
                  label: stage.displayName,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        filters.stageFilters.remove(stage);
                      } else {
                        filters.stageFilters.add(stage);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Score Filters
            Text(
              'Lead Score',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ['Hot (80+)', 'Warm (60-79)', 'Cold (<60)'].map((score) {
                final isSelected = filters.scoreFilters.contains(score);
                return SwiftleadChip(
                  label: score,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        filters.scoreFilters.remove(score);
                      } else {
                        filters.scoreFilters.add(score);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Source Filters
            Text(
              'Source',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ['Google Ads', 'Facebook', 'Referral', 'Website', 'Other'].map((source) {
                final isSelected = filters.sourceFilters.contains(source);
                return SwiftleadChip(
                  label: source,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        filters.sourceFilters.remove(source);
                      } else {
                        filters.sourceFilters.add(source);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Tag Filters
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ['VIP', 'Repeat Customer', 'New Lead', 'Commercial'].map((tag) {
                final isSelected = filters.tagFilters.contains(tag);
                return SwiftleadChip(
                  label: tag,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        filters.tagFilters.remove(tag);
                      } else {
                        filters.tagFilters.add(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(ContactsFilters());
                    },
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Apply Filters',
                    onPressed: () {
                      Navigator.of(context).pop(filters);
                    },
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],
        ),
      ),
    );
  }
}

