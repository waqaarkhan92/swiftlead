import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

enum ButtonSize { small, medium, large }

/// Primary Button - Canonical implementation from Theme_and_Design_System_v2.5.1
/// Teal gradient button with exact specifications
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;
  
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
  });

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return SwiftleadTokens.buttonHeightLarge.toDouble();
      case ButtonSize.large:
        return SwiftleadTokens.buttonHeightLarge.toDouble();
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 17;
      case ButtonSize.large:
        return 17;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 20;
    }
  }

  double _getVerticalPadding() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();
    final verticalPadding = _getVerticalPadding();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(SwiftleadTokens.primaryTeal),
            Color(SwiftleadTokens.accentAqua),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
        boxShadow: [
          BoxShadow(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.08),
            blurRadius: 48,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(double.infinity, height),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white, // Fully opaque
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 1,
                          offset: Offset(0, 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

