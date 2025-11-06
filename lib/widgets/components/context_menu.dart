import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ContextMenu - Long-press context menu for metrics and widgets
class ContextMenu {
  static void show({
    required BuildContext context,
    required Offset position,
    required List<ContextMenuAction> actions,
  }) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      items: actions.map((action) {
        return PopupMenuItem<ContextMenuAction>(
          value: action,
          child: Row(
            children: [
              Icon(
                action.icon,
                size: 20,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Text(action.label),
            ],
          ),
        );
      }).toList(),
    ).then((selectedAction) {
      if (selectedAction != null) {
        selectedAction.onTap();
      }
    });
  }
}

class ContextMenuAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ContextMenuAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

