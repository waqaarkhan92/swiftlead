import '../config/mock_config.dart';
import '../models/booking.dart';

/// Mock Bookings Repository
/// Provides realistic mock booking data for Calendar screen preview
class MockBookings {
  static final List<Booking> _bookings = [
    Booking(
      id: '1',
      orgId: 'org_1',
      contactId: '1',
      contactName: 'John Smith',
      serviceId: 'service_1',
      serviceType: 'Boiler Service', // Deprecated
      title: 'Boiler Service',
      description: 'Annual boiler service',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 16)),
      durationMinutes: 120,
      status: BookingStatus.confirmed,
      confirmationStatus: BookingConfirmationStatus.confirmed,
      location: '123 High Street, London SW1A 1AA',
      notes: 'Annual boiler service',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: 'Alex',
    ),
    Booking(
      id: '2',
      orgId: 'org_1',
      contactId: '2',
      contactName: 'Sarah Williams',
      serviceId: 'service_2',
      serviceType: 'Consultation', // Deprecated
      title: 'Consultation',
      description: 'Initial consultation for bathroom renovation',
      startTime: DateTime.now().add(const Duration(hours: 3)),
      endTime: DateTime.now().add(const Duration(hours: 4)),
      durationMinutes: 60,
      status: BookingStatus.confirmed,
      confirmationStatus: BookingConfirmationStatus.confirmed,
      location: '456 Park Lane, London W1K 7AB',
      notes: 'Initial consultation for bathroom renovation',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      assignedTo: 'Sam',
    ),
    Booking(
      id: '3',
      orgId: 'org_1',
      contactId: '5',
      contactName: 'David Brown',
      serviceId: 'service_3',
      serviceType: 'Commercial Maintenance', // Deprecated
      title: 'Commercial Maintenance',
      description: 'Monthly maintenance check',
      startTime: DateTime.now().add(const Duration(days: 3, hours: 9)),
      endTime: DateTime.now().add(const Duration(days: 3, hours: 11)),
      durationMinutes: 120,
      status: BookingStatus.confirmed,
      confirmationStatus: BookingConfirmationStatus.sent,
      location: '321 Commercial Street, London E1 6LP',
      notes: 'Monthly maintenance check',
      reminderSent: false,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedTo: 'Alex',
    ),
    Booking(
      id: '4',
      orgId: 'org_1',
      contactId: '4',
      contactName: 'Emily Chen',
      serviceId: 'service_4',
      serviceType: 'Kitchen Installation', // Deprecated
      title: 'Kitchen Installation',
      description: 'Install new kitchen sink',
      startTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 7, hours: 13)),
      durationMinutes: 180,
      status: BookingStatus.pending,
      confirmationStatus: BookingConfirmationStatus.notSent,
      location: '654 Baker Street, London NW1 6XE',
      notes: 'Install new kitchen sink',
      reminderSent: false,
      depositRequired: true,
      depositAmount: 100.0,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      assignedTo: 'Sam',
      groupAttendees: ['Alex', 'Sam'], // Group booking example
    ),
    Booking(
      id: '5',
      orgId: 'org_1',
      contactId: '3',
      contactName: 'Mike Johnson',
      serviceId: 'service_5',
      serviceType: 'Emergency Repair', // Deprecated
      title: 'Emergency Repair',
      description: 'Emergency leak repair',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      durationMinutes: 120,
      status: BookingStatus.inProgress,
      confirmationStatus: BookingConfirmationStatus.confirmed,
      location: '789 Victoria Road, London SE1 9SG',
      notes: 'Emergency leak repair',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      assignedTo: 'Alex',
      onMyWayStatus: OnMyWayStatus.sent,
      etaMinutes: 15,
    ),
    Booking(
      id: '6',
      orgId: 'org_1',
      contactId: '1',
      contactName: 'John Smith',
      serviceId: 'service_6',
      serviceType: 'Radiator Installation', // Deprecated
      title: 'Radiator Installation',
      description: 'Install 3 new radiators',
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      durationMinutes: 120,
      status: BookingStatus.completed,
      confirmationStatus: BookingConfirmationStatus.confirmed,
      location: '123 High Street, London SW1A 1AA',
      notes: 'Install 3 new radiators',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      completedAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      assignedTo: 'Sam',
    ),
  ];

  /// Fetch all bookings
  static Future<List<Booking>> fetchAll() async {
    await simulateDelay();
    logMockOperation('Fetched ${_bookings.length} bookings');
    return List.from(_bookings);
  }

  /// Fetch booking by ID
  static Future<Booking?> fetchById(String id) async {
    await simulateDelay();
    final booking = _bookings.where((b) => b.id == id).firstOrNull;
    logMockOperation('Fetched booking: ${booking?.serviceType ?? "Not found"}');
    return booking;
  }

  /// Fetch bookings for date range
  static Future<List<Booking>> fetchByDateRange(DateTime start, DateTime end) async {
    await simulateDelay();
    final results = _bookings.where((b) =>
        b.startTime.isAfter(start) &&
        b.startTime.isBefore(end)).toList();
    logMockOperation('Fetched bookings for date range: ${results.length} results');
    return results;
  }

  /// Fetch today's bookings
  static Future<List<Booking>> fetchToday() async {
    await simulateDelay();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final results = _bookings.where((b) =>
        b.startTime.isAfter(startOfDay) &&
        b.startTime.isBefore(endOfDay)).toList();
    logMockOperation('Fetched today\'s bookings: ${results.length} results');
    return results;
  }

  /// Get booking count by status
  static Future<Map<BookingStatus, int>> getCountByStatus() async {
    await simulateDelay();
    final counts = <BookingStatus, int>{};
    for (final status in BookingStatus.values) {
      counts[status] = _bookings.where((b) => b.status == status).length;
    }
    logMockOperation('Booking count by status: $counts');
    return counts;
  }

  /// Get upcoming bookings
  static Future<List<Booking>> getUpcoming() async {
    await simulateDelay();
    final now = DateTime.now();
    final results = _bookings.where((b) =>
        b.startTime.isAfter(now) &&
        (b.status == BookingStatus.confirmed || b.status == BookingStatus.pending))
        .toList();
    results.sort((a, b) => a.startTime.compareTo(b.startTime));
    logMockOperation('Fetched upcoming bookings: ${results.length} results');
    return results;
  }
}

