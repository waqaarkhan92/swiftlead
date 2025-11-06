import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../theme/tokens.dart';

/// Benchmark Comparison Screen - Compare metrics against industry benchmarks
/// Exact specification from UI_Inventory_v2.5.1, line 349
class BenchmarkComparisonScreen extends StatefulWidget {
  const BenchmarkComparisonScreen({super.key});

  @override
  State<BenchmarkComparisonScreen> createState() => _BenchmarkComparisonScreenState();
}

class _BenchmarkComparisonScreenState extends State<BenchmarkComparisonScreen> {
  String _selectedMetric = 'Revenue';
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Benchmark Comparison',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Metric Selector
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Metric',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  children: ['Revenue', 'Response Time', 'Completion Rate', 'Customer Satisfaction']
                      .map((metric) => ChoiceChip(
                            label: Text(metric),
                            selected: _selectedMetric == metric,
                            onSelected: (selected) {
                              setState(() => _selectedMetric = metric);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Comparison Chart
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Performance vs Industry Average',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                SizedBox(
                  height: 300,
                  child: Semantics(
                    label: 'Performance vs Benchmark chart. Tap on data points to see details.',
                    child: TrendLineChart(
                      title: 'Performance vs Benchmark',
                    dataPoints: [
                      ChartDataPoint(label: 'Week 1', value: 8500),
                      ChartDataPoint(label: 'Week 2', value: 9200),
                      ChartDataPoint(label: 'Week 3', value: 8800),
                      ChartDataPoint(label: 'Week 4', value: 9500),
                    ],
                    lineColor: const Color(SwiftleadTokens.primaryTeal),
                    onDataPointTap: (point) {},
                    ),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                // Benchmark line indicator
                Container(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        'Industry Average: £8,000',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Metrics Cards
          _buildMetricsCards(),
        ],
      ),
    );
  }

  Widget _buildMetricsCards() {
    return Column(
      children: [
        _buildMetricCard(
          'Your Average',
          '£9,000',
          '+12.5%',
          true,
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _buildMetricCard(
          'Industry Average',
          '£8,000',
          'Baseline',
          false,
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _buildMetricCard(
          'Top 10%',
          '£12,000',
          'Target',
          false,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, String change, bool isHighlighted) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SwiftleadTokens.spaceXS),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isHighlighted
                          ? const Color(SwiftleadTokens.primaryTeal)
                          : null,
                    ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SwiftleadTokens.spaceS,
              vertical: SwiftleadTokens.spaceXS,
            ),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? const Color(SwiftleadTokens.successGreen).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isHighlighted
                        ? const Color(SwiftleadTokens.successGreen)
                        : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

