import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../../models/message.dart';
import '../../widgets/components/chat_bubble.dart' as chat_bubble show ChatBubble, BubbleType, MessageStatus;
import '../../widgets/components/channel_icon_badge.dart';

/// ConversationPreviewSheet - Preview conversation without opening full thread
/// Specification from Product_Definition_v2.5.1 §3.1 (v2.5.1 Enhancement)
/// Matches app theme and design system
class ConversationPreviewSheet extends StatelessWidget {
  final MessageThread thread;

  const ConversationPreviewSheet({
    super.key,
    required this.thread,
  });

  static Future<String?> show({
    required BuildContext context,
    required MessageThread thread,
  }) {
    return SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Preview',
      height: SheetHeight.threeQuarter,
      child: ConversationPreviewSheet(thread: thread),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    // Get last 3 messages for preview
    final previewMessages = thread.messages.take(3).toList();

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Contact Info Header
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
                child: Text(
                  thread.contactName.isNotEmpty ? thread.contactName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Color(SwiftleadTokens.primaryTeal),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.contactName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXXS),
                    Row(
                      children: [
                        ChannelIconBadge(channel: thread.channel.displayName, size: 16),
                        const SizedBox(width: SwiftleadTokens.spaceXS),
                        Text(
                          _formatTimestamp(thread.lastMessageTime),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLight
                                ? const Color(SwiftleadTokens.textSecondaryLight)
                                : const Color(SwiftleadTokens.textSecondaryDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (thread.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: SwiftleadTokens.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.badgeCountRed),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                  ),
                  child: Text(
                    '${thread.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),

        // Recent Messages Preview
        Text(
          'Recent Messages',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),

        if (previewMessages.isEmpty)
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Center(
              child: Text(
                'No messages yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isLight
                      ? const Color(SwiftleadTokens.textSecondaryLight)
                      : const Color(SwiftleadTokens.textSecondaryDark),
                ),
              ),
            ),
          )
        else
          ...previewMessages.map((message) {
            // Map MessageStatus to ChatBubble MessageStatus
            chat_bubble.MessageStatus? bubbleStatus;
            switch (message.status) {
              case MessageStatus.sent:
                bubbleStatus = chat_bubble.MessageStatus.sent;
                break;
              case MessageStatus.delivered:
                bubbleStatus = chat_bubble.MessageStatus.delivered;
                break;
              case MessageStatus.read:
                bubbleStatus = chat_bubble.MessageStatus.read;
                break;
              case MessageStatus.failed:
                bubbleStatus = chat_bubble.MessageStatus.failed;
                break;
              case MessageStatus.sending:
                bubbleStatus = chat_bubble.MessageStatus.sending;
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: chat_bubble.ChatBubble(
                message: message.content,
                type: message.isInbound
                    ? chat_bubble.BubbleType.inbound
                    : chat_bubble.BubbleType.outbound,
                timestamp: _formatTimestamp(message.timestamp),
                status: bubbleStatus,
              ),
            );
          }),

        const SizedBox(height: SwiftleadTokens.spaceL),

        // Quick Actions
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),

        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
          child: Column(
            children: [
              _QuickActionTile(
                icon: Icons.message_outlined,
                title: 'Open Conversation',
                onTap: () {
                  Navigator.of(context).pop<String>('open');
                },
              ),
              const Divider(height: 1),
              _QuickActionTile(
                icon: Icons.person_outline,
                title: 'View Contact',
                onTap: () {
                  Navigator.of(context).pop<String>('view_contact');
                },
              ),
              const Divider(height: 1),
              _QuickActionTile(
                icon: Icons.archive_outlined,
                title: 'Archive',
                onTap: () {
                  Navigator.of(context).pop<String>('archive');
                },
              ),
              const Divider(height: 1),
              _QuickActionTile(
                icon: thread.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                title: thread.isPinned ? 'Unpin' : 'Pin',
                onTap: () {
                  Navigator.of(context).pop<String>('toggle_pin');
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: SwiftleadTokens.spaceL),

        // Open Button
        PrimaryButton(
          label: 'Open Full Conversation',
          onPressed: () {
            Navigator.of(context).pop<String>('open');
          },
          icon: Icons.arrow_forward,
        ),

        // Bottom padding for safe area
        const SizedBox(height: SwiftleadTokens.spaceM),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceXS,
      ),
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}

