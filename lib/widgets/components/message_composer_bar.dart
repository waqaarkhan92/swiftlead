import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/bottom_sheet.dart';
import '../../screens/settings/canned_responses_screen.dart';
import '../forms/smart_reply_suggestions_sheet.dart';

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
  
  const MessageComposerBar({
    super.key,
    required this.controller,
    this.onSend,
    this.onAttachment,
    this.onPayment,
    this.onAIReply,
    this.isTyping = false,
    this.isSending = false,
  });

  @override
  State<MessageComposerBar> createState() => _MessageComposerBarState();
}

class _MessageComposerBarState extends State<MessageComposerBar> {
  bool _showCharacterCounter = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showCharacterCounter = widget.controller.text.length >= 140;
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
                    : IconButton(
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
      ),
    );
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
              // Insert template into message
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.reply_all),
            title: const Text('Booking Confirmation'),
            subtitle: const Text('Thank you! Your appointment is confirmed...'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.reply_all),
            title: const Text('Pricing Inquiry'),
            subtitle: const Text('Our standard rate is £150-300...'),
            onTap: () {
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

