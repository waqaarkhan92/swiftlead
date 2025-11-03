import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/chat_bubble.dart' as chat_bubble show ChatBubble, BubbleType, MessageStatus;
import '../../widgets/components/date_separator.dart';
import '../../widgets/components/message_composer_bar.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/forms/smart_reply_suggestions_sheet.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../contacts/contact_detail_screen.dart';
import '../../models/contact.dart';
import '../../mock/mock_contacts.dart';
import '../../mock/mock_messages.dart';
import '../../models/message.dart';
import '../../widgets/components/internal_notes_modal.dart';
import '../../widgets/components/ai_summary_card.dart';
import '../../widgets/components/reaction_picker.dart';
import '../../widgets/components/message_detail_sheet.dart';
import '../../widgets/components/voice_note_player.dart';
import '../../widgets/components/link_preview_card.dart';
import '../../widgets/components/typing_indicator.dart';
import '../../widgets/forms/message_actions_sheet.dart';
import 'thread_search_screen.dart';

/// InboxThreadScreen - Conversation thread view
/// Exact specification from Screen_Layouts_v2.5.1
class InboxThreadScreen extends StatefulWidget {
  final String contactName;
  final String channel; // Display name like "SMS", "WhatsApp"
  final String? contactId; // Optional contact ID for direct lookup
  final String? threadId; // Optional thread ID for search and other operations
  
  const InboxThreadScreen({
    super.key,
    required this.contactName,
    required this.channel,
    this.contactId,
    this.threadId,
  });

  @override
  State<InboxThreadScreen> createState() => _InboxThreadScreenState();
}

class _InboxThreadScreenState extends State<InboxThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  bool _contactIsTyping = false; // Track if contact is typing
  int _noteCount = 3;
  
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
          MaterialPageRoute(
            builder: (context) => ContactDetailScreen(
              contactId: contact!.id,
            ),
          ),
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
        MaterialPageRoute(
          builder: (context) => ThreadSearchScreen(
            threadId: threadId!,
            contactName: widget.contactName,
            channel: widget.channel,
          ),
        ),
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

  void _handleCreateQuoteFromInbox() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuoteScreen(
          initialData: {
            'clientName': 'John Smith', // Would come from thread data
            'notes': 'Quote from ${widget.channel} conversation',
            'taxRate': 20.0,
          },
        ),
      ),
    ).then((_) {
      Toast.show(
        context,
        message: 'Quote created from conversation',
        type: ToastType.success,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.contactName,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(true), // Return true to indicate possible mute state change
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
              const PopupMenuItem(
                value: 'react',
                child: Row(
                  children: [
                    Icon(Icons.add_reaction, size: 18),
                    SizedBox(width: 8),
                    Text('React'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18),
                    SizedBox(width: 8),
                    Text('Details'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'view_contact',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18),
                    SizedBox(width: 8),
                    Text('View contact'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, size: 18),
                    SizedBox(width: 8),
                    Text('Search in chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'internal_notes',
                child: Row(
                  children: [
                    const Icon(Icons.note_add, size: 18),
                    const SizedBox(width: 8),
                    const Text('Internal Notes'),
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
              PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(_isMuted ? Icons.notifications : Icons.notifications_off, size: 18),
                    const SizedBox(width: 8),
                    Text(_isMuted ? 'Unmute' : 'Mute'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive, size: 18),
                    SizedBox(width: 8),
                    Text('Archive'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 18),
                    SizedBox(width: 8),
                    Text('Block'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ChatThreadView - Chronological message list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Actual message sync - reload messages from mock data
                await Future.delayed(const Duration(milliseconds: 500));
                // In real app, this would sync with backend
                setState(() {
                  // Trigger rebuild to show updated messages
                });
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
                children: [
                  // AI Summary Card - placed at top of scrollable message list per spec
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: AISummaryCard(
                      threadId: widget.threadId ?? widget.contactId ?? widget.contactName,
                    ),
                  ),
                  // Typing Indicator - show when contact is typing
                  if (_contactIsTyping)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
                      child: TypingIndicator(contactName: widget.contactName),
                    ),
                  DateSeparator(date: DateTime.now().subtract(const Duration(days: 1))),
                  // Message with voice note example
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () async {
                                final action = await MessageActionsSheet.show(
                                  context: context,
                                  messageId: 'msg_1',
                                  channel: _messageChannel,
                                  canEdit: false,
                                  canDelete: false,
                                );
                                if (action != null && mounted) {
                                  switch (action) {
                                    case 'copy':
                                      Toast.show(context, message: 'Message copied', type: ToastType.success);
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
                              child: chat_bubble.ChatBubble(
                                message: 'Hi, I need a quote for kitchen sink repair',
                                type: chat_bubble.BubbleType.inbound,
                                timestamp: '10:30 AM',
                                senderName: widget.contactName,
                              ),
                            ),
                            // Example: Add voice note player if message has voice note
                            Padding(
                              padding: const EdgeInsets.only(left: SwiftleadTokens.spaceM, top: 4),
                              child: VoiceNotePlayer(
                                url: 'https://example.com/voice_note.mp3',
                                duration: const Duration(seconds: 45),
                                isOutbound: false,
                              ),
                            ),
                          ],
                        ),
                  GestureDetector(
                          onLongPress: () async {
                            final action = await MessageActionsSheet.show(
                              context: context,
                              messageId: 'msg_2',
                              channel: _messageChannel,
                              canEdit: true,
                              canDelete: true,
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
                                case 'details':
                                  _showMessageDetails();
                                  break;
                              }
                            }
                          },
                          child: chat_bubble.ChatBubble(
                            message: 'Hi! I\'d be happy to help. When would be a good time for me to take a look?',
                            type: chat_bubble.BubbleType.outbound,
                            status: chat_bubble.MessageStatus.read,
                            timestamp: '10:32 AM',
                          ),
                        ),
                  DateSeparator(date: DateTime.now()),
                  // Message with link preview example
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                // Show reaction picker on long-press per spec
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
                              },
                              child: chat_bubble.ChatBubble(
                                message: 'Can you come today afternoon? Here\'s a link: https://example.com',
                                type: chat_bubble.BubbleType.inbound,
                                timestamp: '10:33 AM',
                                senderName: widget.contactName,
                              ),
                            ),
                            // Example: Add link preview if message has URL
                            Padding(
                              padding: const EdgeInsets.only(left: SwiftleadTokens.spaceM, right: SwiftleadTokens.spaceM, top: 4),
                              child: LinkPreviewCard(
                                url: 'https://example.com',
                                title: 'Example Website',
                                description: 'This is an example link preview',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
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
            onSend: () {
              _messageController.clear();
            },
            onAttachment: () {},
            onPayment: _handleCreateQuoteFromInbox,
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
