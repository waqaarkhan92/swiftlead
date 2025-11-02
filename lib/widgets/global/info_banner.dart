import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'frosted_container.dart';

/// InfoBanner - Contextual information strip
/// Exact specification from UI_Inventory_v2.5.1 and Theme_and_Design_System_v2.5.1
/// Supports: Info, Warning, Success, Promo variants
class InfoBanner extends StatelessWidget {
  final String message;
  final InfoBannerType type;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  
  const InfoBanner({
    super.key,
    required this.message,
    this.type = InfoBannerType.info,
    this.icon,
    this.onTap,
    this.onDismiss,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    // Color scheme based on type
    Color backgroundColor;
    Color iconColor;
    Color textColor;
    IconData defaultIcon;
    
    switch (type) {
      case InfoBannerType.info:
        backgroundColor = brightness == Brightness.light
            ? const Color(0xFF3B82F6).withOpacity(0.08)
            : const Color(0xFF60A5FA).withOpacity(0.12);
        iconColor = const Color(SwiftleadTokens.infoBlue);
        textColor = brightness == Brightness.light
            ? const Color(0xFF1A1C1E)
            : const Color(0xFFF5F5F5);
        defaultIcon = Icons.info_outline;
        break;
      case InfoBannerType.warning:
        backgroundColor = brightness == Brightness.light
            ? const Color(0xFFF59E0B).withOpacity(0.08)
            : const Color(0xFFFCD34D).withOpacity(0.12);
        iconColor = const Color(0xFFF59E0B);
        textColor = brightness == Brightness.light
            ? const Color(0xFF1A1C1E)
            : const Color(0xFFF5F5F5);
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case InfoBannerType.success:
        backgroundColor = brightness == Brightness.light
            ? const Color(0xFF22C55E).withOpacity(0.08)
            : const Color(0xFF4ADE80).withOpacity(0.12);
        iconColor = const Color(SwiftleadTokens.successGreen);
        textColor = brightness == Brightness.light
            ? const Color(0xFF1A1C1E)
            : const Color(0xFFF5F5F5);
        defaultIcon = Icons.check_circle_outline;
        break;
      case InfoBannerType.promo:
        backgroundColor = brightness == Brightness.light
            ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.08)
            : const Color(SwiftleadTokens.accentAqua).withOpacity(0.12);
        iconColor = const Color(SwiftleadTokens.primaryTeal);
        textColor = brightness == Brightness.light
            ? const Color(0xFF1A1C1E)
            : const Color(0xFFF5F5F5);
        defaultIcon = Icons.local_offer_outlined;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: FrostedContainer(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: iconColor.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon ?? defaultIcon,
                size: 16,
                color: iconColor,
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (actionLabel != null && onTap != null) ...[
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        actionLabel!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: iconColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: Icon(Icons.close, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDismiss,
                color: textColor.withOpacity(0.6),
              ),
          ],
        ),
      ),
    );
  }
}

enum InfoBannerType {
  info,
  warning,
  success,
  promo,
}

