import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ResponseTimeData - Data point for response times
class ResponseTimeData {
  final String channel;
  final double averageMinutes;
  final Color color;

  const ResponseTimeData({
    required this.channel,
    required this.averageMinutes,
    required this.color,
  });
}

/// ResponseTimesChart - Line chart showing average response times by channel
/// Exact specification from Screen_Layouts_v2.5.1
class ResponseTimesChart extends StatelessWidget {
  final String title;
  final List<ResponseTimeData> channels;
  final Function(int index)? onChannelTap;

  const ResponseTimesChart({
    super.key,
    required this.title,
    required this.channels,
    this.onChannelTap,
  });

  @override
  Widget build(BuildContext context) {
    if (channels.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxValue = channels
        .map((c) => c.averageMinutes)
        .reduce((a, b) => a > b ? a : b);

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Theme.of(context).cardColor,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < channels.length) {
                          final channel = channels[index];
                          return LineTooltipItem(
                            '${channel.channel}\n${channel.averageMinutes.toStringAsFixed(1)} min',
                            TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                  touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (!event.isInterestedForInteractions ||
                        touchResponse == null ||
                        touchResponse.lineBarSpots == null ||
                        touchResponse.lineBarSpots!.isEmpty) {
                      return;
                    }
                    final spot = touchResponse.lineBarSpots!.first;
                    final index = spot.x.toInt();
                    onChannelTap?.call(index);
                  },
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < channels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              channels[index].channel,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}m',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (channels.length - 1).toDouble(),
                minY: 0,
                maxY: maxValue * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: channels.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.averageMinutes);
                    }).toList(),
                    isCurved: true,
                    color: const Color(SwiftleadTokens.primaryTeal),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: const Color(SwiftleadTokens.primaryTeal),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(SwiftleadTokens.primaryTeal)
                          .withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Summary
          Text(
            'Average: ${(channels.map((c) => c.averageMinutes).reduce((a, b) => a + b) / channels.length).toStringAsFixed(1)} min',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ),
    );
  }
}

