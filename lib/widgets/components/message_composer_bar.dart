import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/bottom_sheet.dart';
import '../../screens/settings/canned_responses_screen.dart';
import '../forms/smart_reply_suggestions_sheet.dart';
import '../forms/schedule_message_sheet.dart';
import '../../models/message.dart';
import '../../mock/mock_messages.dart';
import '../../screens/inbox/scheduled_messages_screen.dart';

/// MessageComposerBar - Bottom sticky input with all buttons
/// Exact specification from Screen_Layouts_v2.5.1
class MessageComposerBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onPayment;
  final VoidCallback? onAIReply;
  final bool isTyping;
  final bool isSending;
  final String? threadId;
  final String? contactId;
  final MessageChannel? channel;
  
  const MessageComposerBar({
    super.key,
    required this.controller,
    this.onSend,
    this.onAttachment,
    this.onPayment,
    this.onAIReply,
    this.isTyping = false,
    this.isSending = false,
    this.threadId,
    this.contactId,
    this.channel,
  });

  @override
  State<MessageComposerBar> createState() => _MessageComposerBarState();
}

class _MessageComposerBarState extends State<MessageComposerBar> {
  bool _showCharacterCounter = false;
  bool _isSMS = true; // Track if current channel is SMS - always show counter for SMS

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    // For SMS, always show character counter per spec
    _showCharacterCounter = _isSMS;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Always show for SMS, otherwise show at 140+ characters
      _showCharacterCounter = _isSMS || widget.controller.text.length >= 140;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      borderRadius: 0,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: Row(
                  children: [
                    Text(
                      'Contact is typing...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AttachmentButton
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: widget.onAttachment,
                  tooltip: 'Attach file',
                ),
                // PaymentButton
                IconButton(
                  icon: const Icon(Icons.request_quote),
                  onPressed: widget.onPayment,
                  tooltip: 'Request payment',
                ),
                // TemplateButton (Quick Reply Templates)
                IconButton(
                  icon: const Icon(Icons.description_outlined),
                  onPressed: () => _showQuickReplyTemplates(context),
                  tooltip: 'Quick reply templates',
                ),
                // AIReplyButton
                IconButton(
                  icon: const Icon(Icons.auto_awesome),
                  color: const Color(SwiftleadTokens.primaryTeal),
                  onPressed: widget.onAIReply ?? () {
                    SmartReplySuggestionsSheet.show(
                      context: context,
                      threadId: 'current_thread',
                      onReplySelected: (reply) {
                        widget.controller.text = reply;
                      },
                    );
                  },
                  tooltip: 'AI reply suggestions',
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            // Text input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      counterText: _showCharacterCounter
                          ? '${widget.controller.text.length}/500'
                          : null,
                      counterStyle: TextStyle(
                        color: widget.controller.text.length > 500
                            ? const Color(SwiftleadTokens.errorRed)
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    maxLines: 5,
                    minLines: 1,
                    maxLength: _showCharacterCounter ? 500 : null,
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // SendButton - Teal gradient, disabled when empty, haptic on send
                widget.isSending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Schedule button (long-press send)
                          IconButton(
                            icon: const Icon(Icons.schedule_outlined),
                            onPressed: widget.controller.text.isNotEmpty &&
                                    widget.threadId != null &&
                                    widget.channel != null
                                ? () => _showScheduleSheet(context)
                                : null,
                            tooltip: 'Schedule message',
                          ),
                          // Send button
                          IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(SwiftleadTokens.primaryTeal),
                                    Color(SwiftleadTokens.accentAqua),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            onPressed: widget.controller.text.isNotEmpty
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    widget.onSend?.call();
                                  }
                                : null,
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleSheet(BuildContext context) {
    if (widget.threadId == null || widget.channel == null) return;

    ScheduleMessageSheet.show(
      context: context,
      threadId: widget.threadId!,
      contactId: widget.contactId,
      channel: widget.channel!,
      content: widget.controller.text,
    ).then((scheduled) {
      if (scheduled != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message scheduled for ${_formatScheduledTime(scheduled.scheduledFor)}'),
            backgroundColor: const Color(SwiftleadTokens.successGreen),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduledMessagesScreen(),
                  ),
                );
              },
            ),
          ),
        );
        widget.controller.clear();
      }
    });
  }

  String _formatScheduledTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Today';
    } else if (date == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr at $timeStr';
  }

  void _showQuickReplyTemplates(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Quick Reply Templates',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Template list would come from CannedResponsesScreen
          ListTile(
            leading: const Icon(Icons.reply_all),
            title: const Text('Business Hours'),
            subtitle: const Text('We are open Monday to Friday, 9am to 5pm.'),
            onTap: () {
              final text = 'We are open Monday to Friday, 9am to 5pm.';
              widget.controller.text = widget.controller.text.isEmpty 
                  ? text 
                  : '${widget.controller.text}\n\n$text';
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.reply_all),
            title: const Text('Booking Confirmation'),
            subtitle: const Text('Thank you! Your appointment is confirmed...'),
            onTap: () {
              final text = 'Thank you! Your appointment is confirmed. We look forward to seeing you.';
              widget.controller.text = widget.controller.text.isEmpty 
                  ? text 
                  : '${widget.controller.text}\n\n$text';
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.reply_all),
            title: const Text('Pricing Inquiry'),
            subtitle: const Text('Our standard rate is £150-300...'),
            onTap: () {
              final text = 'Our standard rate is £150-300 depending on the job. Would you like a detailed quote?';
              widget.controller.text = widget.controller.text.isEmpty 
                  ? text 
                  : '${widget.controller.text}\n\n$text';
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage Templates'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CannedResponsesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

