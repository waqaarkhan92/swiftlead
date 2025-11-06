import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Hoverable Widget - Adds hover effects for web
/// Works on both web (hover) and mobile (no effect)
class HoverableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap; // Right-click on web
  final double hoverScale;
  final Color? hoverColor;

  const HoverableWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.hoverScale = 1.02,
    this.hoverColor,
  });

  @override
  State<HoverableWidget> createState() => _HoverableWidgetState();
}

class _HoverableWidgetState extends State<HoverableWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: kIsWeb ? (_) => setState(() => _isHovered = true) : null,
      onExit: kIsWeb ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onSecondaryTap: kIsWeb ? widget.onSecondaryTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: kIsWeb && _isHovered
              ? (Matrix4.identity()..scale(widget.hoverScale))
              : Matrix4.identity(),
          decoration: kIsWeb && _isHovered && widget.hoverColor != null
              ? BoxDecoration(
                  color: widget.hoverColor!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                )
              : null,
          child: widget.child,
        ),
      ),
    );
  }
}

