import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart';

/// PaymentStatusBadge - Color-coded badge (paid/pending/overdue/refunded) with icon
/// Exact specification from UI_Inventory_v2.5.1
class PaymentStatusBadge extends StatelessWidget {
  final String status; // 'paid', 'pending', 'overdue', 'refunded'
  final bool showIcon;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  BadgeVariant _getBadgeVariant(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return BadgeVariant.success;
      case 'pending':
        return BadgeVariant.warning;
      case 'overdue':
        return BadgeVariant.error;
      case 'refunded':
        return BadgeVariant.secondary;
      default:
        return BadgeVariant.secondary;
    }
  }

  IconData? _getStatusIcon(String status) {
    if (!showIcon) return null;
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'overdue':
        return Icons.warning;
      case 'refunded':
        return Icons.refresh;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwiftleadBadge(
      label: status.toUpperCase(),
      variant: _getBadgeVariant(status),
      icon: _getStatusIcon(status),
      size: BadgeSize.medium,
    );
  }
}

