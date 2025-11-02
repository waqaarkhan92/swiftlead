import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// LineItemRow - Invoice line item with description, quantity, rate, amount + inline edit
/// Exact specification from UI_Inventory_v2.5.1
class LineItemRow extends StatelessWidget {
  final String description;
  final int? quantity;
  final double? rate;
  final double amount;
  final bool isSubtotal;
  final bool isTotal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LineItemRow({
    super.key,
    required this.description,
    this.quantity,
    this.rate,
    required this.amount,
    this.isSubtotal = false,
    this.isTotal = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: isTotal
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          )
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (onEdit != null && !isSubtotal && !isTotal) ...[
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEdit,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
                if (onDelete != null && !isSubtotal && !isTotal) ...[
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: onDelete,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (quantity != null && rate != null) ...[
            Expanded(
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Text(
                '£${rate!.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          Expanded(
            child: Text(
              '£${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: isTotal
                  ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(SwiftleadTokens.primaryTeal),
                    )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

