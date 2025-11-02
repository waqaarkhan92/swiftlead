import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import 'typing_indicator.dart';

/// AIReceptionistThread - Chat interface simulating AI conversations
/// Exact specification from UI_Inventory_v2.5.1
class AIReceptionistThread extends StatefulWidget {
  final List<_ThreadMessage> messages;
  final bool isSimulating;
  final Function(String)? onUserMessage;
  final VoidCallback? onTestComplete;

  const AIReceptionistThread({
    super.key,
    required this.messages,
    this.isSimulating = false,
    this.onUserMessage,
    this.onTestComplete,
  });

  @override
  State<AIReceptionistThread> createState() => _AIReceptionistThreadState();
}

class _AIReceptionistThreadState extends State<AIReceptionistThread> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _isTyping = true;
    });

    widget.onUserMessage?.call(text);

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Conversation',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Messages List
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.02)
                  : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              itemCount: widget.messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.messages.length && _isTyping) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Color(SwiftleadTokens.primaryTeal),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'AI',
                                style: TextStyle(
                                  color: Color(SwiftleadTokens.primaryTeal),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TypingIndicator(),
                      ],
                    ),
                  );
                }

                final message = widget.messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                  child: _MessageBubble(
                    message: message,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Message Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a test message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceM,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (value) {
                    _sendMessage(value);
                    _messageController.clear();
                  },
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_messageController.text);
                  _messageController.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ThreadMessage message;

  const _MessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isFromAI) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(width: 4),
                const Text(
                  'AI',
                  style: TextStyle(
                    color: Color(SwiftleadTokens.primaryTeal),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(SwiftleadTokens.primaryTeal),
                    Color(SwiftleadTokens.accentAqua),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
  }
}

class _ThreadMessage {
  final String text;
  final bool isFromAI;
  final DateTime timestamp;

  _ThreadMessage({
    required this.text,
    required this.isFromAI,
    required this.timestamp,
  });
}

