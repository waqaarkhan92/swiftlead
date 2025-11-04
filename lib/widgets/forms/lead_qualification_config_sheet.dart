import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// LeadQualificationConfigSheet - Configure lead qualification settings
/// Note: Backend verification needed once backend is wired
class LeadQualificationConfigSheet {
  static Future<void> show({
    required BuildContext context,
    bool initialEnabled = false,
    Set<String> initialFields = const {'name', 'service', 'location'},
  }) async {
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'Lead Qualification',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool enabled = initialEnabled;
          Set<String> selectedFields = Set.from(initialFields);
          
          final availableFields = {
            'name': 'Contact Name',
            'service': 'Service Needed',
            'location': 'Postcode/Address',
            'budget': 'Budget Range',
            'timeline': 'Preferred Timeline',
          };
          
          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              // Info banner
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(SwiftleadTokens.infoBlue),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'AI collects essential information before transferring to your team.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Enable toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Lead Qualification',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Collect info before handover',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (value) {
                        setState(() {
                          enabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              if (enabled) ...[
                // Fields to collect
                Text(
                  'Information to Collect',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  runSpacing: SwiftleadTokens.spaceS,
                  children: availableFields.entries.map((entry) {
                    final isSelected = selectedFields.contains(entry.key);
                    return SwiftleadChip(
                      label: entry.value,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedFields.remove(entry.key);
                          } else {
                            selectedFields.add(entry.key);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
              ],
              
              // Note about backend
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceS),
                child: Text(
                  'Note: Backend verification needed once backend is wired.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              PrimaryButton(
                label: 'Save',
                onPressed: () {
                  // TODO: Save lead qualification config
                  Navigator.pop(context);
                },
                icon: Icons.check,
              ),
            ],
          );
        },
      ),
    );
  }
}

