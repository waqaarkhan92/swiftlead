import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ChatBubble - Message bubble component
/// Specification from UI_Inventory_v2.5.1
enum BubbleType { inbound, outbound }

enum MessageStatus { sending, sent, delivered, read, failed }

class ChatBubble extends StatelessWidget {
  final String message;
  final BubbleType type;
  final MessageStatus? status;
  final String? timestamp;
  final String? senderName;
  final Widget? avatar;
  
  const ChatBubble({
    super.key,
    required this.message,
    required this.type,
    this.status,
    this.timestamp,
    this.senderName,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final isOutbound = type == BubbleType.outbound;
    final brightness = Theme.of(context).brightness;
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        mainAxisAlignment: isOutbound
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOutbound && avatar != null) ...[
            avatar!,
            const SizedBox(width: SwiftleadTokens.spaceS),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isOutbound
                    ? const LinearGradient(
                        colors: [
                          Color(SwiftleadTokens.primaryTeal),
                          Color(SwiftleadTokens.accentAqua),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).colors.first
                    : (brightness == Brightness.light
                        ? Colors.black.withOpacity(0.08)
                        : Colors.white.withOpacity(0.12)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isOutbound ? 22 : 4),
                  bottomRight: Radius.circular(isOutbound ? 4 : 22),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (senderName != null && !isOutbound) ...[
                    Text(
                      senderName!,
                      style: TextStyle(
                        color: isOutbound
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: isOutbound
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 14,
                    ),
                  ),
                  if (timestamp != null || status != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (timestamp != null)
                          Text(
                            timestamp!,
                            style: TextStyle(
                              color: isOutbound
                                  ? Colors.white.withOpacity(0.7)
                                  : Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 11,
                            ),
                          ),
                        if (status != null) ...[
                          if (timestamp != null)
                            const SizedBox(width: 4),
                          _StatusIcon(status: status!),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          if (isOutbound && avatar != null) ...[
            const SizedBox(width: SwiftleadTokens.spaceS),
            avatar!,
          ],
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    double size = 12;
    
    switch (status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        break;
    }
    
    return Icon(
      icon,
      size: size,
      color: status == MessageStatus.failed
          ? Colors.red
          : Colors.white.withOpacity(0.7),
    );
  }
}

