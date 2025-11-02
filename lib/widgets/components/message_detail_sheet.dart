import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/avatar.dart';
import '../global/badge.dart';

/// Message Detail Sheet - Detailed message information
/// Exact specification from UI_Inventory_v2.5.1
class MessageDetailSheet {
  static void show({
    required BuildContext context,
    required String messageId,
    String? messageContent,
    String? senderName,
    String? senderAvatar,
    DateTime? timestamp,
    String? status, // 'sending', 'sent', 'delivered', 'read', 'failed'
    String? channel,
    Map<String, dynamic>? metadata,
  }) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Message Details',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Sender Info
          if (senderName != null || senderAvatar != null)
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  SwiftleadAvatar(
                    imageUrl: senderAvatar,
                    size: AvatarSize.large,
                    initials: senderName?[0],
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (senderName != null)
                          Text(
                            senderName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (channel != null) ...[
                          const SizedBox(height: 4),
                          SwiftleadBadge(
                            label: channel,
                            variant: BadgeVariant.secondary,
                            size: BadgeSize.small,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          if (senderName != null) const SizedBox(height: SwiftleadTokens.spaceM),

          // Message Content
          if (messageContent != null) ...[
            Text(
              'Message',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Text(
                messageContent,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],

          // Status
          if (status != null) ...[
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  _StatusIcon(status: status),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Text(
                    status.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],

          // Timestamp
          if (timestamp != null) ...[
            Text(
              'Sent',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Text(
                _formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],

          // Metadata
          if (metadata != null && metadata.isNotEmpty) ...[
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: metadata.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} '
           '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusIcon extends StatelessWidget {
  final String status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'sending':
        icon = Icons.access_time;
        color = const Color(SwiftleadTokens.warningYellow);
        break;
      case 'sent':
        icon = Icons.check;
        color = const Color(SwiftleadTokens.infoBlue);
        break;
      case 'delivered':
        icon = Icons.done_all;
        color = const Color(SwiftleadTokens.infoBlue);
        break;
      case 'read':
        icon = Icons.done_all;
        color = const Color(SwiftleadTokens.successGreen);
        break;
      case 'failed':
        icon = Icons.error_outline;
        color = const Color(SwiftleadTokens.errorRed);
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 20, color: color);
  }
}

