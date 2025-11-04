import '../config/mock_config.dart';
import '../models/message.dart';
import '../models/scheduled_message.dart';
import '../widgets/components/priority_badge.dart';

/// Mock Messages Repository
/// Provides realistic mock message and thread data for Inbox preview
class MockMessages {
  static final List<MessageThread> _threads = [
    MessageThread(
      id: '1',
      contactId: '1',
      contactName: 'John Smith',
      channel: MessageChannel.sms,
      lastMessage: 'Thanks for the quick response! See you tomorrow.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isPinned: true,
      status: MessageStatus.delivered,
      priority: ThreadPriority.high,
      leadSource: LeadSource.googleAds,
      messages: [
        // Older messages (for pagination testing)
        Message(
          id: 'm1_old1',
          threadId: '1',
          contactId: '1',
          content: 'Hello, I saw your ad online.',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm1_old2',
          threadId: '1',
          contactId: '1',
          content: 'Thanks for reaching out! How can I help?',
          timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm1_old3',
          threadId: '1',
          contactId: '1',
          content: 'I need a plumber for my kitchen sink.',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm1_old4',
          threadId: '1',
          contactId: '1',
          content: 'I can help with that. What\'s the issue?',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm1_old5',
          threadId: '1',
          contactId: '1',
          content: 'It\'s leaking under the sink.',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm1_old6',
          threadId: '1',
          contactId: '1',
          content: 'I\'ll come by tomorrow to take a look.',
          timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 7)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        // Recent messages
        Message(
          id: 'm1',
          threadId: '1',
          contactId: '1',
          content: 'Hi, I need help with my boiler. It\'s making strange noises.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm2',
          threadId: '1',
          contactId: '1',
          content: 'I can come take a look tomorrow at 2pm. Does that work for you? Here\'s a photo of a similar issue I fixed last week.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
          hasAttachment: true,
          attachmentUrl: 'https://picsum.photos/800/600?random=2',
        ),
        Message(
          id: 'm3',
          threadId: '1',
          contactId: '1',
          content: 'Thanks for the quick response! See you tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
      ],
    ),
    MessageThread(
      id: '2',
      contactId: '2',
      contactName: 'Sarah Williams',
      channel: MessageChannel.whatsapp,
      lastMessage: 'Can you send me a quote for bathroom renovation?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 2,
      isPinned: false,
      status: MessageStatus.delivered,
      priority: ThreadPriority.medium,
      leadSource: LeadSource.website,
      messages: [
        Message(
          id: 'm4',
          threadId: '2',
          contactId: '2',
          content: 'Hi! I found you on Google.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isInbound: true,
          channel: MessageChannel.whatsapp,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm5',
          threadId: '2',
          contactId: '2',
          content: 'Can you send me a quote for bathroom renovation?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isInbound: true,
          channel: MessageChannel.whatsapp,
          status: MessageStatus.delivered,
        ),
      ],
    ),
    MessageThread(
      id: '3',
      contactId: '3',
      contactName: 'Mike Johnson',
      channel: MessageChannel.email,
      lastMessage: 'Invoice looks good. Processing payment now.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 0,
      isPinned: false,
      status: MessageStatus.delivered,
      priority: ThreadPriority.low,
      leadSource: LeadSource.referral,
      messages: [
        Message(
          id: 'm6',
          threadId: '3',
          contactId: '3',
          content: 'Hi, can you send me the invoice for the recent work?',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isInbound: true,
          channel: MessageChannel.email,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm7',
          threadId: '3',
          contactId: '3',
          content: 'Invoice attached. Please let me know if you have questions.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
          isInbound: false,
          channel: MessageChannel.email,
          status: MessageStatus.delivered,
          hasAttachment: true,
          attachmentUrl: 'https://picsum.photos/800/600?random=1',
        ),
        Message(
          id: 'm8',
          threadId: '3',
          contactId: '3',
          content: 'Invoice looks good. Processing payment now.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isInbound: true,
          channel: MessageChannel.email,
          status: MessageStatus.delivered,
        ),
      ],
    ),
    MessageThread(
      id: '4',
      contactId: '4',
      contactName: 'Emily Chen',
      channel: MessageChannel.instagram,
      lastMessage: 'Do you service my area? I\'m in SW1.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 24)),
      unreadCount: 1,
      isPinned: false,
      status: MessageStatus.delivered,
      priority: ThreadPriority.medium,
      leadSource: LeadSource.facebookAds,
      messages: [
        Message(
          id: 'm9',
          threadId: '4',
          contactId: '4',
          content: 'Hi! Saw your post on Instagram. Beautiful work!',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          isInbound: true,
          channel: MessageChannel.instagram,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm10',
          threadId: '4',
          contactId: '4',
          content: 'Do you service my area? I\'m in SW1.',
          timestamp: DateTime.now().subtract(const Duration(hours: 24)),
          isInbound: true,
          channel: MessageChannel.instagram,
          status: MessageStatus.delivered,
        ),
      ],
    ),
    MessageThread(
      id: '5',
      contactId: '5',
      contactName: 'David Brown',
      channel: MessageChannel.sms,
      lastMessage: 'Perfect! See you at 9am.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
      unreadCount: 0,
      isPinned: true,
      status: MessageStatus.delivered,
      priority: ThreadPriority.high,
      leadSource: LeadSource.direct,
      messages: [
        Message(
          id: 'm11',
          threadId: '5',
          contactId: '5',
          content: 'Need you for another job. Available this week?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm12',
          threadId: '5',
          contactId: '5',
          content: 'Yes! I can do Thursday morning.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
        Message(
          id: 'm13',
          threadId: '5',
          contactId: '5',
          content: 'Perfect! See you at 9am.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isInbound: true,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
        ),
      ],
    ),
  ];

  // Track muted thread IDs
  static final Set<String> _mutedThreadIds = {};
  // Track archived thread IDs
  static final Set<String> _archivedThreadIds = {};
  // Track pinned thread IDs
  static final Set<String> _pinnedThreadIds = {'1', '5'}; // Initialize with existing pinned threads
  
  // Mock missed calls data
  static final List<MissedCall> _missedCalls = [
    MissedCall(
      id: 'mc1',
      threadId: '1',
      contactId: '1',
      contactName: 'John Smith',
      phoneNumber: '+44 7700 900123',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      textBackSent: true,
      textBackSentAt: DateTime.now().subtract(const Duration(minutes: 14, seconds: 30)),
      textBackMessageId: 'm2',
    ),
    MissedCall(
      id: 'mc2',
      threadId: '2',
      contactId: '2',
      contactName: 'Sarah Williams',
      phoneNumber: '+44 7700 900456',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      textBackSent: false,
    ),
  ];

  /// Fetch all message threads (excluding archived and blocked)
  static Future<List<MessageThread>> fetchAllThreads() async {
    await simulateDelay();
    // Filter out archived threads and threads from blocked contacts
    final activeThreads = _threads.where((t) {
      if (_archivedThreadIds.contains(t.id)) return false;
      // Check if contact is blocked (import MockContacts to check)
      // For now, we'll filter in inbox screen after loading
      return true;
    }).toList();
    logMockOperation('Fetched ${activeThreads.length} message threads (${_archivedThreadIds.length} archived)');
    return activeThreads;
  }

  /// Fetch thread by ID
  static Future<MessageThread?> fetchThreadById(String id) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == id).firstOrNull;
    logMockOperation('Fetched thread: ${thread?.contactName ?? "Not found"}');
    return thread;
  }

