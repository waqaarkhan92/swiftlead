import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// TeamPerformanceCard - Team member performance display
/// Exact specification from UI_Inventory_v2.5.1
class TeamPerformanceCard extends StatelessWidget {
  final String memberName;
  final String? avatarUrl;
  final int jobsCompleted;
  final int? rating;
  final double revenue;
  final double? trendPercentage;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  const TeamPerformanceCard({
    super.key,
    required this.memberName,
    this.avatarUrl,
    required this.jobsCompleted,
    this.rating,
    required this.revenue,
    this.trendPercentage,
    this.isPositiveTrend = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Text(
                      memberName.isNotEmpty ? memberName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(SwiftleadTokens.primaryTeal),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Performance info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          memberName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < rating! ? Icons.star : Icons.star_border,
                                size: 14,
                                color: index < rating!
                                    ? const Color(SwiftleadTokens.warningOrange)
                                    : Colors.grey.shade300,
                              );
                            }),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Metrics
                  Row(
                    children: [
                      _MetricChip(
                        icon: Icons.work_outline,
                        label: 'Jobs',
                        value: jobsCompleted.toString(),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      _MetricChip(
                        icon: Icons.account_balance_wallet,
                        label: 'Revenue',
                        value: '£${revenue.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                  
                  // Trend
                  if (trendPercentage != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                          size: 14,
                          color: isPositiveTrend
                              ? const Color(SwiftleadTokens.successGreen)
                              : const Color(SwiftleadTokens.errorRed),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositiveTrend ? '+' : ''}${trendPercentage!.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isPositiveTrend
                                ? const Color(SwiftleadTokens.successGreen)
                                : const Color(SwiftleadTokens.errorRed),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(SwiftleadTokens.primaryTeal)),
          const SizedBox(width: 4),
          Text(
            '$value $label',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
        ],
      ),
    );
  }
}

