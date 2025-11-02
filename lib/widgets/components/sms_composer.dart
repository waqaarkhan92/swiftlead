import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// SMSComposer - SMS text editor with counter
/// Exact specification from UI_Inventory_v2.5.1
class SMSComposer extends StatefulWidget {
  final String? initialContent;
  final Function(String content)? onUpdate;
  final int maxChars;
  final String? placeholder;

  const SMSComposer({
    super.key,
    this.initialContent,
    this.onUpdate,
    this.maxChars = 160,
    this.placeholder,
  });

  @override
  State<SMSComposer> createState() => _SMSComposerState();
}

class _SMSComposerState extends State<SMSComposer> {
  late TextEditingController _controller;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
    _charCount = widget.initialContent?.length ?? 0;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _charCount = _controller.text.length;
    });
    widget.onUpdate?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final isOverLimit = _charCount > widget.maxChars;
    final remaining = widget.maxChars - _charCount;
    final segmentCount = (_charCount / 160).ceil();

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text editor
          TextField(
            controller: _controller,
            maxLines: 6,
            maxLength: null, // No hard limit, but warn
            decoration: InputDecoration(
              hintText: widget.placeholder ?? 'Type your message...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          
          // Character counter and segment info
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                segmentCount > 1
                    ? '$segmentCount segments'
                    : '1 segment',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  if (isOverLimit) ...[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Color(SwiftleadTokens.errorRed),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    '$_charCount/${widget.maxChars}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOverLimit
                          ? const Color(SwiftleadTokens.errorRed)
                          : (remaining < 20
                              ? const Color(SwiftleadTokens.warningYellow)
                              : Theme.of(context).textTheme.bodySmall?.color),
                      fontWeight: isOverLimit || remaining < 20
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Warning message
          if (isOverLimit) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(SwiftleadTokens.errorRed),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Message exceeds character limit. It will be split into multiple messages.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(SwiftleadTokens.errorRed),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

