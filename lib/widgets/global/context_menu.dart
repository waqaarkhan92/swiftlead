import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'haptic_feedback.dart';

/// ContextMenu / Long-Press Menu
/// Exact specification from Theme_and_Design_System_v2.5.1
class SwiftleadContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> items;

  const SwiftleadContextMenu({
    super.key,
    required this.child,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: child,
    );
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Menu
          Positioned(
            left: position.dx,
            top: position.dy + renderBox.size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: SwiftleadTokens.blurModal,
                    sigmaY: SwiftleadTokens.blurModal,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white.withOpacity(0.96)
                          : const Color(0xFF191B1C).withOpacity(0.92),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.08)
                            : Colors.white.withOpacity(0.12),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            Theme.of(context).brightness == Brightness.light ? 0.2 : 0.4,
                          ),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            _ContextMenuItem(
                              item: item,
                              onTap: () {
                                Navigator.pop(context);
                                item.onTap?.call();
                              },
                            ),
                            if (index < items.length - 1)
                              Divider(
                                height: 1,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.08)
                                    : Colors.white.withOpacity(0.08),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextMenuItem extends StatefulWidget {
  final ContextMenuItem item;
  final VoidCallback onTap;

  const _ContextMenuItem({
    required this.item,
    required this.onTap,
  });

  @override
  State<_ContextMenuItem> createState() => _ContextMenuItemState();
}

class _ContextMenuItemState extends State<_ContextMenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDestructive = widget.item.isDestructive;
    final isDisabled = widget.item.isDisabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () {
          HapticFeedback.medium();
          widget.onTap();
        },
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          color: _isPressed
              ? (Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.08)
                  : Colors.white.withOpacity(0.10))
              : Colors.transparent,
          child: Row(
            children: [
              if (widget.item.icon != null)
                Icon(
                  widget.item.icon,
                  size: 20,
                  color: isDisabled
                      ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4)
                      : (isDestructive
                          ? const Color(SwiftleadTokens.errorRed)
                          : Theme.of(context).textTheme.bodyMedium?.color),
                ),
              if (widget.item.icon != null) const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    color: isDisabled
                        ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4)
                        : (isDestructive
                            ? const Color(SwiftleadTokens.errorRed)
                            : Theme.of(context).textTheme.bodyMedium?.color),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContextMenuItem {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isDisabled;

  const ContextMenuItem({
    this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.isDisabled = false,
  });
}

