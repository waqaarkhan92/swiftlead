import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';

/// PaymentLinkSheet - Create and share payment link for invoice
/// Exact specification from UI_Inventory_v2.5.1
class PaymentLinkSheet {
  static void show({
    required BuildContext context,
    required String invoiceId,
    required String invoiceNumber,
    required double amount,
    Function(String? link)? onLinkCreated,
  }) {
    bool isGenerating = false;
    String? paymentLink;
    List<String> selectedMethods = [];

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Payment Link',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Invoice Info
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt,
                    size: 24,
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice #$invoiceNumber',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Amount: £${amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            if (isGenerating)
              Column(
                children: [
                  const SwiftleadProgressBar(),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Text(
                    'Creating payment link...',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else if (paymentLink == null)
              Column(
                children: [
                  Text(
                    'Generate a secure payment link that your client can use to pay online.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                  PrimaryButton(
                    label: 'Generate Payment Link',
                    onPressed: () async {
                      setState(() {
                        isGenerating = true;
                      });

                      // Simulate API call
                      await Future.delayed(const Duration(seconds: 2));

                      if (context.mounted) {
                        setState(() {
                          isGenerating = false;
                          paymentLink = 'https://pay.swiftlead.co/invoice/$invoiceId';
                        });
                        onLinkCreated?.call(paymentLink);
                      }
                    },
                    icon: Icons.link,
                  ),
                ],
              )
            else ...[
              // Payment Link Generated
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Link',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.05)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                            child: Text(
                              paymentLink!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            // Copy to clipboard
                            Toast.show(
                              context,
                              message: 'Link copied to clipboard',
                              type: ToastType.success,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),

              // Share Methods
              Text(
                'Send Payment Link',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: ['SMS', 'Email', 'WhatsApp'].map((method) {
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
                  onPressed: () {
                    Toast.show(
                      context,
                      message: 'Payment link sent',
                      type: ToastType.success,
                    );
                    Navigator.pop(context);
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

