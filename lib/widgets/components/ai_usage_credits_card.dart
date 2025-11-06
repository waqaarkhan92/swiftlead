import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';

/// AIUsageCreditsCard - Display AI usage and credits information
/// Feature from Decision Matrix Module 3.11
class AIUsageCreditsCard extends StatelessWidget {
  final int monthlyAllocation;
  final int creditsUsed;
  final Map<String, int> usageBreakdown;
  final double costPerInteraction;
  
  const AIUsageCreditsCard({
    super.key,
    this.monthlyAllocation = 1000,
    this.creditsUsed = 245,
    this.usageBreakdown = const {
      'Auto-Reply': 120,
      'Smart Replies': 65,
      'Quote Assistant': 35,
      'Review Reply': 15,
      'Booking Assistance': 10,
    },
    this.costPerInteraction = 0.02,
  });

  @override
  Widget build(BuildContext context) {
    final creditsRemaining = monthlyAllocation - creditsUsed;
    final usagePercentage = creditsUsed / monthlyAllocation;
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Usage & Credits',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to detailed usage/credits screen
                },
                child: const Text('View Details'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Monthly Allocation Overview
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Allocation',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      '$monthlyAllocation credits',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Used This Month',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      '$creditsUsed / $monthlyAllocation',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: usagePercentage > 0.8 
                            ? const Color(SwiftleadTokens.errorRed)
                            : usagePercentage > 0.6
                                ? const Color(SwiftleadTokens.warningYellow)
                                : const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Usage Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(usagePercentage * 100).toStringAsFixed(0)}% used',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$creditsRemaining remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceXS),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: usagePercentage,
                  minHeight: 8,
                  backgroundColor: Colors.black.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    usagePercentage > 0.8 
                        ? const Color(SwiftleadTokens.errorRed)
                        : usagePercentage > 0.6
                            ? const Color(SwiftleadTokens.warningYellow)
                            : const Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Usage Breakdown
          Text(
            'Usage Breakdown',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          ...usageBreakdown.entries.map((entry) {
            final featurePercentage = entry.value / creditsUsed;
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: featurePercentage,
                        minHeight: 6,
                        backgroundColor: Colors.black.withOpacity(0.05),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Text(
                    '${entry.value}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Cost Info
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Text(
                    'Cost per interaction: £${costPerInteraction.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Add Credits Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to add credits screen
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Credits'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: SwiftleadTokens.spaceM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

