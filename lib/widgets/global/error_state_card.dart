import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'primary_button.dart';

/// ErrorStateCard - Error display with retry action
/// Exact specification from Screen_Layouts_v2.5.1
class ErrorStateCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? errorCode;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onRetry;
  final VoidCallback? onHelp;
  
  const ErrorStateCard({
    super.key,
    required this.title,
    this.description,
    this.errorCode,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onRetry,
    this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final errorBg = brightness == Brightness.light
        ? const Color(SwiftleadTokens.errorRed).withOpacity(0.08)
        : const Color(0xFFF87171).withOpacity(0.12);
    final errorBorder = brightness == Brightness.light
        ? const Color(SwiftleadTokens.errorRed).withOpacity(0.2)
        : const Color(0xFFF87171).withOpacity(0.3);
    final errorIcon = brightness == Brightness.light
        ? const Color(SwiftleadTokens.errorRed)
        : const Color(0xFFF87171);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceXL),
        child: Container(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          decoration: BoxDecoration(
            color: errorBg,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.8),
            border: Border.all(
              color: errorBorder,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.warning_rounded,
                size: 48,
                color: errorIcon,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: errorIcon,
                ),
                textAlign: TextAlign.center,
              ),
              if (description != null) ...[
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  description!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (errorCode != null) ...[
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Error ID: $errorCode',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (onAction != null || onRetry != null || onHelp != null) ...[
                const SizedBox(height: SwiftleadTokens.spaceL),
                if (onAction != null)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: actionLabel ?? 'Try Again',
                      onPressed: onAction,
                    ),
                  )
                else if (onRetry != null)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: 'Try Again',
                      onPressed: onRetry,
                    ),
                  ),
                if (onHelp != null) ...[
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextButton(
                    onPressed: onHelp,
                    child: const Text('Get Help'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

