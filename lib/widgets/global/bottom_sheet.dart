import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// BottomSheet / Modal Sheet
/// Exact specification from Theme_and_Design_System_v2.5.1
class SwiftleadBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final SheetHeight height;
  final bool isDismissible;
  final bool enableDrag;
  final VoidCallback? onDismiss;

  const SwiftleadBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.height = SheetHeight.half,
    this.isDismissible = true,
    this.enableDrag = true,
    this.onDismiss,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    SheetHeight height = SheetHeight.half,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => SwiftleadBottomSheet(
        child: child,
        title: title,
        actions: actions,
        height: height,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double sheetHeight;
    switch (height) {
      case SheetHeight.quarter:
        sheetHeight = screenHeight * 0.25;
        break;
      case SheetHeight.half:
        sheetHeight = screenHeight * 0.5;
        break;
      case SheetHeight.threeQuarter:
        sheetHeight = screenHeight * 0.75;
        break;
      case SheetHeight.full:
        sheetHeight = screenHeight * 0.9;
        break;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(SwiftleadTokens.radiusModal),
        topRight: Radius.circular(SwiftleadTokens.radiusModal),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: SwiftleadTokens.blurModal,
          sigmaY: SwiftleadTokens.blurModal,
        ),
        child: Container(
          height: sheetHeight,
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(SwiftleadTokens.radiusModal),
              topRight: Radius.circular(SwiftleadTokens.radiusModal),
            ),
          ),
          child: Column(
            children: [
              // Handle
              if (enableDrag)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: brightness == Brightness.light
                        ? Colors.black.withOpacity(0.2)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              
              // Header
              if (title != null || actions != null)
                Padding(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (title != null)
                        Expanded(
                          child: Text(
                            title!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),
              
              // Content
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SheetHeight {
  quarter,
  half,
  threeQuarter,
  full,
}

