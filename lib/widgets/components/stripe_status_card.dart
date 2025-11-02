import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';
import '../global/primary_button.dart';

/// StripeStatusCard - Card showing Stripe account status, balance, recent activity
/// Exact specification from UI_Inventory_v2.5.1
class StripeStatusCard extends StatelessWidget {
  final bool isConnected;
  final double? balance;
  final String? accountEmail;
  final int? recentTransactionsCount;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onViewDashboard;

  const StripeStatusCard({
    super.key,
    this.isConnected = false,
    this.balance,
    this.accountEmail,
    this.recentTransactionsCount,
    this.onConnect,
    this.onDisconnect,
    this.onViewDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.05)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.payment,
                      size: 20,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stripe Account',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (accountEmail != null)
                        Text(
                          accountEmail!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ],
              ),
              SwiftleadBadge(
                label: isConnected ? 'Connected' : 'Not Connected',
                variant: isConnected ? BadgeVariant.success : BadgeVariant.secondary,
                size: BadgeSize.medium,
              ),
            ],
          ),
          
          if (isConnected && balance != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '£${balance!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(SwiftleadTokens.successGreen),
                      ),
                    ),
                  ],
                ),
                if (recentTransactionsCount != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '$recentTransactionsCount',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Actions
          if (isConnected)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDisconnect,
                    child: const Text('Disconnect'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: PrimaryButton(
                    label: 'Dashboard',
                    onPressed: onViewDashboard,
                    icon: Icons.open_in_new,
                    size: ButtonSize.small,
                  ),
                ),
              ],
            )
          else
            PrimaryButton(
              label: 'Connect Stripe',
              onPressed: onConnect,
              icon: Icons.link,
              size: ButtonSize.small,
            ),
        ],
      ),
    );
  }
}

