import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ConfirmationDialog - Action confirmation modal
/// Exact specification from Theme_and_Design_System_v2.5.1
class SwiftleadConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? primaryActionLabel;
  final String secondaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final bool isDestructive;
  final IconData? icon;
  final bool requireTypeConfirm;
  final String? typeConfirmText;

  const SwiftleadConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    this.primaryActionLabel,
    this.secondaryActionLabel = 'Cancel',
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.isDestructive = false,
    this.icon,
    this.requireTypeConfirm = false,
    this.typeConfirmText,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
    String? primaryActionLabel,
    String secondaryActionLabel = 'Cancel',
    bool isDestructive = false,
    IconData? icon,
    bool requireTypeConfirm = false,
    String? typeConfirmText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: SwiftleadConfirmationDialog(
          title: title,
          description: description,
          primaryActionLabel: primaryActionLabel ?? (isDestructive ? 'Delete' : 'Confirm'),
          secondaryActionLabel: secondaryActionLabel,
          isDestructive: isDestructive,
          icon: icon,
          requireTypeConfirm: requireTypeConfirm,
          typeConfirmText: typeConfirmText,
          onPrimaryAction: () => Navigator.pop(context, true),
          onSecondaryAction: () => Navigator.pop(context, false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusModal),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: SwiftleadTokens.blurModal,
            sigmaY: SwiftleadTokens.blurModal,
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: brightness == Brightness.light
                    ? [
                        const Color(0xFFFFFFFF),
                        const Color(0xFFF8FBFA),
                      ]
                    : [
                        const Color(0xFF191B1C),
                        const Color(0xFF131516),
                      ],
              ),
              color: brightness == Brightness.light
                  ? Colors.white.withOpacity(0.96)
                  : const Color(0xFF191B1C).withOpacity(0.88),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusModal),
              border: Border.all(
                color: brightness == Brightness.light
                    ? Colors.black.withOpacity(0.08)
                    : Colors.white.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    brightness == Brightness.light ? 0.2 : 0.4,
                  ),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 48,
                    color: isDestructive
                        ? const Color(SwiftleadTokens.errorRed)
                        : const Color(SwiftleadTokens.warningYellow),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                ],
                
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: brightness == Brightness.light
                        ? const Color(0xFF1A1A1A)
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                
                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: brightness == Brightness.light
                        ? const Color(0xFF2A2A2A).withOpacity(0.87)
                        : Colors.white.withOpacity(0.75),
                  ),
                ),
                
                // Type confirmation field (for critical actions)
                if (requireTypeConfirm && typeConfirmText != null) ...[
                  const SizedBox(height: SwiftleadTokens.spaceL),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Type "${typeConfirmText}" to confirm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: SwiftleadTokens.spaceL),
                
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onSecondaryAction,
                      child: Text(secondaryActionLabel),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    ElevatedButton(
                      onPressed: onPrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive
                            ? const Color(SwiftleadTokens.errorRed)
                            : const Color(SwiftleadTokens.primaryTeal),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: SwiftleadTokens.spaceL,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
                        ),
                      ),
                      child: Text(primaryActionLabel ?? (isDestructive ? 'Delete' : 'Confirm')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

