import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/chat_bubble.dart';
import '../../widgets/components/date_separator.dart';
import '../../widgets/components/message_composer_bar.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/forms/smart_reply_suggestions_sheet.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import '../quotes/create_edit_quote_screen.dart';

/// InboxThreadScreen - Conversation thread view
/// Exact specification from Screen_Layouts_v2.5.1
class InboxThreadScreen extends StatefulWidget {
  final String contactName;
  final String channel;
  
  const InboxThreadScreen({
    super.key,
    required this.contactName,
    required this.channel,
  });

  @override
  State<InboxThreadScreen> createState() => _InboxThreadScreenState();
}

class _InboxThreadScreenState extends State<InboxThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  int _noteCount = 3;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          ChannelIconBadge(channel: widget.channel, size: 24),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'view_contact':
                  // View contact
                  break;
                case 'search':
                  // Search in chat
                  break;
                case 'internal_notes':
                  // Show internal notes sheet
                  break;
                case 'mute':
                  // Mute
                  break;
                case 'archive':
                  // Archive
                  break;
                case 'block':
                  // Block
                  break;
              }
            },
            itemBuilder: (context) => [
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
              const PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off, size: 18),
                    SizedBox(width: 8),
                    Text('Mute'),
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
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
                children: [
                  DateSeparator(date: DateTime.now().subtract(const Duration(days: 1))),
                  ChatBubble(
                    message: 'Hi, I need a quote for kitchen sink repair',
                    type: BubbleType.inbound,
                    timestamp: '10:30 AM',
                    senderName: widget.contactName,
                  ),
                  ChatBubble(
                    message: 'Hi! I\'d be happy to help. When would be a good time for me to take a look?',
                    type: BubbleType.outbound,
                    status: MessageStatus.read,
                    timestamp: '10:32 AM',
                  ),
                  DateSeparator(date: DateTime.now()),
                  ChatBubble(
                    message: 'Can you come today afternoon?',
                    type: BubbleType.inbound,
                    timestamp: '10:33 AM',
                    senderName: widget.contactName,
                  ),
                ],
              ),
            ),
          ),
          
          // MessageComposerBar - Bottom sticky input
          MessageComposerBar(
            controller: _messageController,
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
