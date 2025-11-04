import '../config/mock_config.dart';
import '../models/booking.dart';

/// Mock Bookings Repository
/// Provides realistic mock booking data for Calendar screen preview
class MockBookings {
  static final List<Booking> _bookings = [
    Booking(
      id: '1',
      contactId: '1',
      contactName: 'John Smith',
      serviceType: 'Boiler Service',
      startTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 16)),
      status: BookingStatus.confirmed,
      address: '123 High Street, London SW1A 1AA',
      notes: 'Annual boiler service',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: 'Alex',
    ),
    Booking(
      id: '2',
      contactId: '2',
      contactName: 'Sarah Williams',
      serviceType: 'Consultation',
      startTime: DateTime.now().add(const Duration(hours: 3)),
      endTime: DateTime.now().add(const Duration(hours: 4)),
      status: BookingStatus.confirmed,
      address: '456 Park Lane, London W1K 7AB',
      notes: 'Initial consultation for bathroom renovation',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      assignedTo: 'Sam',
    ),
    Booking(
      id: '3',
      contactId: '5',
      contactName: 'David Brown',
      serviceType: 'Commercial Maintenance',
      startTime: DateTime.now().add(const Duration(days: 3, hours: 9)),
      endTime: DateTime.now().add(const Duration(days: 3, hours: 11)),
      status: BookingStatus.confirmed,
      address: '321 Commercial Street, London E1 6LP',
      notes: 'Monthly maintenance check',
      reminderSent: false,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedTo: 'Alex',
    ),
    Booking(
      id: '4',
      contactId: '4',
      contactName: 'Emily Chen',
      serviceType: 'Kitchen Installation',
      startTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
      endTime: DateTime.now().add(const Duration(days: 7, hours: 13)),
      status: BookingStatus.pending,
      address: '654 Baker Street, London NW1 6XE',
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
      contactId: '3',
      contactName: 'Mike Johnson',
      serviceType: 'Emergency Repair',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      status: BookingStatus.inProgress,
      address: '789 Victoria Road, London SE1 9SG',
      notes: 'Emergency leak repair',
      reminderSent: true,
      depositRequired: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      assignedTo: 'Alex',
    ),
    Booking(
      id: '6',
      contactId: '1',
      contactName: 'John Smith',
      serviceType: 'Radiator Installation',
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
      status: BookingStatus.completed,
      address: '123 High Street, London SW1A 1AA',
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

/// Booking model
class Booking {
  final String id;
  final String contactId;
  final String contactName;
  final String serviceType;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final String address;
  final String? notes;
  final bool reminderSent;
  final bool depositRequired;
  final double? depositAmount;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? assignedTo; // Team member assignment
  final List<String>? groupAttendees; // For group bookings (multi-person appointments)

  Booking({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.serviceType,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.address,
    this.notes,
    required this.reminderSent,
    required this.depositRequired,
    this.depositAmount,
    required this.createdAt,
    this.completedAt,
    this.assignedTo,
    this.groupAttendees,
  });

  Duration get duration => endTime.difference(startTime);
}

/// Booking status
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
}
