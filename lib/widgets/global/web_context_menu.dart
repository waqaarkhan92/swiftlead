import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'context_menu.dart';

/// Web-optimized context menu wrapper
/// Supports both right-click (web) and long-press (mobile)
class WebContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> items;

  const WebContextMenu({
    super.key,
    required this.child,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web: Support both right-click and long-press
      return GestureDetector(
        onSecondaryTap: () => _showContextMenu(context),
        onLongPress: () => _showContextMenu(context),
        child: child,
      );
    } else {
      // Mobile: Only long-press
      return GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: child,
      );
    }
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    SwiftleadContextMenu.show(
      context: context,
      position: position,
      items: items,
    );
  }
}

