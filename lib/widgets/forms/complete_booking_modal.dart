import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/confirmation_dialog.dart';
import '../global/frosted_container.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';
import '../global/primary_button.dart';
import 'package:flutter/services.dart';
import '../../screens/jobs/create_edit_job_screen.dart';
import 'review_request_sheet.dart';

/// Complete Booking Modal - Mark booking as complete
/// Exact specification from UI_Inventory_v2.5.1
class CompleteBookingModal {
  static void show({
    required BuildContext context,
    required String bookingId,
    required String clientName,
    required String serviceName,
    Function()? onCompleted,
  }) {
    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Complete Booking',
      description: 'Mark this booking as completed? You can request a review after completion.',
      icon: Icons.check_circle_outline,
      isDestructive: false,
      primaryActionLabel: 'Yes, Complete',
    ).then((confirmed) async {
      if (confirmed != true) return;

      // Show completion options
      showDialog(
        context: context,
        builder: (completeContext) => StatefulBuilder(
          builder: (dialogContext, setState) {
            bool isCompleting = false;

            Future<void> completeBooking() async {
              setState(() {
                isCompleting = true;
              });

              try {
                // Simulate API call
                await Future.delayed(const Duration(seconds: 1));

                if (dialogContext.mounted) {
                  HapticFeedback.mediumImpact();
                  Toast.show(
                    dialogContext,
                    message: 'Booking completed',
                    type: ToastType.success,
                  );
                  Navigator.pop(dialogContext);
                  onCompleted?.call();
                }
              } catch (e) {
                if (dialogContext.mounted) {
                  setState(() {
                    isCompleting = false;
                  });
                  Toast.show(
                    dialogContext,
                    message: 'Failed to complete booking',
                    type: ToastType.error,
                  );
                }
              }
            }

            return AlertDialog(
              title: const Text('Complete Booking'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCompleting)
                      const SwiftleadProgressBar()
                    else ...[
                      Text(
                        'Booking completed successfully!',
                        style: Theme.of(dialogContext).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceM),
                      Text(
                        'What would you like to do next?',
                        style: Theme.of(dialogContext).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              actions: isCompleting
                  ? []
                  : [
                      TextButton(
                        onPressed: () {
                          completeBooking();
                        },
                        child: const Text('Close'),
                      ),
                      PrimaryButton(
                        label: 'Request Review',
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          completeBooking().then((_) {
                            ReviewRequestSheet.show(
                              context: context,
                              jobId: bookingId,
                              jobTitle: serviceName,
                              clientName: clientName,
                            );
                          });
                        },
                        icon: Icons.star_outline,
                        size: ButtonSize.small,
                      ),
                      PrimaryButton(
                        label: 'Create Job',
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          completeBooking().then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateEditJobScreen(
                                  initialData: {
                                    'title': serviceName,
                                    'clientName': clientName,
                                  },
                                ),
                              ),
                            );
                          });
                        },
                        icon: Icons.build,
                        size: ButtonSize.small,
                      ),
                    ],
            );
          },
        ),
      );
    });
  }
}
