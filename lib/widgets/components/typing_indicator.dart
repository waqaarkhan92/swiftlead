import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// TypingIndicator - Animated dots showing contact is typing
/// Exact specification from UI_Inventory_v2.5.1
class TypingIndicator extends StatefulWidget {
  final String? contactName;
  
  const TypingIndicator({
    super.key,
    this.contactName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    
    _animations = _controllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(controller)).toList();
    
    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = brightness == Brightness.light
        ? Colors.black.withOpacity(0.08)
        : Colors.white.withOpacity(0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.contactName != null) ...[
                  Text(
                    '${widget.contactName} is typing',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                ...List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Container(
                        margin: EdgeInsets.only(
                          left: index > 0 ? 4 : 0,
                        ),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.4 + (_animations[index].value * 0.4)),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

