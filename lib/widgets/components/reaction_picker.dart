import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ReactionPicker - Emoji reaction overlay on long-press message
/// Exact specification from UI_Inventory_v2.5.1
class ReactionPicker extends StatelessWidget {
  final Function(String emoji)? onReactionSelected;
  
  const ReactionPicker({
    super.key,
    this.onReactionSelected,
  });

  static const List<String> _reactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '🙏',
  ];

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _reactions.map((emoji) {
          return GestureDetector(
            onTap: () {
              onReactionSelected?.call(emoji);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static void show(
    BuildContext context,
    Function(String emoji)? onReactionSelected,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => ReactionPicker(
        onReactionSelected: onReactionSelected,
      ),
    );
  }
}

