import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';
import '../global/toast.dart';

/// BookingCard - Card with client, service, time, status + quick actions
/// Exact specification from UI_Inventory_v2.5.1
/// v2.5.1 Enhancement: Swipe gestures for quick status change
class BookingCard extends StatelessWidget {
  final String bookingId;
  final String clientName;
  final String serviceName;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'confirmed', 'pending', 'completed', 'cancelled'
  final String? location;
  final bool hasDeposit;
  final bool reminderSent;
  final VoidCallback? onTap;
  final Function()? onMessage;
  final Function()? onReschedule;
  final Function()? onCancel;
  final Function()? onComplete;
  final Function()? onStatusChange; // Callback for swipe status changes

  const BookingCard({
    super.key,
    required this.bookingId,
    required this.clientName,
    required this.serviceName,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.location,
    this.hasDeposit = false,
    this.reminderSent = false,
    this.onTap,
    this.onMessage,
    this.onReschedule,
    this.onCancel,
    this.onComplete,
    this.onStatusChange,
  });

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Duration get duration => endTime.difference(startTime);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(SwiftleadTokens.successGreen);
      case 'pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'completed':
        return const Color(SwiftleadTokens.textSecondaryLight);
      case 'cancelled':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Swipe actions: Swipe right to complete, swipe left to cancel
    final canComplete = status.toLowerCase() != 'completed' && status.toLowerCase() != 'cancelled';
    final canCancel = status.toLowerCase() != 'cancelled' && status.toLowerCase() != 'completed';

    return Dismissible(
      key: Key(bookingId),
      direction: DismissDirection.horizontal,
      background: canComplete ? Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              color: Color(SwiftleadTokens.successGreen),
              size: 32,
            ),
            SizedBox(width: SwiftleadTokens.spaceS),
            Text(
              'Complete',
              style: TextStyle(
                color: Color(SwiftleadTokens.successGreen),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ) : null,
      secondaryBackground: canCancel ? Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Cancel',
              style: TextStyle(
                color: Color(SwiftleadTokens.errorRed),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: SwiftleadTokens.spaceS),
            Icon(
              Icons.cancel,
              color: Color(SwiftleadTokens.errorRed),
              size: 32,
            ),
          ],
        ),
      ) : null,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd && canComplete) {
          // Swipe right to complete
          onComplete?.call();
          if (onStatusChange != null) {
            onStatusChange!();
          }
          Toast.show(
            context,
            message: 'Booking marked as completed',
            type: ToastType.success,
          );
          return false; // Don't dismiss, just trigger action
        } else if (direction == DismissDirection.endToStart && canCancel) {
          // Swipe left to cancel
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel Booking'),
              content: const Text('Are you sure you want to cancel this booking?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes, Cancel'),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            onCancel?.call();
            if (onStatusChange != null) {
              onStatusChange!();
            }
            Toast.show(
              context,
              message: 'Booking cancelled',
              type: ToastType.success,
            );
          }
          return false; // Don't dismiss, just trigger action
        }
        return false;
      },
      child: Semantics(
        label: 'Booking: $clientName, $serviceName, ${_formatTime(startTime)} to ${_formatTime(endTime)}, $status',
        button: true,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () {
          // Long-press actions: call, message, directions, cancel
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Call Client'),
                    onTap: () {
                      Navigator.pop(context);
                      // Call action would go here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.message),
                    title: const Text('Send Message'),
                    onTap: () {
                      Navigator.pop(context);
                      onMessage?.call();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions),
                    title: const Text('Get Directions'),
                    onTap: () {
                      Navigator.pop(context);
                      // Directions action would go here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Reschedule'),
                    onTap: () {
                      Navigator.pop(context);
                      onReschedule?.call();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cancel, color: Color(SwiftleadTokens.errorRed)),
                    title: const Text('Cancel Booking'),
                    onTap: () {
                      Navigator.pop(context);
                      onCancel?.call();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(startTime),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${duration.inMinutes} minutes',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Client & Service
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        clientName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(SwiftleadTokens.primaryTeal),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          serviceName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Badges Row
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: [
                  if (location != null)
                    SwiftleadBadge(
                      label: location!,
                      variant: BadgeVariant.secondary,
                      size: BadgeSize.small,
                      icon: Icons.location_on,
                    ),
                  if (hasDeposit)
                    SwiftleadBadge(
                      label: 'Deposit',
                      variant: BadgeVariant.secondary,
                      size: BadgeSize.small,
                      icon: Icons.payment,
                    ),
                  if (reminderSent)
                    SwiftleadBadge(
                      label: 'Reminder Sent',
                      variant: BadgeVariant.success,
                      size: BadgeSize.small,
                      icon: Icons.notifications,
                    ),
                ],
              ),
              
              // Quick Actions
              const SizedBox(height: SwiftleadTokens.spaceM),
              const Divider(),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onMessage,
                      icon: Icon(
                        Icons.message,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      label: Text(
                        'Msg',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onReschedule,
                      icon: Icon(
                        Icons.schedule,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      label: Text(
                        'Move',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: onComplete,
                      icon: Icon(
                        Icons.check,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      label: Text(
                        'Done',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          ),
        ),
    );
  }
}
