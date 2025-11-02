import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ChatTitleRow - Conversation list item
/// Exact specification from Screen_Layouts_v2.5.1
class ChatTitleRow extends StatelessWidget {
  final String contactName;
  final String? lastMessagePreview;
  final DateTime? timestamp;
  final bool isUnread;
  final bool isPinned;
  final String? channel;
  final bool isTyping;
  final Widget? avatar;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  
  const ChatTitleRow({
    super.key,
    required this.contactName,
    this.lastMessagePreview,
    this.timestamp,
    this.isUnread = false,
    this.isPinned = false,
    this.channel,
    this.isTyping = false,
    this.avatar,
    this.onTap,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contactName),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
        ),
        child: const Icon(Icons.push_pin, color: Color(SwiftleadTokens.primaryTeal)),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
        ),
        child: const Icon(Icons.archive, color: Color(SwiftleadTokens.errorRed)),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onSwipeRight != null) {
          onSwipeRight!();
        } else if (direction == DismissDirection.endToStart && onSwipeLeft != null) {
          onSwipeLeft!();
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceM,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.08),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              if (avatar != null) ...[
                avatar!,
                const SizedBox(width: SwiftleadTokens.spaceM),
              ] else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      contactName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isPinned)
                          const Icon(
                            Icons.push_pin,
                            size: 12,
                            color: Color(SwiftleadTokens.primaryTeal),
                          ),
                        if (isPinned) const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            contactName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                              color: isUnread
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isTyping
                                ? 'Typing...'
                                : (lastMessagePreview ?? ''),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: Color(SwiftleadTokens.primaryTeal),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (timestamp != null) ...[
                const SizedBox(width: SwiftleadTokens.spaceS),
                Text(
                  _formatTimestamp(timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