  /// Fetch messages for a thread with pagination
  /// Returns messages sorted by timestamp (oldest first) for easier pagination
  /// [limit] - number of messages to fetch
  /// [beforeTimestamp] - fetch messages before this timestamp (for loading older messages)
  static Future<List<Message>> fetchMessagesForThread({
    required String threadId,
    int limit = 20,
    DateTime? beforeTimestamp,
  }) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread == null) {
      logMockOperation('Thread not found: $threadId');
      return [];
    }

    // Get all messages for the thread, sorted by timestamp (oldest first)
    List<Message> allMessages = List.from(thread.messages);
    allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Filter by beforeTimestamp if provided (for pagination)
    if (beforeTimestamp != null) {
      allMessages = allMessages.where((m) => m.timestamp.isBefore(beforeTimestamp)).toList();
    }

    // Take the last [limit] messages (most recent in the filtered set)
    // This simulates loading older messages when scrolling up
    final startIndex = allMessages.length > limit ? allMessages.length - limit : 0;
    final paginatedMessages = allMessages.sublist(startIndex);

    logMockOperation('Fetched ${paginatedMessages.length} messages for thread: $threadId (limit: $limit, before: ${beforeTimestamp?.toIso8601String() ?? "none"})');
    return paginatedMessages;
  }

  /// Get total message count for a thread
  static Future<int> getMessageCountForThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread == null) return 0;
    return thread.messages.length;
  }

  /// Filter threads by channel
  static Future<List<MessageThread>> filterByChannel(MessageChannel channel) async {
    await simulateDelay();
    final results = _threads.where((t) => t.channel == channel).toList();
    logMockOperation('Filtered threads by channel ${channel.name}: ${results.length} results');
    return results;
  }

  /// Get unread count
  static Future<int> getUnreadCount() async {
    await simulateDelay();
    final count = _threads.fold<int>(0, (sum, thread) => sum + thread.unreadCount);
    logMockOperation('Total unread messages: $count');
    return count;
  }

  /// Get unread count by channel
  static Future<Map<MessageChannel, int>> getUnreadCountByChannel() async {
    await simulateDelay();
    final counts = <MessageChannel, int>{};
    for (final channel in MessageChannel.values) {
      counts[channel] = _threads
          .where((t) => t.channel == channel)
          .fold<int>(0, (sum, thread) => sum + thread.unreadCount);
    }
    logMockOperation('Unread count by channel: $counts');
    return counts;
  }

  /// Send message
  static Future<Message> sendMessage({
    required String threadId,
    required String content,
    MessageChannel channel = MessageChannel.sms,
  }) async {
    await simulateDelay();
    final message = Message(
      id: 'sent_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      contactId: '',
      content: content,
      timestamp: DateTime.now(),
      isInbound: false,
      channel: channel,
      status: MessageStatus.sent,
    );
    logMockOperation('Sent message: "${content.substring(0, content.length > 30 ? 30 : content.length)}..."');
    return message;
  }

  /// Archive thread
  static Future<bool> archiveThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      _archivedThreadIds.add(threadId);
      logMockOperation('Archived thread: ${thread.contactName}');
      // In real implementation, this would update the database
      return true;
    }
    return false;
  }

  /// Check if thread is archived
  static bool isThreadArchived(String threadId) {
    return _archivedThreadIds.contains(threadId);
  }

  /// Unarchive thread
  static Future<bool> unarchiveThread(String threadId) async {
    await simulateDelay();
    if (_archivedThreadIds.remove(threadId)) {
      logMockOperation('Unarchived thread: $threadId');
      // In real implementation, this would update the database
      return true;
    }
    return false;
  }

  /// Delete thread
  static Future<bool> deleteThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      logMockOperation('Deleted thread: ${thread.contactName}');
      // In real implementation, this would soft-delete in the database
      return true;
    }
    return false;
  }

  /// Mark thread as read (clear unread count)
  static Future<bool> markThreadRead(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      logMockOperation('Marked thread as read: ${thread.contactName}');
      // In real implementation, this would update unread_count to 0
      return true;
    }
    return false;
  }

  /// Mark thread as unread
  static Future<bool> markThreadUnread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      logMockOperation('Marked thread as unread: ${thread.contactName}');
      // In real implementation, this would set unread_count > 0
      return true;
    }
    return false;
  }

  /// Mute thread (stop notifications)
  static Future<bool> muteThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      _mutedThreadIds.add(threadId);
      logMockOperation('Muted thread: ${thread.contactName}');
      // In real implementation, this would set muted = true
      return true;
    }
    return false;
  }

  /// Unmute thread (resume notifications)
  static Future<bool> unmuteThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      _mutedThreadIds.remove(threadId);
      logMockOperation('Unmuted thread: ${thread.contactName}');
      // In real implementation, this would set muted = false
      return true;
    }
    return false;
  }

  /// Check if thread is muted
  static bool isThreadMuted(String threadId) {
    return _mutedThreadIds.contains(threadId);
  }

  /// Pin thread
  static Future<bool> pinThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      _pinnedThreadIds.add(threadId);
      logMockOperation('Pinned thread: ${thread.contactName}');
      return true;
    }
    return false;
  }

  /// Unpin thread
  static Future<bool> unpinThread(String threadId) async {
    await simulateDelay();
    final thread = _threads.where((t) => t.id == threadId).firstOrNull;
    if (thread != null) {
      _pinnedThreadIds.remove(threadId);
      logMockOperation('Unpinned thread: ${thread.contactName}');
      return true;
    }
    return false;
  }

  /// Check if thread is pinned
  static bool isThreadPinned(String threadId) {
    return _pinnedThreadIds.contains(threadId);
  }

  // Scheduled Messages methods
  static Future<List<ScheduledMessage>> fetchAllScheduled() async {
    return MockMessagesScheduled.fetchAllScheduled();
  }

  static Future<ScheduledMessage> scheduleMessage({
    required String threadId,
    String? contactId,
    required MessageChannel channel,
    required String content,
    required DateTime scheduledFor,
    List<String>? mediaUrls,
  }) async {
    return MockMessagesScheduled.scheduleMessage(
      threadId: threadId,
      contactId: contactId,
      channel: channel,
      content: content,
      scheduledFor: scheduledFor,
      mediaUrls: mediaUrls,
    );
  }

  static Future<void> updateScheduledMessage(
    String messageId, {
    String? content,
    DateTime? scheduledFor,
  }) async {
    return MockMessagesScheduled.updateScheduledMessage(
      messageId,
      content: content,
      scheduledFor: scheduledFor,
    );
  }

  static Future<void> deleteScheduledMessage(String messageId) async {
    return MockMessagesScheduled.deleteScheduledMessage(messageId);
  }

  static Future<void> cancelScheduledMessage(String messageId) async {
    return MockMessagesScheduled.cancelScheduledMessage(messageId);
  }

  /// Fetch missed calls for a thread
  static Future<List<MissedCall>> fetchMissedCallsForThread(String threadId) async {
    await simulateDelay();
    final calls = _missedCalls.where((c) => c.threadId == threadId).toList();
    logMockOperation('Fetched ${calls.length} missed calls for thread: $threadId');
    return calls;
  }

  /// Fetch all missed calls
  static Future<List<MissedCall>> fetchAllMissedCalls() async {
    await simulateDelay();
    logMockOperation('Fetched ${_missedCalls.length} missed calls');
    return List.from(_missedCalls);
  }

  /// Record a missed call (called by webhook handler)
  static Future<MissedCall> recordMissedCall({
    required String threadId,
    required String contactId,
    required String contactName,
    required String phoneNumber,
  }) async {
    await simulateDelay();
    final missedCall = MissedCall(
      id: 'mc_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      contactId: contactId,
      contactName: contactName,
      phoneNumber: phoneNumber,
      timestamp: DateTime.now(),
    );
    _missedCalls.add(missedCall);
    logMockOperation('Recorded missed call from $contactName');
    return missedCall;
  }

  /// Mark text-back as sent for a missed call
  static Future<void> markTextBackSent(String missedCallId, String messageId) async {
    await simulateDelay();
    final index = _missedCalls.indexWhere((c) => c.id == missedCallId);
    if (index != -1) {
      final existing = _missedCalls[index];
      _missedCalls[index] = MissedCall(
        id: existing.id,
        threadId: existing.threadId,
        contactId: existing.contactId,
        contactName: existing.contactName,
        phoneNumber: existing.phoneNumber,
        timestamp: existing.timestamp,
        textBackSent: true,
        textBackSentAt: DateTime.now(),
        textBackMessageId: messageId,
      );
      logMockOperation('Marked text-back sent for missed call: $missedCallId');
    }
  }
}

