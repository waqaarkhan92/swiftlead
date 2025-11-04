import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// EscalationRulesConfigSheet - Configure escalation rules
/// Note: Backend verification needed once backend is wired
class EscalationRulesConfigSheet {
  static Future<void> show({
    required BuildContext context,
    Set<String> initialRules = const {'sentiment', 'complexity'},
  }) async {
    Set<String> selectedRules = Set.from(initialRules);
    
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'Escalation Rules',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          final availableRules = {
            'sentiment': 'Negative Sentiment Detected',
            'complexity': 'Complex Question Asked',
            'keywords': 'Specific Keywords Mentioned',
            'low_confidence': 'Low AI Confidence Score',
            'multiple_attempts': 'Multiple Failed Responses',
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
                        'Configure when AI should escalate conversations to your team.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Rule selection
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: availableRules.entries.map((entry) {
                  final isSelected = selectedRules.contains(entry.key);
                  return SwiftleadChip(
                    label: entry.value,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedRules.remove(entry.key);
                        } else {
                          selectedRules.add(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
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
                label: 'Save Rules',
                onPressed: () {
                  // TODO: Save escalation rules
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

