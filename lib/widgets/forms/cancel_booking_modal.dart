import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/confirmation_dialog.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';

/// Cancel Booking Modal - Cancel a booking with refund options
/// Exact specification from UI_Inventory_v2.5.1
class CancelBookingModal {
  static void show({
    required BuildContext context,
    required String bookingId,
    required String clientName,
    required DateTime bookingTime,
    required String serviceName,
    double? depositAmount,
    bool depositPaid = false,
    Function(bool refund, String? reason)? onCancelled,
  }) {
    String? reason;
    bool refundDeposit = depositPaid && depositAmount != null && depositAmount! > 0;
    bool isCancelling = false;

    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Cancel Booking',
      description: 'Are you sure you want to cancel this booking? This action cannot be undone.',
      icon: Icons.cancel_outlined,
      isDestructive: true,
      primaryActionLabel: 'Yes, Cancel',
    ).then((confirmed) async {
      if (confirmed != true) return;

      // Show refund options if deposit was paid
      if (depositPaid && depositAmount != null && depositAmount! > 0) {
        showDialog(
          context: context,
          builder: (refundContext) => StatefulBuilder(
            builder: (dialogContext, setState) => AlertDialog(
              title: const Text('Refund Deposit'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A deposit of £${depositAmount.toStringAsFixed(2)} was paid for this booking.',
                      style: Theme.of(dialogContext).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                refundDeposit = true;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: refundDeposit
                                  ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                                  : null,
                              side: BorderSide(
                                color: refundDeposit
                                    ? const Color(SwiftleadTokens.primaryTeal)
                                    : Colors.grey,
                              ),
                            ),
                            child: const Text('Refund'),
                          ),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                refundDeposit = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: !refundDeposit
                                  ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                                  : null,
                              side: BorderSide(
                                color: !refundDeposit
                                    ? const Color(SwiftleadTokens.primaryTeal)
                                    : Colors.grey,
                              ),
                            ),
                            child: const Text('Keep'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Cancellation Reason (Optional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                        ),
                      ),
                      onChanged: (value) {
                        reason = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                PrimaryButton(
                  label: 'Confirm Cancellation',
                  onPressed: isCancelling
                      ? null
                      : () async {
                          setState(() {
                            isCancelling = true;
                          });

                          try {
                            // Simulate API call
                            await Future.delayed(const Duration(seconds: 1));

                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                              Toast.show(
                                dialogContext,
                                message: refundDeposit
                                    ? 'Booking cancelled. Refund processing...'
                                    : 'Booking cancelled',
                                type: ToastType.success,
                              );
                              onCancelled?.call(refundDeposit, reason);
                            }
                          } catch (e) {
                            if (dialogContext.mounted) {
                              setState(() {
                                isCancelling = false;
                              });
                              Toast.show(
                                dialogContext,
                                message: 'Failed to cancel booking',
                                type: ToastType.error,
                              );
                            }
                          }
                        },
                  icon: Icons.cancel,
                  size: ButtonSize.small,
                ),
              ],
            ),
          ),
        );
      } else {
        // No deposit, simple cancellation
        try {
          await Future.delayed(const Duration(seconds: 1));

          if (context.mounted) {
            Toast.show(
              context,
              message: 'Booking cancelled',
              type: ToastType.success,
            );
            onCancelled?.call(false, reason);
          }
        } catch (e) {
          if (context.mounted) {
            Toast.show(
              context,
              message: 'Failed to cancel booking',
              type: ToastType.error,
            );
          }
        }
      }
    });
  }
}
