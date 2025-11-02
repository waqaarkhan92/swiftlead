import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// BalanceCard - Large card showing current balance, pending, and received amounts
/// Exact specification from UI_Inventory_v2.5.1
class BalanceCard extends StatelessWidget {
  final double balance;
  final double? pending;
  final double? received;
  final String? currency;

  const BalanceCard({
    super.key,
    required this.balance,
    this.pending,
    this.received,
    this.currency = '£',
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            '$currency${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          if (pending != null || received != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                if (pending != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '$currency${pending!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (pending != null && received != null)
                  const SizedBox(width: SwiftleadTokens.spaceM),
                if (received != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Received',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '$currency${received!.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(SwiftleadTokens.successGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

