import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../theme/tokens.dart';

/// AIPerformanceScreen - AI performance metrics and analytics
/// Exact specification from UI_Inventory_v2.5.1
class AIPerformanceScreen extends StatefulWidget {
  const AIPerformanceScreen({super.key});

  @override
  State<AIPerformanceScreen> createState() => _AIPerformanceScreenState();
}

class _AIPerformanceScreenState extends State<AIPerformanceScreen> {
  String _selectedPeriod = '7D';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'AI Performance',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Period Selector
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              children: ['7D', '30D', '90D', '1Y'].map((period) {
                final isSelected = _selectedPeriod == period;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(period),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                      selectedColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
                      checkmarkColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Response Rate Chart
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Response Rate',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Semantics(
                  label: 'AI Response Rate chart. Tap on data points to see details.',
                  child: TrendLineChart(
                    title: '',
                  dataPoints: [
                    ChartDataPoint(label: 'Mon', value: 85),
                    ChartDataPoint(label: 'Tue', value: 92),
                    ChartDataPoint(label: 'Wed', value: 88),
                    ChartDataPoint(label: 'Thu', value: 95),
                    ChartDataPoint(label: 'Fri', value: 90),
                  ],
                  periodData: {},
                  onDataPointTap: (point) {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Key Metrics
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Metrics',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _MetricRow(
                  label: 'Total Conversations',
                  value: '1,234',
                  icon: Icons.chat,
                ),
                const Divider(),
                _MetricRow(
                  label: 'AI Response Rate',
                  value: '92%',
                  icon: Icons.auto_awesome,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Average Response Time',
                  value: '2.3s',
                  icon: Icons.timer,
                ),
                const Divider(),
                _MetricRow(
                  label: 'Customer Satisfaction',
                  value: '4.8/5',
                  icon: Icons.star,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Sentiment Analysis
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sentiment Distribution',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _SentimentBar(
                  label: 'Positive',
                  value: 0.75,
                  color: const Color(SwiftleadTokens.successGreen),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _SentimentBar(
                  label: 'Neutral',
                  value: 0.20,
                  color: const Color(SwiftleadTokens.infoBlue),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _SentimentBar(
                  label: 'Negative',
                  value: 0.05,
                  color: const Color(SwiftleadTokens.errorRed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(SwiftleadTokens.primaryTeal)),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _SentimentBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${(value * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.06)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: value,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

