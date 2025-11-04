import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import 'package:fl_chart/fl_chart.dart';

/// Booking Analytics Screen - Track booking sources, conversion rates, peak times
/// v2.5.1 Enhancement: Analytics dashboard
class BookingAnalyticsScreen extends StatefulWidget {
  const BookingAnalyticsScreen({super.key});

  @override
  State<BookingAnalyticsScreen> createState() => _BookingAnalyticsScreenState();
}

class _BookingAnalyticsScreenState extends State<BookingAnalyticsScreen> {
  String _selectedPeriod = 'week'; // week, month, quarter, year

  // Mock analytics data
  final Map<String, int> _bookingSources = {
    'Google Ads': 45,
    'Facebook Ads': 32,
    'Website': 28,
    'Referral': 15,
    'Direct': 10,
  };

  final Map<String, double> _conversionRates = {
    'Google Ads': 12.5,
    'Facebook Ads': 8.3,
    'Website': 15.2,
    'Referral': 25.0,
    'Direct': 18.5,
  };

  final Map<String, int> _peakTimes = {
    '9:00': 15,
    '10:00': 28,
    '11:00': 32,
    '12:00': 25,
    '13:00': 18,
    '14:00': 35,
    '15:00': 42,
    '16:00': 38,
    '17:00': 22,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Booking Analytics',
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
              const PopupMenuItem(value: 'quarter', child: Text('This Quarter')),
              const PopupMenuItem(value: 'year', child: Text('This Year')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Bookings',
                  '130',
                  Icons.event,
                  const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: _buildSummaryCard(
                  'Conversion Rate',
                  '15.2%',
                  Icons.trending_up,
                  const Color(SwiftleadTokens.successGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Peak Time',
                  '3:00 PM',
                  Icons.access_time,
                  const Color(SwiftleadTokens.warningYellow),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: _buildSummaryCard(
                  'Avg. Value',
                  '£125',
                  Icons.attach_money,
                  const Color(SwiftleadTokens.successGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Booking Sources Chart
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Sources',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _bookingSources.entries.map((entry) {
                        final colors = [
                          const Color(SwiftleadTokens.primaryTeal),
                          const Color(SwiftleadTokens.successGreen),
                          const Color(SwiftleadTokens.warningYellow),
                          const Color(0xFF6366F1),
                          const Color(0xFF8B5CF6),
                        ];
                        final index = _bookingSources.keys.toList().indexOf(entry.key);
                        return PieChartSectionData(
                          value: entry.value.toDouble(),
                          title: '${entry.key}\n${entry.value}',
                          color: colors[index % colors.length],
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Conversion Rates
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conversion Rates by Source',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ..._conversionRates.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text(
                              '${entry.value.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(SwiftleadTokens.primaryTeal),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(SwiftleadTokens.primaryTeal)),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Peak Times Chart
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peak Booking Times',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 50,
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final times = _peakTimes.keys.toList();
                              if (value.toInt() >= 0 && value.toInt() < times.length) {
                                return Text(
                                  times[value.toInt()],
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
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _peakTimes.entries.map((entry) {
                        final index = _peakTimes.keys.toList().indexOf(entry.key);
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: const Color(SwiftleadTokens.primaryTeal),
                              width: 16,
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
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

