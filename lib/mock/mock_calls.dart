import '../config/mock_config.dart';

/// Mock Calls Repository
/// Provides realistic mock call history data for contact timeline
class MockCalls {
  static final List<CallRecord> _calls = [
    CallRecord(
      id: 'call_1',
      contactId: '1',
      contactName: 'John Smith',
      phoneNumber: '+44 7700 900123',
      direction: CallDirection.inbound,
      duration: const Duration(minutes: 5, seconds: 32),
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: CallStatus.answered,
      recordingUrl: 'https://storage.example.com/calls/call_1.mp3',
      transcript: '''[AI]: Hello, this is Swiftlead Plumbing. How can I help you today?

[Customer]: Hi, my boiler is making strange noises and I'm worried it might break down.

[AI]: I understand that's concerning. Can you describe the type of noise you're hearing?

[Customer]: It's like a banging sound, especially in the morning when it starts up.

[AI]: That sounds like it could be a kettling issue. Would you like me to schedule a technician to come take a look?

[Customer]: Yes, please. When would be the earliest?

[AI]: I can schedule someone for next Tuesday at 2 PM. Would that work for you?

[Customer]: Perfect, thank you!''',
      aiSummary: 'Customer called about boiler repair. Scheduled for next week.',
      sentiment: 'Neutral',
    ),
    CallRecord(
      id: 'call_2',
      contactId: '2',
      contactName: 'Sarah Williams',
      phoneNumber: '+44 7700 900456',
      direction: CallDirection.outbound,
      duration: const Duration(minutes: 3, seconds: 15),
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: CallStatus.answered,
      transcript: '''[Agent]: Hi Sarah, this is Swiftlead calling about your bathroom renovation quote. Do you have a moment?

[Customer]: Yes, I'm interested but I have a few questions about the timeline.

[Agent]: Of course, I'd be happy to help. What questions do you have?

[Customer]: How long would the renovation take?

[Agent]: Typically 2-3 weeks depending on the scope. We can discuss the details in person if you'd like to schedule a visit.''',
      aiSummary: 'Follow-up call about bathroom renovation quote. Customer interested, wants timeline details.',
      sentiment: 'Positive',
    ),
    CallRecord(
      id: 'call_3',
      contactId: '3',
      contactName: 'Mike Johnson',
      phoneNumber: '+44 7700 900789',
      direction: CallDirection.inbound,
      duration: const Duration(seconds: 0),
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      status: CallStatus.missed,
      transcript: null,
      aiSummary: 'Missed call. Customer did not leave voicemail.',
      sentiment: null,
    ),
  ];

  /// Fetch all calls for a contact
  static Future<List<CallRecord>> fetchCallsForContact(String contactId) async {
    await simulateDelay();
    final calls = _calls.where((c) => c.contactId == contactId).toList();
    calls.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    logMockOperation('Fetched ${calls.length} calls for contact: $contactId');
    return calls;
  }

  /// Fetch all calls
  static Future<List<CallRecord>> fetchAllCalls() async {
    await simulateDelay();
    logMockOperation('Fetched ${_calls.length} calls');
    return List.from(_calls);
  }

  /// Record a new call
  static Future<CallRecord> recordCall({
    required String contactId,
    required String contactName,
    required String phoneNumber,
    required CallDirection direction,
    required Duration duration,
    required CallStatus status,
    String? recordingUrl,
    String? transcript,
    String? aiSummary,
    String? sentiment,
  }) async {
    await simulateDelay();
    final call = CallRecord(
      id: 'call_${DateTime.now().millisecondsSinceEpoch}',
      contactId: contactId,
      contactName: contactName,
      phoneNumber: phoneNumber,
      direction: direction,
      duration: duration,
      timestamp: DateTime.now(),
      status: status,
      recordingUrl: recordingUrl,
      transcript: transcript,
      aiSummary: aiSummary,
      sentiment: sentiment,
    );
    _calls.add(call);
    logMockOperation('Recorded call: $contactName');
    return call;
  }
}

/// Call Record model
class CallRecord {
  final String id;
  final String contactId;
  final String contactName;
  final String phoneNumber;
  final CallDirection direction;
  final Duration duration;
  final DateTime timestamp;
  final CallStatus status;
  final String? recordingUrl;
  final String? transcript;
  final String? aiSummary;
  final String? sentiment; // 'Positive', 'Neutral', 'Negative'

  CallRecord({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
    required this.direction,
    required this.duration,
    required this.timestamp,
    required this.status,
    this.recordingUrl,
    this.transcript,
    this.aiSummary,
    this.sentiment,
  });
}

enum CallDirection {
  inbound,
  outbound,
}

enum CallStatus {
  answered,
  missed,
  voicemail,
  declined,
}
