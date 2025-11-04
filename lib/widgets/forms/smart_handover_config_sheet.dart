import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// SmartHandoverConfigSheet - Configure smart handover settings
/// Note: Backend verification needed once backend is wired
class SmartHandoverConfigSheet {
  static Future<void> show({
    required BuildContext context,
    bool initialEnabled = false,
    Set<String> initialTriggers = const {'sentiment', 'complexity'},
  }) async {
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'Smart Handover',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool enabled = initialEnabled;
          Set<String> selectedTriggers = Set.from(initialTriggers);
          
          final availableTriggers = {
            'sentiment': 'Negative Sentiment',
            'complexity': 'Complex Questions',
            'keywords': 'Specific Keywords',
            'low_confidence': 'Low Confidence Score',
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
                        'AI automatically transfers conversations to your team when conditions are met.',
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
                          'Enable Smart Handover',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Transfer with full context',
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
                // Handover triggers
                Text(
                  'Handover Triggers',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  runSpacing: SwiftleadTokens.spaceS,
                  children: availableTriggers.entries.map((entry) {
                    final isSelected = selectedTriggers.contains(entry.key);
                    return SwiftleadChip(
                      label: entry.value,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTriggers.remove(entry.key);
                          } else {
                            selectedTriggers.add(entry.key);
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
                  // TODO: Save smart handover config
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

