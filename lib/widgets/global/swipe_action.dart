import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// SwipeAction - Quick actions via swipe gesture
/// Exact specification from UI_Inventory_v2.5.1
class SwiftleadSwipeAction extends StatelessWidget {
  final Widget child;
  final List<SwipeActionItem> actions;
  final VoidCallback? onTap;

  const SwiftleadSwipeAction({
    super.key,
    required this.child,
    required this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
      background: _buildSwipeBackground(context, actions.isNotEmpty ? actions[0] : null, true),
      secondaryBackground: _buildSwipeBackground(context, actions.length > 1 ? actions[1] : null, false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd && actions.isNotEmpty) {
          actions[0].onAction();
          return false; // Don't dismiss, just trigger action
        } else if (direction == DismissDirection.endToStart && actions.length > 1) {
          actions[1].onAction();
          return false; // Don't dismiss, just trigger action
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, SwipeActionItem? action, bool isLeft) {
    if (action == null) return Container();

    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: action.backgroundColor ?? const Color(SwiftleadTokens.primaryTeal),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isLeft) ...[
            Icon(action.icon, color: Colors.white),
            const SizedBox(width: SwiftleadTokens.spaceS),
          ],
          Text(
            action.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isLeft) ...[
            const SizedBox(width: SwiftleadTokens.spaceS),
            Icon(action.icon, color: Colors.white),
          ],
        ],
      ),
    );
  }
}

class SwipeActionItem {
  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final VoidCallback onAction;

  SwipeActionItem({
    required this.label,
    required this.icon,
    required this.onAction,
    this.backgroundColor,
  });
}

