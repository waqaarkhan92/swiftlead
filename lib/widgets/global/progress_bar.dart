import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ProgressBar - Linear progress indicator
/// Exact specification from UI_Inventory_v2.5.1
class SwiftleadProgressBar extends StatelessWidget {
  final double? value; // null for indeterminate
  final double? minHeight;
  final Color? backgroundColor;
  final Color? valueColor;
  final String? label;

  const SwiftleadProgressBar({
    super.key,
    this.value,
    this.minHeight,
    this.backgroundColor,
    this.valueColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMinHeight = minHeight ?? 8.0;
    final effectiveBackgroundColor = backgroundColor ??
        (Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.06)
            : Colors.white.withOpacity(0.06));
    final effectiveValueColor =
        valueColor ?? const Color(SwiftleadTokens.primaryTeal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (value != null)
                Text(
                  '${(value! * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(effectiveMinHeight / 2),
          child: value == null
              ? LinearProgressIndicator(
                  minHeight: effectiveMinHeight,
                  backgroundColor: effectiveBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveValueColor),
                )
              : LinearProgressIndicator(
                  value: value!.clamp(0.0, 1.0),
                  minHeight: effectiveMinHeight,
                  backgroundColor: effectiveBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveValueColor),
                ),
        ),
      ],
    );
  }
}

