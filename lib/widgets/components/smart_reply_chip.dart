import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// SmartReplyChip - Chip containing suggested reply text with tap to use
/// Exact specification from UI_Inventory_v2.5.1
class SmartReplyChip extends StatelessWidget {
  final String replyText;
  final VoidCallback? onTap;
  final bool isSelected;

  const SmartReplyChip({
    super.key,
    required this.replyText,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SwiftleadTokens.spaceM,
          vertical: SwiftleadTokens.spaceS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
              : Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.03)
                  : Colors.white.withOpacity(0.03),
          border: Border.all(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
            const SizedBox(width: SwiftleadTokens.spaceXS),
            Flexible(
              child: Text(
                replyText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? const Color(SwiftleadTokens.primaryTeal)
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

