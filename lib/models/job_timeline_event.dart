import 'package:flutter/material.dart';

/// JobTimelineEvent - Represents an event in the job timeline
class JobTimelineEvent {
  final String id;
  final String jobId;
  final JobTimelineEventType eventType;
  final String? eventId; // ID of the related quote/invoice/review/etc
  final String summary;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  final String? userId;
  final String? userName;
  final JobTimelineVisibility visibility;

  JobTimelineEvent({
    required this.id,
    required this.jobId,
    required this.eventType,
    this.eventId,
    required this.summary,
    this.metadata,
    required this.timestamp,
    this.userId,
    this.userName,
    this.visibility = JobTimelineVisibility.teamOnly,
  });
}

enum JobTimelineEventType {
  message,
  booking,
  quote,
  invoice,
  payment,
  review,
  note,
  statusChange,
}

enum JobTimelineVisibility {
  teamOnly,
  clientVisible,
}

extension JobTimelineEventTypeExtension on JobTimelineEventType {
  IconData get icon {
    switch (this) {
      case JobTimelineEventType.message:
        return Icons.message;
      case JobTimelineEventType.booking:
        return Icons.calendar_today;
      case JobTimelineEventType.quote:
        return Icons.description;
      case JobTimelineEventType.invoice:
        return Icons.receipt;
      case JobTimelineEventType.payment:
        return Icons.payment;
      case JobTimelineEventType.review:
        return Icons.star;
      case JobTimelineEventType.note:
        return Icons.note;
      case JobTimelineEventType.statusChange:
        return Icons.update;
    }
  }

  String get displayName {
    switch (this) {
      case JobTimelineEventType.message:
        return 'Message';
      case JobTimelineEventType.booking:
        return 'Booking';
      case JobTimelineEventType.quote:
        return 'Quote';
      case JobTimelineEventType.invoice:
        return 'Invoice';
      case JobTimelineEventType.payment:
        return 'Payment';
      case JobTimelineEventType.review:
        return 'Review';
      case JobTimelineEventType.note:
        return 'Note';
      case JobTimelineEventType.statusChange:
        return 'Status Change';
    }
  }
}

