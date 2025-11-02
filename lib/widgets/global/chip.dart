import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Chip Component - Filter/selectable chips
/// Exact specification from Theme_and_Design_System_v2.5.1
class SwiftleadChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool showCheckIcon;
  
  const SwiftleadChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.showCheckIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCheckIcon && isSelected) ...[
          const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: isSelected 
                ? Colors.white 
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0.02,
          ),
        ),
      ],
    );
    
    if (isSelected) {
      content = ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFF00D2C6),
            Color(0xFF00BFA3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: content,
      );
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.transparent
              : (isLight
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.24)),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isLight
                    ? Colors.black.withOpacity(0.10)
                    : Colors.white.withOpacity(0.08)),
          ),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(SwiftleadTokens.primaryTeal),
                    Color(SwiftleadTokens.accentAqua),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(SwiftleadTokens.accentAqua).withOpacity(0.22),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: content,
      ),
    );
  }
}