/// Lead Source enum - Marketing attribution sources (distinct from message channels)
enum LeadSource {
  googleAds,      // Google Ads campaigns
  facebookAds,   // Facebook/Instagram Ads
  website,       // Website form submissions
  referral,      // Referrals from existing customers
  direct,        // Direct contact (no specific source)
}

/// Message Thread model
class MessageThread {
  final String id;
  final String contactId;
  final String contactName;
  final MessageChannel channel;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isPinned;
  final MessageStatus status;
  final List<Message> messages;
  final ThreadPriority? priority; // AI-determined priority (low/medium/high)
  final LeadSource? leadSource; // Lead source for attribution tracking

  MessageThread({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.channel,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isPinned,
    required this.status,
    required this.messages,
    this.priority,
    this.leadSource,
  });
}


/// Message model
class Message {
  final String id;
  final String threadId;
  final String contactId;
  final String content;
  final DateTime timestamp;
  final bool isInbound;
  final MessageChannel channel;
  final MessageStatus status;
  final bool hasAttachment;
  final String? attachmentUrl;

  Message({
    required this.id,
    required this.threadId,
    required this.contactId,
    required this.content,
    required this.timestamp,
    required this.isInbound,
    required this.channel,
    required this.status,
    this.hasAttachment = false,
    this.attachmentUrl,
  });
}

