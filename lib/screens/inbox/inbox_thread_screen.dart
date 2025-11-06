import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/chat_bubble.dart' as chat_bubble show ChatBubble, BubbleType, MessageStatus;
import '../../widgets/components/date_separator.dart';
import '../../widgets/components/message_composer_bar.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/components/media_thumbnail.dart';
import '../../widgets/components/media_preview_modal.dart';
import '../../widgets/forms/smart_reply_suggestions_sheet.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../jobs/create_edit_job_screen.dart';
import '../contacts/contact_detail_screen.dart';
import '../../models/contact.dart';
import '../../mock/mock_contacts.dart';
import '../../mock/mock_messages.dart';
import '../../models/message.dart';
import '../../widgets/components/internal_notes_modal.dart';
import '../../widgets/components/ai_summary_card.dart';
import '../../widgets/components/reaction_picker.dart';
import '../../widgets/components/message_detail_sheet.dart';
import '../../widgets/components/typing_indicator.dart';
import '../../widgets/components/missed_call_notification.dart';
import '../../widgets/components/offline_banner.dart';
import '../../widgets/forms/message_actions_sheet.dart';
import '../../services/offline_queue_manager.dart';
import '../../utils/responsive_layout.dart';
import 'thread_search_screen.dart';

/// Helper class to represent different item types in the thread list
class _ThreadItem {
  final _ThreadItemType type;
  final Message? message;
  final MissedCall? missedCall;
  final DateTime? date;
  final String? threadId;
  
  _ThreadItem._({
    required this.type,
    this.message,
    this.missedCall,
    this.date,
    this.threadId,
  });
  
  factory _ThreadItem.message({required Message message}) {
    return _ThreadItem._(type: _ThreadItemType.message, message: message);
  }
  
  factory _ThreadItem.missedCall({required MissedCall missedCall}) {
    return _ThreadItem._(type: _ThreadItemType.missedCall, missedCall: missedCall);
  }
  
  factory _ThreadItem.dateSeparator({required DateTime date}) {
    return _ThreadItem._(type: _ThreadItemType.dateSeparator, date: date);
  }
  
  factory _ThreadItem.aiSummary({required String threadId}) {
    return _ThreadItem._(type: _ThreadItemType.aiSummary, threadId: threadId);
  }
  
  factory _ThreadItem.typingIndicator() {
    return _ThreadItem._(type: _ThreadItemType.typingIndicator);
  }
}

enum _ThreadItemType {
  message,
  missedCall,
  dateSeparator,
  aiSummary,
  typingIndicator,
}

/// InboxThreadScreen - Conversation thread view
/// Exact specification from Screen_Layouts_v2.5.1
class InboxThreadScreen extends StatefulWidget {
  final String contactName;
  final String channel; // Display name like "SMS", "WhatsApp"
  final String? contactId; // Optional contact ID for direct lookup
  final String? threadId; // Optional thread ID for search and other operations
  final VoidCallback? onThreadUpdated; // Callback when thread is updated (for desktop split view)
  
  const InboxThreadScreen({
    super.key,
    required this.contactName,
    required this.channel,
    this.contactId,
    this.threadId,
    this.onThreadUpdated,
  });

  @override
  State<InboxThreadScreen> createState() => _InboxThreadScreenState();
}

