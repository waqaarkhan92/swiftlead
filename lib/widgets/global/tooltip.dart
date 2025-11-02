import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Tooltip - Contextual help on hover/long-press
/// Exact specification from UI_Inventory_v2.5.1 and Theme_and_Design_System_v2.5.1
class SwiftleadTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final TooltipPosition position;
  final bool showOnLongPress;

  const SwiftleadTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = TooltipPosition.top,
    this.showOnLongPress = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: showOnLongPress ? () => _showTooltip(context) : null,
      child: MouseRegion(
        onEnter: (event) {
          // Web hover - show tooltip after 400ms delay
          // On mobile, long-press is used instead
          if (Theme.of(context).platform != TargetPlatform.iOS &&
              Theme.of(context).platform != TargetPlatform.android) {
            Future.delayed(const Duration(milliseconds: 400), () {
              // Show tooltip (would use Overlay for persistent tooltip)
            });
          }
        },
        child: child,
      ),
    );
  }

  void _showTooltip(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx + size.width / 2 - 100,
            top: this.position == TooltipPosition.top
                ? position.dy - 40
                : position.dy + size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.90)
                      : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF0B0D0D),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
}

