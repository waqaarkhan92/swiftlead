import 'message.dart';

/// ScheduledMessage - Represents a message scheduled for future delivery
class ScheduledMessage {
  final String id;
  final String threadId;
  final String? contactId;
  final MessageChannel channel;
  final String content;
  final DateTime scheduledFor;
  final DateTime createdAt;
  final ScheduledMessageStatus status;
  final List<String>? mediaUrls;
  final String? sentAt;

  ScheduledMessage({
    required this.id,
    required this.threadId,
    this.contactId,
    required this.channel,
    required this.content,
    required this.scheduledFor,
    required this.createdAt,
    required this.status,
    this.mediaUrls,
    this.sentAt,
  });
}

enum ScheduledMessageStatus {
  pending,
  sent,
  failed,
  cancelled,
}

extension ScheduledMessageStatusExtension on ScheduledMessageStatus {
  String get displayName {
    switch (this) {
      case ScheduledMessageStatus.pending:
        return 'Pending';
      case ScheduledMessageStatus.sent:
        return 'Sent';
      case ScheduledMessageStatus.failed:
        return 'Failed';
      case ScheduledMessageStatus.cancelled:
        return 'Cancelled';
    }
  }
}

