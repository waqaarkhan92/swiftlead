import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// AI Insight Type
enum InsightType {
  anomaly,
  trend,
  opportunity,
  recommendation,
}

/// AI Insight Card - Shows AI-generated insight with confidence level
/// Exact specification from UI_Inventory_v2.5.1 line 360
class AIInsightCard extends StatelessWidget {
  final String title;
  final String description;
  final InsightType type;
  final double confidence; // 0.0 to 1.0
  final List<String>? actionSuggestions;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AIInsightCard({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    this.confidence = 0.8,
    this.actionSuggestions,
    this.onTap,
    this.onDismiss,
  });

  Color _getTypeColor() {
    switch (type) {
      case InsightType.anomaly:
        return const Color(SwiftleadTokens.errorRed);
      case InsightType.trend:
        return const Color(SwiftleadTokens.primaryTeal);
      case InsightType.opportunity:
        return const Color(SwiftleadTokens.successGreen);
      case InsightType.recommendation:
        return const Color(SwiftleadTokens.warningYellow);
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case InsightType.anomaly:
        return Icons.warning_rounded;
      case InsightType.trend:
        return Icons.trending_up;
      case InsightType.opportunity:
        return Icons.lightbulb_outline;
      case InsightType.recommendation:
        return Icons.recommend;
    }
  }

  String _getTypeLabel() {
    switch (type) {
      case InsightType.anomaly:
        return 'Anomaly';
      case InsightType.trend:
        return 'Trend';
      case InsightType.opportunity:
        return 'Opportunity';
      case InsightType.recommendation:
        return 'Recommendation';
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
    final confidencePercent = (confidence * 100).toInt();

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: typeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getTypeLabel(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        SwiftleadBadge(
                          label: '$confidencePercent% confident',
                          size: BadgeSize.small,
                          variant: BadgeVariant.info,
                        ),
                      ],
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (actionSuggestions != null && actionSuggestions!.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'Suggested Actions:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            ...actionSuggestions!.map((action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceXS),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_right,
                      size: 14,
                      color: typeColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        action,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (onTap != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            TextButton(
              onPressed: onTap,
              child: Text('View Details'),
              style: TextButton.styleFrom(
                foregroundColor: typeColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

