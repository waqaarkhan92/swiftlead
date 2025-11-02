import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// PaymentTile - Transaction row with client, amount, status, date + tap to expand
/// Exact specification from UI_Inventory_v2.5.1
class PaymentTile extends StatelessWidget {
  final String paymentId;
  final String clientName;
  final double amount;
  final String status; // 'paid', 'pending', 'overdue', 'refunded'
  final DateTime date;
  final String? paymentMethod;
  final String? linkedJobId;
  final VoidCallback? onTap;
  final Function()? onRefund;
  final Function()? onResendLink;
  final Function()? onViewInvoice;

  const PaymentTile({
    super.key,
    required this.paymentId,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.date,
    this.paymentMethod,
    this.linkedJobId,
    this.onTap,
    this.onRefund,
    this.onResendLink,
    this.onViewInvoice,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(SwiftleadTokens.successGreen);
      case 'pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'overdue':
        return const Color(SwiftleadTokens.errorRed);
      case 'refunded':
        return const Color(SwiftleadTokens.textSecondaryLight);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'stripe':
        return Icons.credit_card;
      case 'cash':
        return Icons.money;
      case 'bank transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          children: [
            // Client Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  clientName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(SwiftleadTokens.primaryTeal),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Client Info & Amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (paymentMethod != null) ...[
                        Icon(
                          _getPaymentMethodIcon(paymentMethod!),
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          paymentMethod!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _formatDate(date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Amount & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '£${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

