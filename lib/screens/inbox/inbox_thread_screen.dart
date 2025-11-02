import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/chat_bubble.dart';
import '../../widgets/components/date_separator.dart';
import '../../widgets/components/message_composer_bar.dart';
import '../../widgets/components/internal_notes_button.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/forms/smart_reply_suggestions_sheet.dart';
import '../../theme/tokens.dart';

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
            onPayment: () {},
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
      floatingActionButton: InternalNotesButton(
        noteCount: _noteCount,
        onTap: () {
          // Slides in from right when tapped
        },
      ),
    );
  }
}
