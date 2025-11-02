import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// LoadingSpinner - Inline progress indicator
/// Exact specification from UI_Inventory_v2.5.1
class LoadingSpinner extends StatelessWidget {
  final SpinnerSize size;
  final Color? color;

  const LoadingSpinner({
    super.key,
    this.size = SpinnerSize.medium,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final spinnerColor = color ?? const Color(SwiftleadTokens.primaryTeal);
    final spinnerSize = _getSize(size);

    return SizedBox(
      width: spinnerSize,
      height: spinnerSize,
      child: CircularProgressIndicator(
        strokeWidth: _getStrokeWidth(size),
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
      ),
    );
  }

  double _getSize(SpinnerSize size) {
    switch (size) {
      case SpinnerSize.small:
        return 16;
      case SpinnerSize.medium:
        return 24;
      case SpinnerSize.large:
        return 32;
    }
  }

  double _getStrokeWidth(SpinnerSize size) {
    switch (size) {
      case SpinnerSize.small:
        return 2;
      case SpinnerSize.medium:
        return 3;
      case SpinnerSize.large:
        return 4;
    }
  }
}

enum SpinnerSize { small, medium, large }

