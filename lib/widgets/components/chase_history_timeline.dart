import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// ChaseHistoryTimeline - Timeline of payment reminder attempts
/// Exact specification from UI_Inventory_v2.5.1
class ChaseHistoryTimeline extends StatelessWidget {
  final List<ChaseRecord> chaseRecords;

  const ChaseHistoryTimeline({
    super.key,
    required this.chaseRecords,
  });

  @override
  Widget build(BuildContext context) {
    if (chaseRecords.isEmpty) {
      return const SizedBox.shrink();
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                size: 20,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Payment Reminder History',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chaseRecords.length,
            separatorBuilder: (context, index) => const SizedBox(height: SwiftleadTokens.spaceS),
            itemBuilder: (context, index) {
              final record = chaseRecords[index];
              final isLast = index == chaseRecords.length - 1;
              
              return _TimelineItem(
                record: record,
                isLast: isLast,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ChaseRecord record;
  final bool isLast;

  const _TimelineItem({
    required this.record,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (record.status) {
      case ChaseStatus.sent:
        icon = Icons.send;
        iconColor = const Color(SwiftleadTokens.primaryTeal);
        break;
      case ChaseStatus.delivered:
        icon = Icons.done;
        iconColor = const Color(SwiftleadTokens.successGreen);
        break;
      case ChaseStatus.opened:
        icon = Icons.mark_email_read;
        iconColor = const Color(SwiftleadTokens.successGreen);
        break;
      case ChaseStatus.failed:
        icon = Icons.error;
        iconColor = const Color(SwiftleadTokens.errorRed);
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline connector
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        
        // Timeline content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      record.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  SwiftleadBadge(
                    label: record.channel.displayName,
                    variant: BadgeVariant.secondary,
                    size: BadgeSize.small,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(record.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (record.errorMessage != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: const Color(SwiftleadTokens.errorRed),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: Text(
                          record.errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(SwiftleadTokens.errorRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Chase record model
class ChaseRecord {
  final String message;
  final DateTime timestamp;
  final ChaseStatus status;
  final ChaseChannel channel;
  final String? errorMessage;

  ChaseRecord({
    required this.message,
    required this.timestamp,
    required this.status,
    required this.channel,
    this.errorMessage,
  });
}

/// Chase status enum
enum ChaseStatus {
  sent,
  delivered,
  opened,
  failed,
}

/// Chase channel enum
enum ChaseChannel {
  email,
  sms,
  whatsapp,
}

extension ChaseChannelExtension on ChaseChannel {
  String get displayName {
    switch (this) {
      case ChaseChannel.email:
        return 'Email';
      case ChaseChannel.sms:
        return 'SMS';
      case ChaseChannel.whatsapp:
        return 'WhatsApp';
    }
  }
}

