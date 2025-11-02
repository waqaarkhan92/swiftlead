/// Central Mock Repository
/// Single entry point for all mock data in the application
///
/// Usage:
/// ```dart
/// if (k UseMockData) {
///   final contacts = await MockRepository.contacts.fetchAll();
///   final messages = await MockRepository.messages.fetchAllThreads();
/// }
/// ```

export 'mock_contacts.dart';
export 'mock_messages.dart';
export 'mock_jobs.dart';
export 'mock_bookings.dart';
export 'mock_payments.dart';

import 'mock_contacts.dart';
import 'mock_messages.dart';
import 'mock_jobs.dart';
import 'mock_bookings.dart';
import 'mock_payments.dart';

/// Central mock repository class
class MockRepository {
  /// Contacts repository
  static final contacts = MockContacts;

  /// Messages repository
  static final messages = MockMessages;

  /// Jobs repository
  static final jobs = MockJobs;

  /// Bookings repository
  static final bookings = MockBookings;

  /// Payments & Invoices repository
  static final payments = MockPayments;

  /// Initialize all mock data (if needed)
  static Future<void> initialize() async {
    // Any initialization logic here
    print('[MOCK] Mock repository initialized');
  }

  /// Reset all mock data to initial state
  static void reset() {
    // Reset logic if needed
    print('[MOCK] Mock repository reset');
  }
}
