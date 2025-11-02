import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/confirmation_dialog.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';

/// RefundModal - Process refund for payment
/// Exact specification from UI_Inventory_v2.5.1
class RefundModal {
  static void show({
    required BuildContext context,
    required String paymentId,
    required double amount,
    String? invoiceNumber,
    Function(double refundAmount)? onRefundProcessed,
  }) {
    double refundAmount = amount;
    bool isFullRefund = true;
    String? reason;
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Process Refund'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (invoiceNumber != null) ...[
                  FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt,
                          size: 20,
                          color: Color(SwiftleadTokens.primaryTeal),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        Text(
                          'Invoice #$invoiceNumber',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                ],

                // Refund Type
                Text(
                  'Refund Type',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isFullRefund = true;
                            refundAmount = amount;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isFullRefund
                              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                              : null,
                          side: BorderSide(
                            color: isFullRefund
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('Full Refund'),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isFullRefund = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: !isFullRefund
                              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                              : null,
                          side: BorderSide(
                            color: !isFullRefund
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('Partial Refund'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),

                // Refund Amount
                if (!isFullRefund) ...[
                  Text(
                    'Refund Amount',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '£',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed <= amount) {
                        setState(() {
                          refundAmount = parsed;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                ] else ...[
                  Text(
                    'Refund Amount: £${refundAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                ],

                // Reason
                Text(
                  'Reason (Optional)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter refund reason...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  onChanged: (value) {
                    reason = value;
                  },
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),

                if (isProcessing)
                  const SwiftleadProgressBar(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isProcessing ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: 'Process Refund',
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() {
                        isProcessing = true;
                      });

                      try {
                        // Simulate API call
                        await Future.delayed(const Duration(seconds: 2));

                        if (context.mounted) {
                          Toast.show(
                            context,
                            message: 'Refund processed successfully',
                            type: ToastType.success,
                          );
                          Navigator.pop(context);
                          onRefundProcessed?.call(refundAmount);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() {
                            isProcessing = false;
                          });
                          Toast.show(
                            context,
                            message: 'Refund failed. Please try again.',
                            type: ToastType.error,
                          );
                        }
                      }
                    },
              icon: Icons.refresh,
              size: ButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }
}

