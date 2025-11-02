import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart';

/// UnreadBadge - Numeric count on conversation rows and tab icons
/// Exact specification from UI_Inventory_v2.5.1
class UnreadBadge extends StatelessWidget {
  final int count;
  final double? size;
  final bool showDotOnly;
  
  const UnreadBadge({
    super.key,
    required this.count,
    this.size,
    this.showDotOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    
    if (showDotOnly) {
      return Container(
        width: size ?? 8,
        height: size ?? 8,
        decoration: const BoxDecoration(
          color: Color(SwiftleadTokens.primaryTeal),
          shape: BoxShape.circle,
        ),
      );
    }
    
    // Use numeric badge for counts > 0
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(SwiftleadTokens.badgeCountRed),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