/// Missed Call model
class MissedCall {
  final String id;
  final String threadId;
  final String contactId;
  final String contactName;
  final String phoneNumber;
  final DateTime timestamp;
  final bool textBackSent;
  final DateTime? textBackSentAt;
  final String? textBackMessageId;

  MissedCall({
    required this.id,
    required this.threadId,
    required this.contactId,
    required this.contactName,
    required this.phoneNumber,
    required this.timestamp,
    this.textBackSent = false,
    this.textBackSentAt,
    this.textBackMessageId,
  });
}

/// Message channels
enum MessageChannel {
  sms,
  whatsapp,
  email,
  facebook,
  instagram,
}

extension MessageChannelExtension on MessageChannel {
  String get displayName {
    switch (this) {
      case MessageChannel.sms:
        return 'SMS';
      case MessageChannel.whatsapp:
        return 'WhatsApp';
      case MessageChannel.email:
        return 'Email';
      case MessageChannel.facebook:
        return 'Facebook';
      case MessageChannel.instagram:
        return 'Instagram';
    }
  }
}

// Scheduled Messages - Add to MockMessages class
extension MockMessagesScheduled on MockMessages {
  static final List<ScheduledMessage> _scheduledMessages = [
    ScheduledMessage(
      id: 'sched1',
      threadId: '1',
      contactId: '1',
      channel: MessageChannel.sms,
      content: 'Reminder: Your appointment is tomorrow at 2pm.',
      scheduledFor: DateTime.now().add(const Duration(hours: 18)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: ScheduledMessageStatus.pending,
    ),
    ScheduledMessage(
      id: 'sched2',
      threadId: '2',
      contactId: '2',
      channel: MessageChannel.whatsapp,
      content: 'Thank you for your inquiry! We\'ll get back to you soon.',
      scheduledFor: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: ScheduledMessageStatus.pending,
    ),
  ];

  /// Fetch all scheduled messages
  static Future<List<ScheduledMessage>> fetchAllScheduled() async {
    await simulateDelay();
    logMockOperation('Fetched ${_scheduledMessages.length} scheduled messages');
    return List.from(_scheduledMessages);
  }

  /// Schedule a message
  static Future<ScheduledMessage> scheduleMessage({
    required String threadId,
    String? contactId,
    required MessageChannel channel,
    required String content,
    required DateTime scheduledFor,
    List<String>? mediaUrls,
  }) async {
    await simulateDelay();
    final message = ScheduledMessage(
      id: 'sched_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      contactId: contactId,
      channel: channel,
      content: content,
      scheduledFor: scheduledFor,
      createdAt: DateTime.now(),
      status: ScheduledMessageStatus.pending,
      mediaUrls: mediaUrls,
    );
    _scheduledMessages.add(message);
    logMockOperation('Scheduled message for ${scheduledFor.toString()}');
    return message;
  }

  /// Update scheduled message
  static Future<void> updateScheduledMessage(
    String messageId, {
    String? content,
    DateTime? scheduledFor,
  }) async {
    await simulateDelay();
    final index = _scheduledMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final existing = _scheduledMessages[index];
      _scheduledMessages[index] = ScheduledMessage(
        id: existing.id,
        threadId: existing.threadId,
        contactId: existing.contactId,
        channel: existing.channel,
        content: content ?? existing.content,
        scheduledFor: scheduledFor ?? existing.scheduledFor,
        createdAt: existing.createdAt,
        status: existing.status,
        mediaUrls: existing.mediaUrls,
        sentAt: existing.sentAt,
      );
      logMockOperation('Updated scheduled message: $messageId');
    }
  }

  /// Delete scheduled message
  static Future<void> deleteScheduledMessage(String messageId) async {
    await simulateDelay();
    _scheduledMessages.removeWhere((m) => m.id == messageId);
    logMockOperation('Deleted scheduled message: $messageId');
  }

  /// Cancel scheduled message
  static Future<void> cancelScheduledMessage(String messageId) async {
    await simulateDelay();
    final index = _scheduledMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final existing = _scheduledMessages[index];
      _scheduledMessages[index] = ScheduledMessage(
        id: existing.id,
        threadId: existing.threadId,
        contactId: existing.contactId,
        channel: existing.channel,
        content: existing.content,
        scheduledFor: existing.scheduledFor,
        createdAt: existing.createdAt,
        status: ScheduledMessageStatus.cancelled,
        mediaUrls: existing.mediaUrls,
        sentAt: existing.sentAt,
      );
      logMockOperation('Cancelled scheduled message: $messageId');
    }
  }
}

/// Message status
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
