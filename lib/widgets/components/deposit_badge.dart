import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart';

/// DepositBadge - Shows deposit status (required/paid/pending) with amount
/// Exact specification from UI_Inventory_v2.5.1
class DepositBadge extends StatelessWidget {
  final DepositStatus status;
  final double? amount;

  const DepositBadge({
    super.key,
    required this.status,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    BadgeVariant variant;
    IconData icon;

    switch (status) {
      case DepositStatus.required:
        label = amount != null ? 'Deposit Required (£${amount!.toStringAsFixed(2)})' : 'Deposit Required';
        variant = BadgeVariant.warning;
        icon = Icons.payment;
        break;
      case DepositStatus.paid:
        label = amount != null ? 'Deposit Paid (£${amount!.toStringAsFixed(2)})' : 'Deposit Paid';
        variant = BadgeVariant.success;
        icon = Icons.check_circle;
        break;
      case DepositStatus.pending:
        label = amount != null ? 'Deposit Pending (£${amount!.toStringAsFixed(2)})' : 'Deposit Pending';
        variant = BadgeVariant.warning;
        icon = Icons.pending;
        break;
    }

    return SwiftleadBadge(
      label: label,
      variant: variant,
      icon: icon,
      size: BadgeSize.small,
    );
  }
}

enum DepositStatus {
  required,
  paid,
  pending,
}

