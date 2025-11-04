import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// PriorityBadge - Displays conversation priority indicator
/// Matches app theme and design system
enum ThreadPriority {
  low,
  medium,
  high,
}

extension ThreadPriorityExtension on ThreadPriority {
  String get displayName {
    switch (this) {
      case ThreadPriority.low:
        return 'Low';
      case ThreadPriority.medium:
        return 'Medium';
      case ThreadPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case ThreadPriority.low:
        return const Color(SwiftleadTokens.infoBlue);
      case ThreadPriority.medium:
        return const Color(SwiftleadTokens.warningYellow);
      case ThreadPriority.high:
        return const Color(SwiftleadTokens.errorRed);
    }
  }

  IconData get icon {
    switch (this) {
      case ThreadPriority.low:
        return Icons.arrow_downward;
      case ThreadPriority.medium:
        return Icons.remove;
      case ThreadPriority.high:
        return Icons.arrow_upward;
    }
  }
}

/// PriorityBadge - Visual indicator for conversation priority
/// Specification from Product_Definition_v2.5.1 §3.1 (v2.5.1 Enhancement)
class PriorityBadge extends StatelessWidget {
  final ThreadPriority? priority;
  final bool compact;

  const PriorityBadge({
    super.key,
    this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (priority == null) return const SizedBox.shrink();

    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    final color = priority!.color;

    if (compact) {
      // Compact dot indicator
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isLight ? Colors.white : Colors.black,
            width: 1.5,
          ),
        ),
      );
    }

    // Full badge with icon and label
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceS,
        vertical: SwiftleadTokens.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(isLight ? 0.15 : 0.2),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority!.icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: SwiftleadTokens.spaceXXS),
          Text(
            priority!.displayName,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

