import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import 'payment_status_badge.dart';

/// InvoiceCard - Invoice summary with client, items, total, status + quick actions
/// Exact specification from UI_Inventory_v2.5.1
class InvoiceCard extends StatelessWidget {
  final String invoiceId;
  final String invoiceNumber;
  final String clientName;
  final double total;
  final String status;
  final DateTime? dueDate;
  final int? itemCount;
  final VoidCallback? onTap;
  final Function()? onSend;
  final Function()? onView;
  final Function()? onEdit;

  const InvoiceCard({
    super.key,
    required this.invoiceId,
    required this.invoiceNumber,
    required this.clientName,
    required this.total,
    required this.status,
    this.dueDate,
    this.itemCount,
    this.onTap,
    this.onSend,
    this.onView,
    this.onEdit,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoiceNumber,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clientName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PaymentStatusBadge(status: status),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (itemCount != null)
                      Text(
                        '$itemCount item${itemCount! > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (dueDate != null)
                      Text(
                        'Due: ${_formatDate(dueDate!)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                Text(
                  '£${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: onSend,
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text('Send'),
                ),
                TextButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

