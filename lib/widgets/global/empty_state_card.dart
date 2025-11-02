import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'primary_button.dart';

/// EmptyStateCard - Empty state placeholder with CTA
/// Exact specification from Screen_Layouts_v2.5.1
class EmptyStateCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;
  
  const EmptyStateCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final iconColor = brightness == Brightness.light
        ? Colors.black.withOpacity(0.3)
        : Colors.white.withOpacity(0.3);
    final textColor = brightness == Brightness.light
        ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.6);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null)
              SizedBox(
                width: 160,
                height: 160,
                child: Opacity(
                  opacity: 0.3,
                  child: illustration,
                ),
              )
            else if (icon != null)
              Icon(
                icon,
                size: 80,
                color: iconColor,
              ),
            
            if (illustration != null || icon != null)
              const SizedBox(height: SwiftleadTokens.spaceM),
            
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (description != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceL),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: actionLabel!,
                  onPressed: onAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

