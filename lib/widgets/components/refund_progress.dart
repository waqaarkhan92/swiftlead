import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// RefundProgress - Shows refund processing status
/// Exact specification from UI_Inventory_v2.5.1
class RefundProgress extends StatelessWidget {
  final RefundStatus status;
  final double progress; // 0.0 to 1.0
  final String? message;

  const RefundProgress({
    super.key,
    required this.status,
    this.progress = 0.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    String displayMessage;
    Color progressColor;
    IconData statusIcon;

    switch (status) {
      case RefundStatus.processing:
        displayMessage = message ?? 'Processing refund...';
        progressColor = const Color(SwiftleadTokens.warningOrange);
        statusIcon = Icons.refresh;
        break;
      case RefundStatus.completed:
        displayMessage = message ?? 'Refund completed successfully';
        progressColor = const Color(SwiftleadTokens.successGreen);
        statusIcon = Icons.check_circle;
        break;
      case RefundStatus.failed:
        displayMessage = message ?? 'Refund failed';
        progressColor = const Color(SwiftleadTokens.errorRed);
        statusIcon = Icons.error;
        break;
      case RefundStatus.pending:
        displayMessage = message ?? 'Refund pending';
        progressColor = Colors.grey;
        statusIcon = Icons.pending;
        break;
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: progressColor, size: 20),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  'Refund Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              SwiftleadBadge(
                label: status.displayName,
                variant: _getBadgeVariant(status),
                size: BadgeSize.small,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            displayMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: progressColor,
                ),
          ),
          if (status == RefundStatus.processing && progress > 0) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  BadgeVariant _getBadgeVariant(RefundStatus status) {
    switch (status) {
      case RefundStatus.completed:
        return BadgeVariant.success;
      case RefundStatus.failed:
        return BadgeVariant.error;
      case RefundStatus.processing:
        return BadgeVariant.warning;
      case RefundStatus.pending:
        return BadgeVariant.secondary;
    }
  }
}

/// Refund status enum
enum RefundStatus {
  pending,
  processing,
  completed,
  failed,
}

extension RefundStatusExtension on RefundStatus {
  String get displayName {
    switch (this) {
      case RefundStatus.pending:
        return 'Pending';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.completed:
        return 'Completed';
      case RefundStatus.failed:
        return 'Failed';
    }
  }
}

/// Helper class for BadgeVariant and SwiftleadBadge
class SwiftleadBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final BadgeSize size;

  const SwiftleadBadge({
    super.key,
    required this.label,
    required this.variant,
    this.size = BadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (variant) {
      case BadgeVariant.primary:
        backgroundColor = const Color(SwiftleadTokens.primaryTeal);
        textColor = Colors.white;
        break;
      case BadgeVariant.success:
        backgroundColor = const Color(SwiftleadTokens.successGreen);
        textColor = Colors.white;
        break;
      case BadgeVariant.warning:
        backgroundColor = const Color(SwiftleadTokens.warningOrange);
        textColor = Colors.white;
        break;
      case BadgeVariant.error:
        backgroundColor = const Color(SwiftleadTokens.errorRed);
        textColor = Colors.white;
        break;
      case BadgeVariant.secondary:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        break;
    }

    final fontSize = size == BadgeSize.small ? 10.0 : 12.0;
    final padding = size == BadgeSize.small ? 4.0 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum BadgeVariant {
  primary,
  success,
  warning,
  error,
  secondary,
}

enum BadgeSize {
  small,
  medium,
  large,
}

