import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';
import '../global/primary_button.dart';

/// SubscriptionCard - Card showing plan details, usage, renewal date, upgrade options
/// Exact specification from UI_Inventory_v2.5.1
class SubscriptionCard extends StatelessWidget {
  final String planName;
  final double monthlyPrice;
  final DateTime? renewalDate;
  final Map<String, dynamic>? usage;
  final List<String> features;
  final VoidCallback? onUpgrade;
  final VoidCallback? onManage;

  const SubscriptionCard({
    super.key,
    required this.planName,
    required this.monthlyPrice,
    this.renewalDate,
    this.usage,
    required this.features,
    this.onUpgrade,
    this.onManage,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '£${monthlyPrice.toStringAsFixed(2)}/month',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SwiftleadBadge(
                label: 'Active',
                variant: BadgeVariant.success,
                size: BadgeSize.medium,
              ),
            ],
          ),
          
          if (features.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'Features',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(SwiftleadTokens.successGreen),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Text(
                    feature,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )),
          ],
          
          if (usage != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'Usage',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            ...usage!.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
          ],
          
          if (renewalDate != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Renews on',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${renewalDate!.day}/${renewalDate!.month}/${renewalDate!.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          const Divider(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onManage,
                  child: const Text('Manage'),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: PrimaryButton(
                  label: 'Upgrade',
                  onPressed: onUpgrade,
                  icon: Icons.arrow_upward,
                  size: ButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

