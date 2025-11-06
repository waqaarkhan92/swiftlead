import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/bottom_sheet.dart';
import '../global/haptic_feedback.dart' as app_haptics;
import '../../screens/settings/canned_responses_screen.dart';
import '../forms/schedule_message_sheet.dart';
import '../../models/message.dart';
import '../../screens/inbox/scheduled_messages_screen.dart';

/// MessageComposerBar - iOS-style message composer
/// Matches iOS Messages app pattern with dynamic button switching
class MessageComposerBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onPayment;
  final VoidCallback? onCreateJob;
  final VoidCallback? onAIExtractJob;
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
    this.onCreateJob,
    this.onAIExtractJob,
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

class _MessageComposerBarState extends State<MessageComposerBar>
    with SingleTickerProviderStateMixin {
  bool _showCharacterCounter = false;
  final bool _isSMS = true;
  late AnimationController _buttonAnimationController;
  late Animation<double> _sendButtonScale;
  late Animation<double> _sendButtonOpacity;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _showCharacterCounter = _isSMS;
    
    // Animation controller for send button appearance
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _sendButtonScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _sendButtonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOut,
      ),
    );
    
    // Initialize animation state based on text
    if (widget.controller.text.isNotEmpty) {
      _buttonAnimationController.forward();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    
    setState(() {
      _showCharacterCounter = _isSMS || widget.controller.text.length >= 140;
    });
    
    // Animate send button appearance/disappearance
    if (hasText) {
      _buttonAnimationController.forward();
    } else {
      _buttonAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;
    final isSending = widget.isSending;
    
    return FrostedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      borderRadius: 0,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Typing indicator
            if (widget.isTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: Row(
                  children: [
                    Text(
                      'Contact is typing...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            // Main input row - iOS style
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Plus button (left side) - shows action menu on long press
                GestureDetector(
                  onLongPress: () {
                    app_haptics.HapticFeedback.longPress();
                    _showPlusButtonMenu(context);
                  },
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 28,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    onPressed: () {
                      app_haptics.HapticFeedback.light();
                      _showPlusButtonMenu(context);
                    },
                    tooltip: 'Add attachment or action',
                  ),
                ),
                const SizedBox(width: 8),
                // iOS-style text field
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 120, // ~5 lines
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: widget.controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        counterText: '',
                      ),
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Right side button - Send when text, Mic when empty
                if (isSending)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                    ),
                  )
                else if (hasText)
                  // Send button - circular, animated
                  AnimatedBuilder(
                    animation: _buttonAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _sendButtonScale.value,
                        child: Opacity(
                          opacity: _sendButtonOpacity.value,
                          child: GestureDetector(
                            onTap: () {
                              app_haptics.HapticFeedback.success();
                              widget.onSend?.call();
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(SwiftleadTokens.primaryTeal),
                                    Color(SwiftleadTokens.accentAqua),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(SwiftleadTokens.primaryTeal)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                else
                  // Microphone button (when empty)
                  IconButton(
                    icon: const Icon(Icons.mic_outlined),
                    iconSize: 28,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    onPressed: () {
                      app_haptics.HapticFeedback.light();
                      // TODO: Implement voice input
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice input coming soon'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Voice message',
                  ),
              ],
            ),
            // Character counter (below text field, right-aligned)
            if (_showCharacterCounter)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${widget.controller.text.length}/500',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.controller.text.length > 500
                          ? const Color(SwiftleadTokens.errorRed)
                          : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _showPlusButtonMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: SwiftleadTokens.spaceM,
                  crossAxisSpacing: SwiftleadTokens.spaceM,
                  childAspectRatio: 0.9,
                  children: [
                    _buildActionItem(
                      context,
                      icon: Icons.photo_library_outlined,
                      label: 'Photo',
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAttachment?.call();
                      },
                    ),
                    _buildActionItem(
                      context,
                      icon: Icons.insert_drive_file_outlined,
                      label: 'Document',
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAttachment?.call();
                      },
                    ),
                    _buildActionItem(
                      context,
                      icon: Icons.request_quote,
                      label: 'Payment',
                      onTap: () {
                        Navigator.pop(context);
                        widget.onPayment?.call();
                      },
                    ),
                    if (widget.onCreateJob != null)
                      _buildActionItem(
                        context,
                        icon: Icons.work_outline,
                        label: 'Job',
                        onTap: () {
                          Navigator.pop(context);
                          widget.onCreateJob?.call();
                        },
                      ),
                    if (widget.onAIExtractJob != null)
                      _buildActionItem(
                        context,
                        icon: Icons.auto_awesome_outlined,
                        label: 'AI Extract',
                        onTap: () {
                          Navigator.pop(context);
                          widget.onAIExtractJob?.call();
                        },
                      ),
                    _buildActionItem(
                      context,
                      icon: Icons.description_outlined,
                      label: 'Templates',
                      onTap: () {
                        Navigator.pop(context);
                        _showQuickReplyTemplates(context);
                      },
                    ),
                    _buildActionItem(
                      context,
                      icon: Icons.auto_awesome,
                      label: 'AI Reply',
                      color: const Color(SwiftleadTokens.primaryTeal),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onAIReply?.call();
                      },
                    ),
                    if (widget.threadId != null && widget.channel != null)
                      _buildActionItem(
                        context,
                        icon: Icons.schedule_outlined,
                        label: 'Schedule',
                        onTap: () {
                          Navigator.pop(context);
                          _showScheduleSheet(context);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: () {
        app_haptics.HapticFeedback.light();
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color ?? Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
      if (scheduled != null && mounted && context.mounted) {
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
              const text = 'We are open Monday to Friday, 9am to 5pm.';
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
              const text = 'Thank you! Your appointment is confirmed. We look forward to seeing you.';
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
              const text = 'Our standard rate is £150-300 depending on the job. Would you like a detailed quote?';
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

