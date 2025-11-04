import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../mock/mock_messages.dart';

/// Queued message action for offline queue
class QueuedMessage {
  final String id;
  final String threadId;
  final String? contactId;
  final String content;
  final MessageChannel channel;
  final List<String>? mediaUrls;
  final DateTime queuedAt;
  final int retryCount;

  QueuedMessage({
    required this.id,
    required this.threadId,
    this.contactId,
    required this.content,
    required this.channel,
    this.mediaUrls,
    required this.queuedAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'threadId': threadId,
        'contactId': contactId,
        'content': content,
        'channel': channel.name,
        'mediaUrls': mediaUrls,
        'queuedAt': queuedAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory QueuedMessage.fromJson(Map<String, dynamic> json) => QueuedMessage(
        id: json['id'] as String,
        threadId: json['threadId'] as String,
        contactId: json['contactId'] as String?,
        content: json['content'] as String,
        channel: MessageChannel.values.firstWhere(
          (c) => c.name == json['channel'],
          orElse: () => MessageChannel.sms,
        ),
        mediaUrls: json['mediaUrls'] != null
            ? List<String>.from(json['mediaUrls'] as List)
            : null,
        queuedAt: DateTime.parse(json['queuedAt'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
      );
}

/// OfflineQueueManager - Manages offline message queue
/// Specification from Product_Definition_v2.5.1 §3.1 (v2.5.1 Enhancement)
class OfflineQueueManager {
  static final OfflineQueueManager _instance = OfflineQueueManager._internal();
  factory OfflineQueueManager() => _instance;
  OfflineQueueManager._internal();

  final List<QueuedMessage> _queue = [];
  final StreamController<bool> _queueStatusController =
      StreamController<bool>.broadcast();
  final StreamController<int> _queueCountController =
      StreamController<int>.broadcast();

  bool _isOnline = true;
  bool _isProcessing = false;
  Timer? _syncTimer;

  // Streams
  Stream<bool> get queueStatusStream => _queueStatusController.stream;
  Stream<int> get queueCountStream => _queueCountController.stream;

  int get queueCount => _queue.length;
  bool get hasQueuedMessages => _queue.isNotEmpty;
  bool get isOnline => _isOnline;

  /// Initialize and load persisted queue
  Future<void> initialize() async {
    await _loadQueue();
    _startPeriodicSync();
    _notifyQueueStatus();
  }

  /// Set online/offline status
  /// In production, this should be called by a connectivity listener
  void setOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      _notifyQueueStatus();
      
      if (isOnline && _queue.isNotEmpty) {
        // Connection restored, start processing queue
        _processQueue();
      }
    }
  }
  
  /// Simulate offline mode (for testing)
  /// In production, use connectivity_plus package to monitor network status
  void simulateOffline() {
    setOnlineStatus(false);
  }
  
  /// Simulate online mode (for testing)
  void simulateOnline() {
    setOnlineStatus(true);
  }

  /// Queue a message for sending when online
  Future<void> queueMessage({
    required String threadId,
    String? contactId,
    required String content,
    required MessageChannel channel,
    List<String>? mediaUrls,
  }) async {
    final queuedMessage = QueuedMessage(
      id: 'queued_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      contactId: contactId,
      content: content,
      channel: channel,
      mediaUrls: mediaUrls,
      queuedAt: DateTime.now(),
    );

    _queue.add(queuedMessage);
    await _persistQueue();
    _notifyQueueStatus();

    // If online, try to send immediately
    if (_isOnline) {
      _processQueue();
    }
  }

  /// Process queued messages
  Future<void> _processQueue() async {
    if (_isProcessing || !_isOnline || _queue.isEmpty) return;

    _isProcessing = true;

    while (_queue.isNotEmpty && _isOnline) {
      final message = _queue.first;

      try {
        // Attempt to send message
        // In production, this would call the actual API
        final success = await _sendMessage(message);

        if (success) {
          _queue.removeAt(0);
          await _persistQueue();
          _notifyQueueStatus();
        } else {
          // Failed, increment retry count
          final updatedMessage = QueuedMessage(
            id: message.id,
            threadId: message.threadId,
            contactId: message.contactId,
            content: message.content,
            channel: message.channel,
            mediaUrls: message.mediaUrls,
            queuedAt: message.queuedAt,
            retryCount: message.retryCount + 1,
          );
          _queue[0] = updatedMessage;

          // If retry count exceeds max, remove from queue
          if (updatedMessage.retryCount >= 3) {
            _queue.removeAt(0);
            await _persistQueue();
            _notifyQueueStatus();
            debugPrint('[OfflineQueue] Message ${updatedMessage.id} failed after 3 retries, removed from queue');
          } else {
            // Wait before retrying
            await Future.delayed(Duration(seconds: 2 * updatedMessage.retryCount));
          }
        }
      } catch (e) {
        debugPrint('[OfflineQueue] Error processing message: $e');
        // If network error, stop processing
        if (e.toString().contains('network') || e.toString().contains('offline')) {
          _isOnline = false;
          setOnlineStatus(false);
          break;
        }
        // Otherwise, increment retry and continue
        final updatedMessage = QueuedMessage(
          id: message.id,
          threadId: message.threadId,
          contactId: message.contactId,
          content: message.content,
          channel: message.channel,
          mediaUrls: message.mediaUrls,
          queuedAt: message.queuedAt,
          retryCount: message.retryCount + 1,
        );
        _queue[0] = updatedMessage;
        await _persistQueue();
      }
    }

    _isProcessing = false;
  }

  /// Send message (mock implementation - replace with actual API call)
  Future<bool> _sendMessage(QueuedMessage message) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In production, this would call:
    // await SupabaseService.sendMessage(...)
    // For now, we'll use MockMessages
    try {
      await MockMessages.sendMessage(
        threadId: message.threadId,
        content: message.content,
        channel: message.channel,
      );
      debugPrint('[OfflineQueue] Message sent successfully: ${message.id}');
      return true;
    } catch (e) {
      debugPrint('[OfflineQueue] Send failed: $e');
      // If it's a network error, mark as offline
      if (e.toString().contains('network') || e.toString().contains('offline') || e.toString().contains('Connection')) {
        setOnlineStatus(false);
      }
      return false;
    }
  }

  /// Start periodic sync check
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isOnline && _queue.isNotEmpty && !_isProcessing) {
        _processQueue();
      }
    });
  }

  /// Load queue from persistent storage
  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString('offline_message_queue');
      
      if (queueJson != null) {
        final List<dynamic> decoded = jsonDecode(queueJson) as List<dynamic>;
        _queue.clear();
        _queue.addAll(
          decoded.map((json) => QueuedMessage.fromJson(json as Map<String, dynamic>)),
        );
        _notifyQueueStatus();
      }
    } catch (e) {
      debugPrint('[OfflineQueue] Error loading queue: $e');
    }
  }

  /// Persist queue to storage
  Future<void> _persistQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = jsonEncode(_queue.map((m) => m.toJson()).toList());
      await prefs.setString('offline_message_queue', queueJson);
    } catch (e) {
      debugPrint('[OfflineQueue] Error persisting queue: $e');
    }
  }

  /// Notify listeners of queue status changes
  void _notifyQueueStatus() {
    _queueStatusController.add(hasQueuedMessages);
    _queueCountController.add(_queue.length);
  }

  /// Clear queue (for testing/debugging)
  Future<void> clearQueue() async {
    _queue.clear();
    await _persistQueue();
    _notifyQueueStatus();
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _queueStatusController.close();
    _queueCountController.close();
  }
}

