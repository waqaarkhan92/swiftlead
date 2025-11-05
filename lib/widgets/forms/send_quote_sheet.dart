import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';

/// Send Quote Sheet - Send quote via SMS/Email/WhatsApp
/// Exact specification from UI_Inventory_v2.5.1
class SendQuoteSheet {
  static void show({
    required BuildContext context,
    required String quoteId,
    required String quoteNumber,
    required String clientName,
    required double amount,
    Function(List<String> methods)? onSent,
  }) {
    bool isSending = false;
    List<String> selectedMethods = [];

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Send Quote',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Quote Info
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  const Icon(
                    Icons.description,
                    size: 24,
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quote #$quoteNumber',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$clientName • £${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            if (isSending)
              Column(
                children: [
                  const SwiftleadProgressBar(),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Text(
                    'Sending quote...',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else ...[
              // Message Preview
              Text(
                'Message Preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Text(
                  'Hi $clientName,\n\nI\'ve prepared a quote for you. Please review and let me know if you have any questions.\n\nTotal: £${amount.toStringAsFixed(2)}\n\n[View Quote Link]',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),

              // Send Methods
              Text(
                'Send Via',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: ['SMS', 'Email', 'WhatsApp', 'Inbox'].map((method) {
                  final isSelected = selectedMethods.contains(method);
                  return SwiftleadChip(
                    label: method,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedMethods.remove(method);
                        } else {
                          selectedMethods.add(method);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),

              // Send Button
              if (selectedMethods.isNotEmpty)
                PrimaryButton(
                  label: 'Send via ${selectedMethods.join(", ")}',
                  onPressed: () async {
                    setState(() {
                      isSending = true;
                    });

                    try {
                      // Simulate API call
                      await Future.delayed(const Duration(seconds: 2));

                      if (context.mounted) {
                        Toast.show(
                          context,
                          message: 'Quote sent successfully',
                          type: ToastType.success,
                        );
                        onSent?.call(selectedMethods);
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        setState(() {
                          isSending = false;
                        });
                        Toast.show(
                          context,
                          message: 'Failed to send quote',
                          type: ToastType.error,
                        );
                      }
                    }
                  },
                  icon: Icons.send,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

