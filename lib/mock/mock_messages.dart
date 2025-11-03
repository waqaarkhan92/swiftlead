import '../config/mock_config.dart';
import '../models/message.dart';
import 'mock_contacts.dart';

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
      messages: [
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
          content: 'I can come take a look tomorrow at 2pm. Does that work for you?',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isInbound: false,
          channel: MessageChannel.sms,
          status: MessageStatus.delivered,
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

/// Message status
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