/// Booking model - Matches backend `bookings` table schema
class Booking {
  // Primary keys
  final String id;
  final String? orgId; // Required for backend RLS - nullable for backward compatibility
  
  // Foreign keys
  final String contactId;
  final String? serviceId; // FK services nullable (was serviceType string)
  final String? assignedTo; // FK users nullable
  
  // Core fields
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes; // Backend: duration_minutes
  final BookingStatus status;
  final BookingConfirmationStatus? confirmationStatus; // Backend: confirmation_status enum
  final String title; // Backend: title
  final String? description; // Backend: description
  final String? location; // Backend: location (was address)
  final String? notes; // Backend: notes
  
  // Recurring
  final bool recurring;
  final String? recurringPatternId; // FK nullable
  final String? recurringInstanceOf; // FK bookings nullable
  
  // Deposits
  final bool depositRequired;
  final double? depositAmount;
  final bool depositPaid;
  
  // Calendar sync
  final String? googleCalendarEventId; // nullable
  final String? appleCalendarEventId; // nullable
  
  // Additional fields
  final bool onWaitlist;
  final List<String>? groupAttendees; // jsonb nullable - array of user IDs
  final BookingAssignmentMethod? assignmentMethod; // enum nullable
  
  // "On My Way" fields
  final OnMyWayStatus? onMyWayStatus; // enum nullable
  final String? liveLocationUrl; // text nullable
  final int? etaMinutes; // int nullable
  
  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt; // Not in backend, but useful for UI
  
  // Denormalized fields (for UI convenience, not in backend)
  final String? contactName; // Can be joined from contacts table
  final String? serviceType; // Deprecated - use serviceId instead
  final bool reminderSent; // Not in backend (may be in booking_reminders table)
  
  // Backward compatibility: computed properties
  String get address => location ?? '';
  Duration get duration => endTime.difference(startTime);

  Booking({
    required this.id,
    this.orgId,
    required this.contactId,
    this.serviceId,
    this.assignedTo,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.status,
    this.confirmationStatus,
    required this.title,
    this.description,
    this.location,
    this.notes,
    this.recurring = false,
    this.recurringPatternId,
    this.recurringInstanceOf,
    this.depositRequired = false,
    this.depositAmount,
    this.depositPaid = false,
    this.googleCalendarEventId,
    this.appleCalendarEventId,
    this.onWaitlist = false,
    this.groupAttendees,
    this.assignmentMethod,
    this.onMyWayStatus,
    this.liveLocationUrl,
    this.etaMinutes,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    // Denormalized/backward compatibility
    this.contactName,
    this.serviceType,
    this.reminderSent = false,
  });
  
