import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// SubscriptionBillingScreen - Manage subscription and billing
/// Exact specification from UI_Inventory_v2.5.1
class SubscriptionBillingScreen extends StatefulWidget {
  const SubscriptionBillingScreen({super.key});

  @override
  State<SubscriptionBillingScreen> createState() => _SubscriptionBillingScreenState();
}

class _SubscriptionBillingScreenState extends State<SubscriptionBillingScreen> {
  String _currentPlan = 'Professional';
  double _monthlyPrice = 29.99;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 15));
  bool _autoRenew = true;

  final List<_BillingHistory> _billingHistory = [
    _BillingHistory(
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 29.99,
      status: 'Paid',
      invoiceNumber: 'INV-001',
    ),
    _BillingHistory(
      date: DateTime.now().subtract(const Duration(days: 60)),
      amount: 29.99,
      status: 'Paid',
      invoiceNumber: 'INV-002',
    ),
    _BillingHistory(
      date: DateTime.now().subtract(const Duration(days: 90)),
      amount: 29.99,
      status: 'Paid',
      invoiceNumber: 'INV-003',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Subscription & Billing',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Current Plan
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _currentPlan,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '£${_monthlyPrice.toStringAsFixed(2)}/month',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Next billing: ${_formatDate(_nextBillingDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Auto-renew',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _autoRenew,
                      onChanged: (value) {
                        setState(() {
                          _autoRenew = value;
                        });
                        Toast.show(
                          context,
                          message: value
                              ? 'Auto-renew enabled'
                              : 'Auto-renew disabled',
                          type: ToastType.info,
                        );
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Plan Features
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan Features',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _FeatureItem(
                  icon: Icons.check_circle,
                  feature: 'Unlimited jobs',
                ),
                _FeatureItem(
                  icon: Icons.check_circle,
                  feature: 'Unlimited contacts',
                ),
                _FeatureItem(
                  icon: Icons.check_circle,
                  feature: 'AI-powered messaging',
                ),
                _FeatureItem(
                  icon: Icons.check_circle,
                  feature: 'Advanced reporting',
                ),
                _FeatureItem(
                  icon: Icons.check_circle,
                  feature: 'Priority support',
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Billing History
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ..._billingHistory.map((bill) => Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(bill.date),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                bill.invoiceNumber,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '£${bill.amount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                bill.status,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(SwiftleadTokens.successGreen),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Change Plan Button
          PrimaryButton(
            label: 'Change Plan',
            onPressed: () {
              // TODO: Show plan selection
              Toast.show(
                context,
                message: 'Plan selection coming soon',
                type: ToastType.info,
              );
            },
            icon: Icons.upgrade,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Cancel Subscription
          OutlinedButton(
            onPressed: () async {
              final confirmed = await SwiftleadConfirmationDialog.show(
                context: context,
                title: 'Cancel Subscription',
                description:
                    'Are you sure you want to cancel your subscription? You\'ll lose access to premium features at the end of your billing period.',
                primaryActionLabel: 'Cancel Subscription',
                secondaryActionLabel: 'Keep Subscription',
                isDestructive: true,
              );
              if (confirmed == true) {
                Toast.show(
                  context,
                  message: 'Subscription will be cancelled at end of billing period',
                  type: ToastType.info,
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(SwiftleadTokens.errorRed),
            ),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String feature;

  const _FeatureItem({
    required this.icon,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(SwiftleadTokens.successGreen),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Text(
            feature,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BillingHistory {
  final DateTime date;
  final double amount;
  final String status;
  final String invoiceNumber;

  _BillingHistory({
    required this.date,
    required this.amount,
    required this.status,
    required this.invoiceNumber,
  });
}

