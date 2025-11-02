import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';
import 'package:flutter/services.dart';

/// Booking Confirmation Sheet - Confirm booking and send confirmation
/// Exact specification from UI_Inventory_v2.5.1
class BookingConfirmationSheet {
  static void show({
    required BuildContext context,
    required String bookingId,
    required String clientName,
    required DateTime bookingTime,
    required String serviceName,
    String? currentStatus, // 'pending', 'confirmed', 'completed'
    Function(bool confirmed, bool sendNotification)? onConfirmed,
  }) {
    bool isConfirming = false;
    bool isSending = false;
    bool sendNotification = true;
    bool isConfirmed = currentStatus == 'confirmed';

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Booking Confirmation',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          if (isConfirming || isSending) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SwiftleadProgressBar(),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  isSending ? 'Sending confirmation...' : 'Confirming booking...',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              // Booking Info
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clientName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bookingTime.day}/${bookingTime.month}/${bookingTime.year} at ${bookingTime.hour}:${bookingTime.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),

              // Current Status
              if (isConfirmed) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(SwiftleadTokens.successGreen),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      'Already confirmed',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(SwiftleadTokens.successGreen),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
              ],

              // Send Notification Toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notify Client',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Send confirmation to client',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Switch(
                      value: sendNotification,
                      onChanged: (value) {
                        setState(() {
                          sendNotification = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),

              // Confirm Button
              PrimaryButton(
                label: isConfirmed ? 'Send Confirmation Again' : 'Confirm Booking',
                onPressed: () async {
                  setState(() {
                    isConfirming = true;
                  });

                  try {
                    // Simulate API call
                    await Future.delayed(const Duration(seconds: 1));
                    
                    if (sendNotification) {
                      setState(() {
                        isConfirming = false;
                        isSending = true;
                      });
                      
                      await Future.delayed(const Duration(seconds: 1));
                    }

                    if (context.mounted) {
                      HapticFeedback.mediumImpact();
                      Toast.show(
                        context,
                        message: isConfirmed 
                            ? 'Confirmation sent'
                            : 'Booking confirmed',
                        type: ToastType.success,
                      );
                      onConfirmed?.call(true, sendNotification);
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() {
                        isConfirming = false;
                        isSending = false;
                      });
                      Toast.show(
                        context,
                        message: 'Failed to confirm booking',
                        type: ToastType.error,
                      );
                    }
                  }
                },
                icon: isConfirmed ? Icons.send : Icons.check_circle,
              ),
            ],
          );
        },
      ),
    );
  }
}

