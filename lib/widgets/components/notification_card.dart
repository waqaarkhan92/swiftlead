import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// NotificationCard - Single notification item
/// Exact specification from UI_Inventory_v2.5.1
class NotificationCard extends StatelessWidget {
  final String notificationId;
  final String title;
  final String? message;
  final DateTime timestamp;
  final bool isUnread;
  final String? type;
  final String? channel;
  final VoidCallback? onTap;
  final Function()? onMarkRead;
  final Function()? onArchive;

  const NotificationCard({
    super.key,
    required this.notificationId,
    required this.title,
    this.message,
    required this.timestamp,
    this.isUnread = false,
    this.type,
    this.channel,
    this.onTap,
    this.onMarkRead,
    this.onArchive,
  });

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  IconData _getTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'message':
        return Icons.message;
      case 'payment':
        return Icons.payment;
      case 'job':
        return Icons.work;
      case 'campaign':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(type),
                size: 20,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(SwiftleadTokens.primaryTeal),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                      if (channel != null) ...[
                        const SizedBox(width: 8),
                        SwiftleadBadge(
                          label: channel!,
                          variant: BadgeVariant.secondary,
                          size: BadgeSize.small,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Actions
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18),
              onSelected: (value) {
                switch (value) {
                  case 'mark_read':
                    onMarkRead?.call();
                    break;
                  case 'archive':
                    onArchive?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                if (isUnread)
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: Text('Mark as Read'),
                  ),
                const PopupMenuItem(
                  value: 'archive',
                  child: Text('Archive'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

