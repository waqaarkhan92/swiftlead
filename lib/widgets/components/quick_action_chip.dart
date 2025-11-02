import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// QuickActionChip - Action chip with tooltip
/// Exact specification from Screen_Layouts_v2.5.1
class QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  
  const QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        margin: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: isLight
              ? Colors.white.withOpacity(0.88)
              : const Color(0xFF131516).withOpacity(0.78),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          border: Border.all(
            color: isLight
                ? Colors.black.withOpacity(SwiftleadTokens.borderOpacityLight)
                : Colors.white.withOpacity(SwiftleadTokens.borderOpacityDark),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

