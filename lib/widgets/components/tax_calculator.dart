import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/tooltip.dart';

/// TaxCalculator - Live tax calculation display with breakdown tooltip
/// Exact specification from UI_Inventory_v2.5.1
class TaxCalculator extends StatelessWidget {
  final double subtotal;
  final double taxRate; // percentage
  final double taxAmount;
  final double total;
  final String? taxName;
  final bool showTooltip;

  const TaxCalculator({
    super.key,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.total,
    this.taxName,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = taxName ?? 'Tax';
    
    Widget taxRow = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '$displayName (${taxRate.toStringAsFixed(0)}%)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (showTooltip) ...[
                  const SizedBox(width: 4),
                  SwiftleadTooltip(
                    message: 'Tax calculated on subtotal of £${subtotal.toStringAsFixed(2)}',
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Color(SwiftleadTokens.textSecondaryLight),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              '£${taxAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '£${subtotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        taxRow,
        const Divider(),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
      ],
    );
  }
}

