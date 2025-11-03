import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Badge Component - Multiple variants as specified in UI_Inventory_v2.5.1
enum BadgeType { count, dot, status }

enum BadgeStatus { success, warning, error, info, neutral }

enum BadgeVariant { success, warning, error, info, neutral, secondary }

enum BadgeSize { small, medium, large }

/// SwiftleadBadge - Compatible version used throughout the app
class SwiftleadBadge extends StatelessWidget {
  final String? label;
  final BadgeVariant? variant;
  final BadgeStatus? status;
  final IconData? icon;
  final BadgeSize size;
  final int? count;
  final Widget? child;

  const SwiftleadBadge({
    super.key,
    this.label,
    this.variant,
    this.status,
    this.icon,
    this.size = BadgeSize.medium,
    this.count,
    this.child,
  });

  // Named constructor for status badges
  factory SwiftleadBadge.status({
    Key? key,
    required String label,
    required BadgeStatus status,
  }) {
    return SwiftleadBadge(key: key, label: label, status: status);
  }

  // Named constructor for variant badges
  factory SwiftleadBadge.variant({
    Key? key,
    required String label,
    required BadgeVariant variant,
  }) {
    return SwiftleadBadge(key: key, label: label, variant: variant);
  }

  @override
  Widget build(BuildContext context) {
    // If status is provided, use it directly
    if (status != null) {
      return Badge.status(
        label: label!,
        status: status!,
      );
    }
    
    // Otherwise, convert variant to status
    BadgeStatus badgeStatus;
    if (variant != null) {
      switch (variant!) {
        case BadgeVariant.success:
          badgeStatus = BadgeStatus.success;
          break;
        case BadgeVariant.warning:
          badgeStatus = BadgeStatus.warning;
          break;
        case BadgeVariant.error:
          badgeStatus = BadgeStatus.error;
          break;
        case BadgeVariant.info:
          badgeStatus = BadgeStatus.info;
          break;
        case BadgeVariant.neutral:
          badgeStatus = BadgeStatus.neutral;
          break;
        case BadgeVariant.secondary:
          badgeStatus = BadgeStatus.neutral;
          break;
      }
      return Badge.status(
        label: label!,
        status: badgeStatus,
      );
    }
    
    // Should not reach here
    return const SizedBox.shrink();
  }
}

class Badge extends StatelessWidget {
  final Widget? child;
  final int? count;
  final String? label;
  final BadgeType type;
  final BadgeStatus? status;
  final Color? customColor;
  
  // Count badge
  const Badge.count({
    super.key,
    required this.count,
    required this.child,
  }) : type = BadgeType.count,
       label = null,
       status = null,
       customColor = null;
  
  // Dot badge
  const Badge.dot({
    super.key,
    required this.customColor,
    required this.child,
  }) : type = BadgeType.dot,
       count = null,
       label = null,
       status = null;
  
  // Status badge
  const Badge.status({
    super.key,
    required this.label,
    required this.status,
  }) : type = BadgeType.status,
       count = null,
       child = null,
       customColor = null;

  Color _getStatusColor(BadgeStatus status, BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    
    switch (status) {
      case BadgeStatus.success:
        return isLight ? const Color(0xFF22C55E) : const Color(0xFF16A34A);
      case BadgeStatus.warning:
        return isLight ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
      case BadgeStatus.error:
        return isLight ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
      case BadgeStatus.info:
        return isLight ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
      case BadgeStatus.neutral:
        return isLight 
            ? Colors.black.withOpacity(0.08)
            : Colors.white.withOpacity(0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      // Badge overlay on child
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child!,
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              padding: type == BadgeType.count
                  ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
                  : null,
              width: type == BadgeType.dot ? 8 : null,
              height: type == BadgeType.dot ? 8 : null,
              decoration: BoxDecoration(
                color: type == BadgeType.count
                    ? const Color(SwiftleadTokens.badgeCountRed)
                    : (customColor ?? const Color(SwiftleadTokens.badgeDotTeal)),
                borderRadius: BorderRadius.circular(type == BadgeType.count ? 10 : 4),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: type == BadgeType.count && count != null
                  ? Text(
                      count! > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : null,
            ),
          ),
        ],
      );
    } else {
      // Status badge (standalone)
      final bgColor = _getStatusColor(status!, context);
      final textColor = status == BadgeStatus.neutral
          ? Theme.of(context).textTheme.bodyMedium?.color
          : Colors.white;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label!,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}

