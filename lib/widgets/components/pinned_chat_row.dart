import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// PinnedChatRow - Fixed row at top with pin icon and quick unpin action
/// Exact specification from UI_Inventory_v2.5.1
class PinnedChatRow extends StatelessWidget {
  final String contactName;
  final String? lastMessage;
  final DateTime? timestamp;
  final int? unreadCount;
  final VoidCallback? onTap;
  final VoidCallback? onUnpin;

  const PinnedChatRow({
    super.key,
    required this.contactName,
    this.lastMessage,
    this.timestamp,
    this.unreadCount,
    this.onTap,
    this.onUnpin,
  });

  String _formatTimestamp(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          children: [
            // Pin icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.push_pin,
                size: 16,
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
                          contactName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  if (lastMessage != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      lastMessage!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Unread badge
            if (unreadCount != null && unreadCount! > 0) ...[
              const SizedBox(width: SwiftleadTokens.spaceS),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4444),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  unreadCount! > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            
            // Unpin button
            IconButton(
              icon: const Icon(Icons.push_pin, size: 18),
              onPressed: onUnpin,
              color: Theme.of(context).textTheme.bodySmall?.color,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

