import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/info_banner.dart';
import '../../theme/tokens.dart';
import 'package:fl_chart/fl_chart.dart';

/// Capacity Optimization Screen - Visualize utilization and suggest improvements
/// v2.5.1 Enhancement: Analytics for schedule optimization
class CapacityOptimizationScreen extends StatefulWidget {
  const CapacityOptimizationScreen({super.key});

  @override
  State<CapacityOptimizationScreen> createState() => _CapacityOptimizationScreenState();
}

class _CapacityOptimizationScreenState extends State<CapacityOptimizationScreen> {
  String _selectedPeriod = 'week'; // week, month

  // Mock utilization data
  final Map<String, double> _dailyUtilization = {
    'Monday': 85.0,
    'Tuesday': 92.0,
    'Wednesday': 78.0,
    'Thursday': 95.0,
    'Friday': 88.0,
    'Saturday': 45.0,
    'Sunday': 20.0,
  };

  final List<UtilizationSuggestion> _suggestions = [
    UtilizationSuggestion(
      title: 'Move Tuesday bookings to Wednesday',
      description: 'Wednesday is 14% underutilized. Consider promoting Wednesday slots.',
      impact: 'High',
      priority: 'High',
    ),
    UtilizationSuggestion(
      title: 'Promote weekend bookings',
      description: 'Saturday and Sunday are significantly underutilized. Offer weekend discounts.',
      impact: 'Medium',
      priority: 'Medium',
    ),
    UtilizationSuggestion(
      title: 'Optimize Thursday schedule',
      description: 'Thursday is at 95% capacity. Consider adding more time slots.',
      impact: 'High',
      priority: 'High',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Capacity Optimization',
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'week', child: Text('This Week')),
              const PopupMenuItem(value: 'month', child: Text('This Month')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Overall Utilization
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Utilization',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '72%',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(SwiftleadTokens.primaryTeal),
                            ),
                          ),
                          Text(
                            'Average utilization',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    CircularProgressIndicator(
                      value: 0.72,
                      strokeWidth: 8,
                      backgroundColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(SwiftleadTokens.primaryTeal)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Daily Utilization Chart
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Utilization',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = _dailyUtilization.keys.toList();
                              if (value.toInt() >= 0 && value.toInt() < days.length) {
                                return Text(
                                  days[value.toInt()].substring(0, 3),
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(SwiftleadTokens.textSecondaryLight).withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: _dailyUtilization.entries.map((entry) {
                        final index = _dailyUtilization.keys.toList().indexOf(entry.key);
                        final isOver = entry.value > 90;
                        final isUnder = entry.value < 50;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: isOver
                                  ? const Color(SwiftleadTokens.errorRed)
                                  : isUnder
                                      ? const Color(SwiftleadTokens.warningYellow)
                                      : const Color(SwiftleadTokens.successGreen),
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Optimization Suggestions
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Optimization Suggestions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InfoBanner(
                      message: 'Based on utilization patterns',
                      type: InfoBannerType.info,
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ..._suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                    child: FrostedContainer(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  suggestion.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SwiftleadTokens.spaceS,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: suggestion.priority == 'High'
                                      ? const Color(SwiftleadTokens.errorRed).withOpacity(0.1)
                                      : const Color(SwiftleadTokens.warningYellow).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  suggestion.priority,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: suggestion.priority == 'High'
                                        ? const Color(SwiftleadTokens.errorRed)
                                        : const Color(SwiftleadTokens.warningYellow),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceS),
                          Text(
                            suggestion.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceS),
                          Text(
                            'Impact: ${suggestion.impact}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(SwiftleadTokens.primaryTeal),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UtilizationSuggestion {
  final String title;
  final String description;
  final String impact;
  final String priority;

  UtilizationSuggestion({
    required this.title,
    required this.description,
    required this.impact,
    required this.priority,
  });
}

