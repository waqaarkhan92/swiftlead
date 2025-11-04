import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';
import 'notification_card.dart';

/// GroupedNotificationCard - Groups multiple notifications by conversation
/// Specification from Product_Definition_v2.5.1 §3.1 (v2.5.1 Enhancement)
class GroupedNotificationCard extends StatefulWidget {
  final List<NotificationData> notifications;
  final String contactName;
  final VoidCallback? onTap;
  final Function(String)? onMarkRead; // notificationId
  final Function(String)? onArchive; // notificationId

  const GroupedNotificationCard({
    super.key,
    required this.notifications,
    required this.contactName,
    this.onTap,
    this.onMarkRead,
    this.onArchive,
  });

  @override
  State<GroupedNotificationCard> createState() => _GroupedNotificationCardState();
}

class _GroupedNotificationCardState extends State<GroupedNotificationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    final unreadCount = widget.notifications.where((n) => n.isUnread).length;
    final hasUnread = unreadCount > 0;
    final count = widget.notifications.length;
    final mostRecent = widget.notifications
        .map((n) => n.timestamp)
        .reduce((a, b) => a.isAfter(b) ? a : b);

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

    return FrostedContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Grouped header (collapsed)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unread indicator
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: hasUnread
                          ? const Color(SwiftleadTokens.primaryTeal)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.message,
                      size: 20,
                      color: Color(SwiftleadTokens.primaryTeal),
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
                                count == 1
                                    ? 'New message from ${widget.contactName}'
                                    : '$count new messages from ${widget.contactName}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SwiftleadTokens.spaceS,
                                  vertical: SwiftleadTokens.spaceXS,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(SwiftleadTokens.primaryTeal),
                                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(mostRecent),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Expand/collapse icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded list of individual notifications
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: isLight
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.08),
            ),
            ...widget.notifications.map((notification) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
              child: NotificationCard(
                notificationId: notification.id,
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                isUnread: notification.isUnread,
                type: notification.type,
                channel: notification.channel,
                onTap: widget.onTap,
                onMarkRead: () => widget.onMarkRead?.call(notification.id),
                onArchive: () => widget.onArchive?.call(notification.id),
              ),
            )),
            const SizedBox(height: SwiftleadTokens.spaceS),
          ],
        ],
      ),
    );
  }
}

/// Notification data structure for grouping
class NotificationData {
  final String id;
  final String title;
  final String? message;
  final DateTime timestamp;
  final bool isUnread;
  final String type;
  final String? channel;
  final String? threadId;

  NotificationData({
    required this.id,
    required this.title,
    this.message,
    required this.timestamp,
    this.isUnread = false,
    required this.type,
    this.channel,
    this.threadId,
  });
}

/// Helper class to group notifications by conversation thread
class NotificationGrouping {
  /// Groups notifications by threadId (for message notifications) or keeps them separate
  static List<Widget> buildGroupedNotifications({
    required List<NotificationData> notifications,
    required BuildContext context,
    VoidCallback? onTap,
    Function(String)? onMarkRead,
    Function(String)? onArchive,
    Function(String)? getContactName, // threadId -> contactName
  }) {
    final Map<String, List<NotificationData>> grouped = {};
    final List<NotificationData> ungrouped = [];

    for (final notification in notifications) {
      // Group message notifications by threadId
      if (notification.type == 'message' && notification.threadId != null) {
        final key = notification.threadId!;
        grouped.putIfAbsent(key, () => []).add(notification);
      } else {
        // Other notifications remain ungrouped
        ungrouped.add(notification);
      }
    }

    final List<Widget> widgets = [];

    // Add grouped notifications
    for (final entry in grouped.entries) {
      final threadId = entry.key;
      final groupNotifications = entry.value;
      final contactName = getContactName?.call(threadId) ?? 'Unknown';
      
      // Sort by timestamp (most recent first)
      groupNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: GroupedNotificationCard(
            notifications: groupNotifications,
            contactName: contactName,
            onTap: onTap,
            onMarkRead: onMarkRead,
            onArchive: onArchive,
          ),
        ),
      );
    }

    // Add ungrouped notifications
    for (final notification in ungrouped) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: NotificationCard(
            notificationId: notification.id,
            title: notification.title,
            message: notification.message,
            timestamp: notification.timestamp,
            isUnread: notification.isUnread,
            type: notification.type,
            channel: notification.channel,
            onTap: onTap,
            onMarkRead: () => onMarkRead?.call(notification.id),
            onArchive: () => onArchive?.call(notification.id),
          ),
        ),
      );
    }

    return widgets;
  }
}

// Export the data class for use in notifications screen

