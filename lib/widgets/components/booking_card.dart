import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// BookingCard - Card with client, service, time, status + quick actions
/// Exact specification from UI_Inventory_v2.5.1
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
    return GestureDetector(
      onTap: onTap,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onMessage,
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('Msg'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onReschedule,
                    icon: const Icon(Icons.schedule, size: 18),
                    label: const Text('Move'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onComplete,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

