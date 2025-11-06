import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import 'trend_line_chart.dart';

/// MetricDetailSheet - Detailed breakdown when tapping a metric
class MetricDetailSheet extends StatelessWidget {
  final String title;
  final String currentValue;
  final String? previousValue;
  final double? trendPercentage;
  final List<double> chartData;
  final String? chartLabel;
  final Map<String, dynamic>? breakdown;
  final String? period;

  const MetricDetailSheet({
    super.key,
    required this.title,
    required this.currentValue,
    this.previousValue,
    this.trendPercentage,
    required this.chartData,
    this.chartLabel,
    this.breakdown,
    this.period,
  });

  static void show({
    required BuildContext context,
    required String title,
    required String currentValue,
    String? previousValue,
    double? trendPercentage,
    required List<double> chartData,
    String? chartLabel,
    Map<String, dynamic>? breakdown,
    String? period,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MetricDetailSheet(
        title: title,
        currentValue: currentValue,
        previousValue: previousValue,
        trendPercentage: trendPercentage,
        chartData: chartData,
        chartLabel: chartLabel,
        breakdown: breakdown,
        period: period,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return FrostedContainer(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SwiftleadTokens.radiusModal),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: SwiftleadTokens.spaceS),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceL,
                  ),
                  children: [
                    // Current Value Card
                    _buildValueCard(context),
                    const SizedBox(height: SwiftleadTokens.spaceL),
                    
                    // Chart
                    _buildChartCard(context),
                    const SizedBox(height: SwiftleadTokens.spaceL),
                    
                    // Comparison
                    if (previousValue != null) ...[
                      _buildComparisonCard(context),
                      const SizedBox(height: SwiftleadTokens.spaceL),
                    ],
                    
                    // Breakdown
                    if (breakdown != null) ...[
                      _buildBreakdownCard(context),
                      const SizedBox(height: SwiftleadTokens.spaceL),
                    ],
                    
                    // Actions
                    _buildActionsCard(context),
                    const SizedBox(height: SwiftleadTokens.spaceXL),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValueCard(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            currentValue,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          if (trendPercentage != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Icon(
                  trendPercentage! >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: trendPercentage! >= 0
                      ? const Color(SwiftleadTokens.successGreen)
                      : const Color(SwiftleadTokens.errorRed),
                ),
                const SizedBox(width: 4),
                Text(
                  '${trendPercentage! >= 0 ? '+' : ''}${trendPercentage!.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: trendPercentage! >= 0
                        ? const Color(SwiftleadTokens.successGreen)
                        : const Color(SwiftleadTokens.errorRed),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (period != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    period!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend ${period ?? 'Over Time'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          SizedBox(
            height: 200,
            child: TrendLineChart(
              title: '',
              dataPoints: chartData.asMap().entries.map((entry) {
                return ChartDataPoint(
                  label: '${entry.key + 1}',
                  value: entry.value,
                );
              }).toList(),
              lineColor: const Color(SwiftleadTokens.primaryTeal),
              yAxisLabel: chartLabel ?? 'Value',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparison',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentValue,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    previousValue!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ...breakdown!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Export functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export functionality coming soon')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Share functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}

