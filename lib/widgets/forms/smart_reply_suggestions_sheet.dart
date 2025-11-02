import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/progress_bar.dart';
import '../components/smart_reply_chip.dart';
import '../global/toast.dart';

/// Smart Reply Suggestions Sheet - Shows AI-generated reply options
/// Exact specification from UI_Inventory_v2.5.1
class SmartReplySuggestionsSheet {
  static void show({
    required BuildContext context,
    required String threadId,
    Function(String reply)? onReplySelected,
  }) {
    bool isGenerating = true;
    List<String> suggestions = [];

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Smart Reply Suggestions',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          // Simulate AI generation
          if (isGenerating) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                isGenerating = false;
                suggestions = [
                  'Thanks for your inquiry! I\'d be happy to help.',
                  'Could you provide a bit more detail about what you need?',
                  'Let me check availability and get back to you shortly.',
                ];
              });
            });
          }

          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              if (isGenerating) ...[
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: SwiftleadTokens.spaceM),
                      Text('Generating replies...'),
                    ],
                  ),
                ),
              ] else ...[
                // Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: Color(SwiftleadTokens.primaryTeal),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: Text(
                          'AI suggests these replies based on the conversation context.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(SwiftleadTokens.primaryTeal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceL),
                
                // Suggestions
                ...suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: SmartReplyChip(
                      replyText: suggestion,
                      onTap: () {
                        Navigator.pop(context);
                        onReplySelected?.call(suggestion);
                        Toast.show(
                          context,
                          message: 'Reply inserted',
                          type: ToastType.success,
                        );
                      },
                    ),
                  );
                }).toList(),
                
                if (suggestions.isEmpty) ...[
                  Center(
                    child: Text(
                      'No suggestions available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