  /// Create from backend JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      orgId: json['org_id'] as String?,
      contactId: json['contact_id'] as String,
      serviceId: json['service_id'] as String?,
      assignedTo: json['assigned_to'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      durationMinutes: json['duration_minutes'] as int,
      status: BookingStatusExtension.fromBackend(json['status'] as String),
      confirmationStatus: json['confirmation_status'] != null
          ? BookingConfirmationStatusExtension.fromBackend(json['confirmation_status'] as String)
          : null,
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      recurring: json['recurring'] as bool? ?? false,
      recurringPatternId: json['recurring_pattern_id'] as String?,
      recurringInstanceOf: json['recurring_instance_of'] as String?,
      depositRequired: json['deposit_required'] as bool? ?? false,
      depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
      depositPaid: json['deposit_paid'] as bool? ?? false,
      googleCalendarEventId: json['google_calendar_event_id'] as String?,
      appleCalendarEventId: json['apple_calendar_event_id'] as String?,
      onWaitlist: json['on_waitlist'] as bool? ?? false,
      groupAttendees: (json['group_attendees'] as List?)?.cast<String>(),
      assignmentMethod: json['assignment_method'] != null
          ? BookingAssignmentMethodExtension.fromBackend(json['assignment_method'] as String)
          : null,
      onMyWayStatus: json['on_my_way_status'] != null
          ? OnMyWayStatusExtension.fromBackend(json['on_my_way_status'] as String)
          : null,
      liveLocationUrl: json['live_location_url'] as String?,
      etaMinutes: json['eta_minutes'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  
  /// Convert to backend JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'contact_id': contactId,
      'service_id': serviceId,
      'assigned_to': assignedTo,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status.backendValue,
      'confirmation_status': confirmationStatus?.backendValue,
      'title': title,
      'description': description,
      'location': location,
      'notes': notes,
      'recurring': recurring,
      'recurring_pattern_id': recurringPatternId,
      'recurring_instance_of': recurringInstanceOf,
      'deposit_required': depositRequired,
      'deposit_amount': depositAmount,
      'deposit_paid': depositPaid,
      'google_calendar_event_id': googleCalendarEventId,
      'apple_calendar_event_id': appleCalendarEventId,
      'on_waitlist': onWaitlist,
      'group_attendees': groupAttendees,
      'assignment_method': assignmentMethod?.backendValue,
      'on_my_way_status': onMyWayStatus?.backendValue,
      'live_location_url': liveLocationUrl,
      'eta_minutes': etaMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Booking confirmation status - Matches backend enum
enum BookingConfirmationStatus {
  notSent,
  sent,
  confirmed,
  declined,
}

extension BookingConfirmationStatusExtension on BookingConfirmationStatus {
  String get displayName {
    switch (this) {
      case BookingConfirmationStatus.notSent:
        return 'Not Sent';
      case BookingConfirmationStatus.sent:
        return 'Sent';
      case BookingConfirmationStatus.confirmed:
        return 'Confirmed';
      case BookingConfirmationStatus.declined:
        return 'Declined';
    }
  }
  
  String get backendValue {
    switch (this) {
      case BookingConfirmationStatus.notSent:
        return 'not_sent';
      case BookingConfirmationStatus.sent:
        return 'sent';
      case BookingConfirmationStatus.confirmed:
        return 'confirmed';
      case BookingConfirmationStatus.declined:
        return 'declined';
    }
  }
  
  static BookingConfirmationStatus fromBackend(String value) {
    switch (value) {
      case 'not_sent':
        return BookingConfirmationStatus.notSent;
      case 'sent':
        return BookingConfirmationStatus.sent;
      case 'confirmed':
        return BookingConfirmationStatus.confirmed;
      case 'declined':
        return BookingConfirmationStatus.declined;
      default:
        return BookingConfirmationStatus.notSent;
    }
  }
}

/// Booking assignment method - Matches backend enum
enum BookingAssignmentMethod {
  manual,
  roundRobin,
  skillBased,
}

extension BookingAssignmentMethodExtension on BookingAssignmentMethod {
  String get backendValue {
    switch (this) {
      case BookingAssignmentMethod.manual:
        return 'manual';
      case BookingAssignmentMethod.roundRobin:
        return 'round_robin';
      case BookingAssignmentMethod.skillBased:
        return 'skill_based';
    }
  }
  
  static BookingAssignmentMethod fromBackend(String value) {
    switch (value) {
      case 'manual':
        return BookingAssignmentMethod.manual;
      case 'round_robin':
        return BookingAssignmentMethod.roundRobin;
      case 'skill_based':
        return BookingAssignmentMethod.skillBased;
      default:
        return BookingAssignmentMethod.manual;
    }
  }
}

/// On My Way status - Matches backend enum
enum OnMyWayStatus {
  notSent,
  sent,
  arrived,
}

extension OnMyWayStatusExtension on OnMyWayStatus {
  String get displayName {
    switch (this) {
      case OnMyWayStatus.notSent:
        return 'Not Sent';
      case OnMyWayStatus.sent:
        return 'Sent';
      case OnMyWayStatus.arrived:
        return 'Arrived';
    }
  }
  
  String get backendValue {
    switch (this) {
      case OnMyWayStatus.notSent:
        return 'not_sent';
      case OnMyWayStatus.sent:
        return 'sent';
      case OnMyWayStatus.arrived:
        return 'arrived';
    }
  }
  
  static OnMyWayStatus fromBackend(String value) {
    switch (value) {
      case 'not_sent':
        return OnMyWayStatus.notSent;
      case 'sent':
        return OnMyWayStatus.sent;
      case 'arrived':
        return OnMyWayStatus.arrived;
      default:
        return OnMyWayStatus.notSent;
    }
  }
}

/// Booking status - Matches backend enum: pending/confirmed/in_progress/completed/cancelled/no_show
enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.noShow:
        return 'No Show';
    }
  }
  
  String get backendValue {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.inProgress:
        return 'in_progress';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.noShow:
        return 'no_show';
    }
  }
  
  static BookingStatus fromBackend(String value) {
    switch (value) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'in_progress':
        return BookingStatus.inProgress;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'no_show':
        return BookingStatus.noShow;
      default:
        return BookingStatus.pending;
    }
  }
}
