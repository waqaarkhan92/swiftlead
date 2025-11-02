import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme/tokens.dart';

/// Toast Notification - Brief feedback messages
/// Exact specification from Theme_and_Design_System_v2.5.1
enum ToastType { success, error, info, warning }

class Toast {
  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration? duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    Color backgroundColor;
    Color iconColor = Colors.white;
    IconData iconData;
    
    switch (type) {
      case ToastType.success:
        backgroundColor = isLight
            ? const Color(0xFF22C55E).withOpacity(0.95)
            : const Color(0xFF16A34A).withOpacity(0.90);
        iconData = Icons.check_circle_outline;
        break;
      case ToastType.error:
        backgroundColor = isLight
            ? const Color(SwiftleadTokens.errorRed).withOpacity(0.95)
            : const Color(0xFFDC2626).withOpacity(0.90);
        iconData = Icons.error_outline;
        break;
      case ToastType.info:
        backgroundColor = isLight
            ? const Color(SwiftleadTokens.infoBlue).withOpacity(0.95)
            : const Color(0xFF2563EB).withOpacity(0.90);
        iconData = Icons.info_outline;
        break;
      case ToastType.warning:
        backgroundColor = isLight
            ? const Color(SwiftleadTokens.warningYellow).withOpacity(0.95)
            : const Color(0xFFD97706).withOpacity(0.90);
        iconData = Icons.warning_outlined;
        break;
    }
    
    final defaultDuration = type == ToastType.error || type == ToastType.warning
        ? SwiftleadTokens.toastError
        : SwiftleadTokens.toastSuccess;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isLight ? 24 : 26,
              sigmaY: isLight ? 24 : 26,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isLight ? 0.15 : 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, color: iconColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (onAction != null && actionLabel != null) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        onAction();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.only(
          bottom: 80, // 60px from bottom nav + 20px padding
          left: 16,
          right: 16,
        ),
        behavior: SnackBarBehavior.floating,
        duration: duration ?? defaultDuration,
      ),
    );
  }
}