class _InboxThreadScreenState extends State<InboxThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  bool _contactIsTyping = false; // Track if contact is typing
  int _noteCount = 3;
  List<MissedCall> _missedCalls = [];
  bool _isLoadingMissedCalls = false;
  
  // Offline queue state
  final OfflineQueueManager _queueManager = OfflineQueueManager();
  bool _isOffline = false;
  int _queuedCount = 0;
  StreamSubscription<bool>? _queueStatusSubscription;
  StreamSubscription<int>? _queueCountSubscription;
  
  // Infinite scroll state
  final ScrollController _scrollController = ScrollController();
  List<Message> _loadedMessages = [];
  bool _isLoadingOlderMessages = false;
  bool _hasMoreMessages = true;
  int _totalMessageCount = 0;
  static const int _pageSize = 20;
  
  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  MessageChannel get _messageChannel {
    switch (widget.channel.toLowerCase()) {
      case 'sms':
        return MessageChannel.sms;
      case 'whatsapp':
        return MessageChannel.whatsapp;
      case 'email':
        return MessageChannel.email;
      case 'facebook':
        return MessageChannel.facebook;
      case 'instagram':
        return MessageChannel.instagram;
      default:
        return MessageChannel.sms;
    }
  }
  
  bool get _isMuted {
    // Get threadId - either from widget or use contactName as fallback identifier
    String threadId = widget.threadId ?? widget.contactId ?? widget.contactName;
    return MockMessages.isThreadMuted(threadId);
  }

  String get _currentThreadId {
    return widget.threadId ?? widget.contactId ?? widget.contactName;
  }

  @override
  void initState() {
    super.initState();
    _loadMissedCalls();
    _initializeOfflineQueue();
    _loadInitialMessages();
    _scrollController.addListener(_onScroll);
  }
  
  
  void _onScroll() {
    // Load older messages when scrolling near the top (for reverse ListView)
    // In reverse ListView, scrolling up increases pixels, and maxScrollExtent is at the top (oldest messages)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && 
        _scrollController.position.maxScrollExtent > 0 &&
        !_isLoadingOlderMessages && 
        _hasMoreMessages) {
      _loadOlderMessages();
    }
  }
  
  Future<void> _loadInitialMessages() async {
    setState(() {
      _isLoadingOlderMessages = true;
    });
    
    try {
      // Get total count
      _totalMessageCount = await MockMessages.getMessageCountForThread(_currentThreadId);
      
      // Load initial page (most recent messages)
      final messages = await MockMessages.fetchMessagesForThread(
        threadId: _currentThreadId,
        limit: _pageSize,
      );
      
      if (mounted) {
        setState(() {
          _loadedMessages = messages;
          _hasMoreMessages = messages.length >= _pageSize && _loadedMessages.length < _totalMessageCount;
          _isLoadingOlderMessages = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOlderMessages = false;
        });
      }
    }
  }
  
  Future<void> _loadOlderMessages() async {
    if (_isLoadingOlderMessages || !_hasMoreMessages) return;
    
    setState(() {
      _isLoadingOlderMessages = true;
    });
    
    try {
      // Get the oldest loaded message timestamp
      final oldestTimestamp = _loadedMessages.isNotEmpty 
          ? _loadedMessages.first.timestamp 
          : DateTime.now();
      
      final olderMessages = await MockMessages.fetchMessagesForThread(
        threadId: _currentThreadId,
        limit: _pageSize,
        beforeTimestamp: oldestTimestamp,
      );
      
      if (mounted && olderMessages.isNotEmpty) {
        setState(() {
          // Prepend older messages (they're already sorted oldest first)
          _loadedMessages.insertAll(0, olderMessages);
          _hasMoreMessages = olderMessages.length >= _pageSize && _loadedMessages.length < _totalMessageCount;
          _isLoadingOlderMessages = false;
        });
        
        // Maintain scroll position after loading older messages
        // For reverse ListView, we need to adjust scroll position
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
            // Maintain scroll position by adjusting for new items
            // In reverse list, we stay at the same relative position
            final currentScroll = _scrollController.position.pixels;
            final maxScroll = _scrollController.position.maxScrollExtent;
            // Keep the same relative position
            if (maxScroll > 0) {
              _scrollController.jumpTo(currentScroll);
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _hasMoreMessages = false;
            _isLoadingOlderMessages = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOlderMessages = false;
        });
      }
    }
  }
  
  Future<void> _initializeOfflineQueue() async {
    await _queueManager.initialize();
    
    // Listen to queue status changes
    _queueStatusSubscription = _queueManager.queueStatusStream.listen((hasQueue) {
      if (mounted) {
        setState(() {
          _isOffline = !_queueManager.isOnline || hasQueue;
        });
      }
    });
    
    _queueCountSubscription = _queueManager.queueCountStream.listen((count) {
      if (mounted) {
        setState(() {
          _queuedCount = count;
        });
      }
    });
    
    // Check initial status
    if (mounted) {
      setState(() {
        _isOffline = !_queueManager.isOnline;
        _queuedCount = _queueManager.queueCount;
      });
    }
  }

  Future<void> _loadMissedCalls() async {
    setState(() => _isLoadingMissedCalls = true);
    try {
      final calls = await MockMessages.fetchMissedCallsForThread(_currentThreadId);
      if (mounted) {
        setState(() {
          _missedCalls = calls;
          _isLoadingMissedCalls = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMissedCalls = false);
      }
    }
  }

  Future<void> _sendTextBack(MissedCall missedCall) async {
    // Get the branded text-back message template
    // In production, this would come from settings or AI
    final textBackMessage = 'Hi ${missedCall.contactName}, we missed your call. How can we help you today? Reply here or book an appointment: [BOOKING_LINK]';
    
    // Send the message
    final message = await MockMessages.sendMessage(
      threadId: missedCall.threadId,
      content: textBackMessage,
      channel: MessageChannel.sms,
    );
    
    // Mark text-back as sent
    await MockMessages.markTextBackSent(missedCall.id, message.id);
    
    // Reload missed calls to update UI
    await _loadMissedCalls();
    
    if (mounted) {
      Toast.show(
        context,
        message: 'Text-back sent to ${missedCall.contactName}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _viewContact() async {
    try {
      print('[InboxThreadScreen] _viewContact called with contactId: ${widget.contactId}, contactName: ${widget.contactName}');
      Contact? contact;
      
      // First try to fetch by contactId if available (most reliable)
      if (widget.contactId != null && widget.contactId!.isNotEmpty) {
        print('[InboxThreadScreen] Attempting to fetch contact by ID: ${widget.contactId}');
        contact = await MockContacts.fetchById(widget.contactId!);
        if (contact == null) {
          // If ID lookup fails, log for debugging
          print('[InboxThreadScreen] Contact not found by ID: ${widget.contactId}');
        } else {
          print('[InboxThreadScreen] Found contact by ID: ${contact.name} (ID: ${contact.id})');
        }
      }
      
      // If not found by ID, search by name (exact match only)
      if (contact == null) {
        final contacts = await MockContacts.search(widget.contactName);
        if (contacts.isNotEmpty) {
          // Try exact match first
          try {
            contact = contacts.firstWhere(
              (c) => c.name.toLowerCase().trim() == widget.contactName.toLowerCase().trim(),
            );
          } catch (e) {
            // If no exact match, use first result but warn
            print('[InboxThreadScreen] No exact name match for "${widget.contactName}", using first result');
            contact = contacts.first;
          }
        }
      }
      
      if (contact != null && mounted) {
        print('[InboxThreadScreen] Navigating to contact: ${contact.name} (ID: ${contact.id})');
        print('[InboxThreadScreen] Thread contactId: ${widget.contactId}, Thread contactName: ${widget.contactName}');
        Navigator.push(
          context,
          _createPageRoute(ContactDetailScreen(
            contactId: contact!.id,
          )),
        );
      } else {
        // If contact not found, show error toast
        if (mounted) {
          Toast.show(
            context,
            message: 'Contact "${widget.contactName}" not found',
            type: ToastType.error,
          );
        }
      }
    } catch (e) {
      // Handle any errors
      print('[InboxThreadScreen] Error in _viewContact: $e');
      if (mounted) {
        Toast.show(
          context,
          message: 'Error loading contact: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  Future<void> _toggleMute() async {
    // Get threadId - try widget first, then lookup by contactId/contactName
    String? threadId = widget.threadId;
    
    if (threadId == null && widget.contactId != null) {
      // Find thread by contactId
      final allThreads = await MockMessages.fetchAllThreads();
      final thread = allThreads.where((t) => t.contactId == widget.contactId).firstOrNull;
      threadId = thread?.id;
    }
    
    if (threadId == null) {
      // Try to find thread by contact name as fallback
      final allThreads = await MockMessages.fetchAllThreads();
      final thread = allThreads.where((t) => t.contactName == widget.contactName).firstOrNull;
      threadId = thread?.id;
    }
    
    if (threadId != null && mounted) {
      // Toggle mute state
      if (_isMuted) {
        await MockMessages.unmuteThread(threadId);
        Toast.show(
          context,
          message: 'Conversation unmuted',
          type: ToastType.success,
        );
      } else {
        await MockMessages.muteThread(threadId);
        Toast.show(
          context,
          message: 'Conversation muted',
          type: ToastType.success,
        );
      }
      
      // Update UI
      setState(() {});
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Thread not found',
          type: ToastType.error,
        );
      }
    }
  }

  void _archiveThread() {
    // Get threadId - use widget first, then fallback to contactId/contactName
    String threadId = widget.threadId ?? widget.contactId ?? widget.contactName;
    
    // Archive the thread
    MockMessages.archiveThread(threadId);
    
    Toast.show(
      context,
      message: 'Conversation archived',
      type: ToastType.success,
    );
    
    // Navigate back to inbox (archived threads are removed from main view)
    Navigator.of(context).pop(true); // Return true to refresh inbox
  }

  void _blockContact() {
    // Get contactId - use widget first, then fallback
    String? contactId = widget.contactId;
    
    if (contactId == null) {
      // Show confirmation dialog since blocking is permanent
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Block Contact'),
          content: Text('Block ${widget.contactName}? You won\'t receive messages from them.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Continue with blocking using contact name as identifier
                _performBlock(widget.contactName);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Block'),
            ),
          ],
        ),
      );
    } else {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Block Contact'),
          content: Text('Block ${widget.contactName}? You won\'t receive messages from them.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _performBlock(contactId);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Block'),
            ),
          ],
        ),
      );
    }
  }

  void _performBlock(String contactId) {
    // Block the contact
    MockContacts.blockContact(contactId);
    
    Toast.show(
      context,
      message: '${widget.contactName} blocked',
      type: ToastType.success,
    );
    
    // Navigate back to inbox (blocked contacts are removed from view)
    Navigator.of(context).pop(true); // Return true to refresh inbox
  }

  void _showInternalNotes() {
    // Get threadId - either from widget or use contactName as fallback identifier
    String threadId = widget.threadId ?? widget.contactId ?? widget.contactName;
    
    // Show the modal immediately - we'll use the identifier we have
    InternalNotesModal.show(
      context: context,
      threadId: threadId,
      onNoteAdded: (note) {
        Toast.show(
          context,
          message: 'Note added',
          type: ToastType.success,
        );
      },
    );
  }

  Future<void> _searchInThread() async {
    // Get threadId - either from widget or by looking up thread
    String? threadId = widget.threadId;
    
    if (threadId == null && widget.contactId != null) {
      // Find thread by contactId
      final allThreads = await MockMessages.fetchAllThreads();
      final thread = allThreads.where((t) => t.contactId == widget.contactId).firstOrNull;
      threadId = thread?.id;
    }
    
    if (threadId == null) {
      // Try to find thread by contact name as fallback
      final allThreads = await MockMessages.fetchAllThreads();
      final thread = allThreads.where((t) => t.contactName == widget.contactName).firstOrNull;
      threadId = thread?.id;
    }
    
    if (threadId != null && mounted) {
      Navigator.push(
        context,
        _createPageRoute(ThreadSearchScreen(
          threadId: threadId!,
          contactName: widget.contactName,
          channel: widget.channel,
        )),
      );
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Thread not found',
          type: ToastType.error,
        );
      }
    }
  }

  void _showReactionPicker() {
    ReactionPicker.show(
      context,
      (emoji) {
        Toast.show(
          context,
          message: 'Reacted with $emoji',
          type: ToastType.success,
        );
      },
    );
  }

  void _showMessageDetails() {
    String threadId = widget.threadId ?? widget.contactId ?? widget.contactName;
    MessageDetailSheet.show(
      context: context,
      messageId: 'msg_${threadId}_1',
      messageContent: 'Sample message content',
      senderName: widget.contactName,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'read',
      channel: widget.channel,
    );
  }

  // Feature 34: Quick Quote - Generate quote from message in under 60 seconds
  void _handleCreateQuoteFromInbox() {
    // Show quick quote sheet with pre-filled data
    _showQuickQuoteSheet();
  }

  void _showQuickQuoteSheet() {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    
    // Pre-fill from last message if available
    if (_loadedMessages.isNotEmpty) {
      final lastMessage = _loadedMessages.last;
      descriptionController.text = lastMessage.content.length > 100 
          ? '${lastMessage.content.substring(0, 100)}...' 
          : lastMessage.content;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Quote',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                children: [
                  Text(
                    'Create a quote for ${widget.contactName} in seconds',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Service Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                      hintText: 'Describe the service needed',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount (£)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                      prefixText: '£ ',
                      hintText: '0.00',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                  PrimaryButton(
                    label: 'Create Quote',
                    icon: Icons.description,
                    onPressed: () {
                      final amount = double.tryParse(amountController.text) ?? 0.0;
                      if (descriptionController.text.isEmpty || amount <= 0) {
                        Toast.show(
                          context,
                          message: 'Please fill in description and amount',
                          type: ToastType.error,
                        );
                        return;
                      }
                      
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        _createPageRoute(CreateEditQuoteScreen(
                          initialData: {
                            'clientName': widget.contactName,
                            'description': descriptionController.text,
                            'amount': amount,
                            'notes': 'Quick quote from ${widget.channel} conversation',
                          },
                        )),
                      ).then((_) {
                        Toast.show(
                          context,
                          message: 'Quote created in seconds!',
                          type: ToastType.success,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCreateJobFromInbox() {
    Navigator.push(
      context,
      _createPageRoute(CreateEditJobScreen(
        initialData: {
          'clientName': widget.contactName,
          'contactId': widget.contactId,
          'notes': 'Job created from ${widget.channel} conversation',
        },
      )),
    ).then((_) {
      Toast.show(
        context,
        message: 'Job created from conversation',
        type: ToastType.success,
      );
    });
  }

  void _handleAIExtractJob() {
    // Simulate AI extraction from conversation
    Toast.show(
      context,
      message: 'AI extracting job details from conversation...',
      type: ToastType.info,
    );
    
    // Simulate delay then navigate to job creation with AI-extracted data
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.push(
          context,
          _createPageRoute(CreateEditJobScreen(
            initialData: {
              'clientName': widget.contactName,
              'contactId': widget.contactId,
              'notes': 'Job details extracted from ${widget.channel} conversation using AI',
              'serviceType': 'Service Type', // AI would extract this from messages
              'description': 'AI-extracted job description', // AI would extract this
            },
          )),
        ).then((_) {
          Toast.show(
            context,
            message: 'Job created from AI extraction',
            type: ToastType.success,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _queueStatusSubscription?.cancel();
    _queueCountSubscription?.cancel();
    _messageController.dispose();
    super.dispose();
  }
  
  // Helper to build a list of items (messages, missed calls, date separators) for ListView.builder
  // ListView is reversed, so items are displayed bottom to top (newest at bottom)
  List<_ThreadItem> _buildThreadItems() {
    final items = <_ThreadItem>[];
    
    // Merge messages and missed calls chronologically
    final allItems = <({DateTime timestamp, dynamic item})>[];
    
    // Add messages
    for (final message in _loadedMessages) {
      allItems.add((timestamp: message.timestamp, item: message));
    }
    
    // Add missed calls
    for (final missedCall in _missedCalls) {
      allItems.add((timestamp: missedCall.timestamp, item: missedCall));
    }
    
    // Sort by timestamp (newest first for reverse ListView - newest at bottom)
    allItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Build items with date separators
    DateTime? lastDate;
    for (final entry in allItems) {
      final itemDate = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      if (lastDate == null || !itemDate.isAtSameMomentAs(lastDate)) {
        items.add(_ThreadItem.dateSeparator(date: itemDate));
        lastDate = itemDate;
      }
      
      if (entry.item is Message) {
        items.add(_ThreadItem.message(message: entry.item as Message));
      } else if (entry.item is MissedCall) {
        items.add(_ThreadItem.missedCall(missedCall: entry.item as MissedCall));
      }
    }
    
    // Add typing indicator (will appear at bottom when reversed)
    if (_contactIsTyping) {
      items.add(_ThreadItem.typingIndicator());
    }
    
    // Add AI Summary Card at the end (will appear at top when reversed)
    items.add(_ThreadItem.aiSummary(threadId: _currentThreadId));
    
    return items;
  }
  
  // Helper to format timestamp for message bubble
  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate.isAtSameMomentAs(today)) {
      // Today: Show time only (e.g., "10:30 AM")
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } else {
      // Not today: Show date and time
      final month = timestamp.month.toString().padLeft(2, '0');
      final day = timestamp.day.toString().padLeft(2, '0');
      final hour = timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$month/$day $displayHour:$minute $period';
    }
  }
  
  // Helper to build message widget
  Widget _buildMessageWidget(Message message) {
    // Debug: Check if attachment exists
    final hasAttachment = message.hasAttachment && message.attachmentUrl != null;
    
    return Semantics(
      label: 'Message from ${message.isInbound ? widget.contactName : 'You'}. Long press for options.',
      child: GestureDetector(
        onLongPress: () async {
          final action = await MessageActionsSheet.show(
          context: context,
          messageId: message.id,
          channel: _messageChannel,
          canEdit: !message.isInbound,
          canDelete: !message.isInbound,
        );
        if (action != null && mounted) {
          switch (action) {
            case 'copy':
              Toast.show(context, message: 'Message copied', type: ToastType.success);
              break;
            case 'edit':
              Toast.show(context, message: 'Edit functionality coming soon', type: ToastType.info);
              break;
            case 'delete':
              Toast.show(context, message: 'Delete functionality coming soon', type: ToastType.info);
              break;
            case 'share':
              Toast.show(context, message: 'Share functionality coming soon', type: ToastType.info);
              break;
            case 'forward':
              Toast.show(context, message: 'Forward functionality coming soon', type: ToastType.info);
              break;
            case 'react':
              _showReactionPicker();
              break;
            case 'details':
              _showMessageDetails();
              break;
          }
        }
      },
      child: Column(
        crossAxisAlignment: message.isInbound ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Attachment thumbnail (if exists)
          if (hasAttachment)
            Padding(
              padding: EdgeInsets.only(
                bottom: SwiftleadTokens.spaceS,
                left: message.isInbound ? 0 : SwiftleadTokens.spaceM,
                right: message.isInbound ? SwiftleadTokens.spaceM : 0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                  maxHeight: 200,
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: MediaThumbnail(
                    imageUrl: message.attachmentUrl,
                    label: _getAttachmentLabel(message.attachmentUrl),
                    onTap: () {
                      MediaPreviewModal.show(
                        context: context,
                        mediaUrl: message.attachmentUrl!,
                        mediaType: _detectMediaType(message.attachmentUrl!),
                        fileName: _extractFileName(message.attachmentUrl!),
                      );
                    },
                  ),
                ),
              ),
            ),
          // Message bubble
          chat_bubble.ChatBubble(
            message: message.content,
            type: message.isInbound ? chat_bubble.BubbleType.inbound : chat_bubble.BubbleType.outbound,
            status: message.isInbound ? null : _messageStatusToBubbleStatus(message.status),
            timestamp: _formatMessageTime(message.timestamp),
            senderName: message.isInbound ? widget.contactName : null,
          ),
        ],
      ),
      ),
    );
  }

  // Helper to detect media type from URL
  String _detectMediaType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.jpg') || lowerUrl.contains('.jpeg') || 
        lowerUrl.contains('.png') || lowerUrl.contains('.gif') ||
        lowerUrl.contains('.webp')) {
      return 'image';
    } else if (lowerUrl.contains('.mp4') || lowerUrl.contains('.mov') ||
               lowerUrl.contains('.avi') || lowerUrl.contains('.webm')) {
      return 'video';
    } else if (lowerUrl.contains('.pdf') || lowerUrl.contains('.doc') ||
               lowerUrl.contains('.docx') || lowerUrl.contains('.txt')) {
      return 'document';
    } else {
      return 'image'; // Default to image
    }
  }

  // Helper to extract file name from URL
  String? _extractFileName(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    } catch (e) {
      // If parsing fails, try to extract from URL string
      final parts = url.split('/');
      if (parts.isNotEmpty) {
        return parts.last;
      }
    }
    return null;
  }

  // Helper to get attachment label
  String? _getAttachmentLabel(String? url) {
    if (url == null) return null;
    final mediaType = _detectMediaType(url);
    switch (mediaType) {
      case 'image':
        return 'Image';
      case 'video':
        return 'Video';
      case 'document':
        return 'Document';
      default:
        return 'Attachment';
    }
  }
  
  chat_bubble.MessageStatus? _messageStatusToBubbleStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return chat_bubble.MessageStatus.sent; // Show as sent while sending
      case MessageStatus.sent:
        return chat_bubble.MessageStatus.sent;
      case MessageStatus.delivered:
        return chat_bubble.MessageStatus.delivered;
      case MessageStatus.read:
        return chat_bubble.MessageStatus.read;
      case MessageStatus.failed:
        return null; // Handle failed status separately if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isInSplitView = widget.onThreadUpdated != null; // If callback provided, we're in split view
    
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isInSplitView ? null : FrostedAppBar(
        title: widget.contactName,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (widget.onThreadUpdated != null) {
                widget.onThreadUpdated!();
              }
              Navigator.of(context).pop(true); // Return true to indicate possible mute state change
            },
          ),
        actions: [
          ChannelIconBadge(channel: widget.channel, size: 24),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'view_contact':
                  _viewContact();
                  break;
                case 'search':
                  _searchInThread();
                  break;
                case 'internal_notes':
                  _showInternalNotes();
                  break;
                case 'mute':
                  _toggleMute();
                  break;
                case 'archive':
                  _archiveThread();
                  break;
                case 'block':
                  _blockContact();
                  break;
                case 'react':
                  _showReactionPicker();
                  break;
                case 'details':
                  _showMessageDetails();
                  break;
              }
            },
            itemBuilder: (context) => [
              // Quick Actions (iOS-aligned: 3-4 items max)
              PopupMenuItem(
                value: 'view_contact',
                child: Builder(
                  builder: (context) => Row(
                  children: [
                      const Icon(Icons.person, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'View contact',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              ),
              PopupMenuItem(
                value: 'search',
                child: Builder(
                  builder: (context) => Row(
                  children: [
                      const Icon(Icons.search, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Search in chat',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'internal_notes',
                child: Builder(
                  builder: (context) => Row(
                  children: [
                    const Icon(Icons.note_add, size: 18),
                    const SizedBox(width: 8),
                      Text(
                        'Internal Notes',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (_noteCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.primaryTeal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$_noteCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                  ),
                ),
              ),
              // Note: React, Details, Mute, Archive, Block moved to long-press context menu
              // (iOS pattern: use context menus for secondary actions)
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline banner
          if (_isOffline || _queuedCount > 0)
            OfflineBanner(
              queuedCount: _queuedCount,
              onTap: () {
                if (_queuedCount > 0) {
                  Toast.show(
                    context,
                    message: '$_queuedCount message${_queuedCount > 1 ? 's' : ''} queued. Will send when online.',
                    type: ToastType.info,
                  );
                }
              },
            ),
          // ChatThreadView - Chronological message list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Reload messages and missed calls
                await Future.wait([
                  _loadInitialMessages(),
                  _loadMissedCalls(),
                ]);
              },
              child: Builder(
                builder: (context) {
                  final items = _buildThreadItems();
                  
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Newest messages at bottom (standard chat pattern)
                    padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
                    itemCount: items.length + (_isLoadingOlderMessages ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator when loading older messages (at bottom of reversed list)
                      if (_isLoadingOlderMessages && index == items.length) {
                        return Padding(
                          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(SwiftleadTokens.primaryTeal),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final item = items[index];
                      
                      switch (item.type) {
                        case _ThreadItemType.aiSummary:
                          return Padding(
                            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                            child: AISummaryCard(threadId: item.threadId!),
                          );
                        case _ThreadItemType.dateSeparator:
                          return DateSeparator(date: item.date!);
                        case _ThreadItemType.message:
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SwiftleadTokens.spaceM,
                              vertical: 2,
                            ),
                            child: _buildMessageWidget(item.message!),
                          );
                        case _ThreadItemType.missedCall:
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SwiftleadTokens.spaceM,
                              vertical: 2,
                            ),
                            child: MissedCallNotification(
                              missedCall: item.missedCall!,
                              onTextBack: () => _sendTextBack(item.missedCall!),
                            ),
                          );
                        case _ThreadItemType.typingIndicator:
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SwiftleadTokens.spaceM,
                            ),
                            child: TypingIndicator(contactName: widget.contactName),
                          );
                      }
                    },
                  );
                },
              ),
            ),
          ),
          
          // MessageComposerBar - Bottom sticky input
          MessageComposerBar(
            controller: _messageController,
            threadId: widget.threadId,
            contactId: widget.contactId,
            channel: _messageChannel,
            isTyping: _isTyping,
            onSend: () async {
              final content = _messageController.text.trim();
              if (content.isEmpty) return;
              
              final threadId = _currentThreadId;
              
              // Try to send immediately if online, otherwise queue
              if (_queueManager.isOnline) {
                try {
                  await MockMessages.sendMessage(
                    threadId: threadId,
                    content: content,
                    channel: _messageChannel,
                  );
                  _messageController.clear();
                  // Reload messages to show the new sent message
                  await _loadInitialMessages();
                } catch (e) {
                  // If send fails, queue it
                  await _queueManager.queueMessage(
                    threadId: threadId,
                    contactId: widget.contactId,
                    content: content,
                    channel: _messageChannel,
                  );
                  _messageController.clear();
                  
                  if (mounted) {
                    Toast.show(
                      context,
                      message: 'Message queued. Will send when online.',
                      type: ToastType.info,
                    );
                  }
                }
              } else {
                // Offline - queue the message
                await _queueManager.queueMessage(
                  threadId: threadId,
                  contactId: widget.contactId,
                  content: content,
                  channel: _messageChannel,
                );
                _messageController.clear();
                
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Message queued. Will send when online.',
                    type: ToastType.info,
                  );
                }
              }
            },
            onAttachment: () {},
            onPayment: _handleCreateQuoteFromInbox,
            onCreateJob: _handleCreateJobFromInbox,
            onAIExtractJob: _handleAIExtractJob,
            onAIReply: () {
              SmartReplySuggestionsSheet.show(
                context: context,
                threadId: widget.contactName,
                onReplySelected: (reply) {
                  _messageController.text = reply;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
