import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ChannelPerformanceData - Data point for channel performance
class ChannelPerformanceData {
  final String channel;
  final int messageCount;
  final Color color;

  const ChannelPerformanceData({
    required this.channel,
    required this.messageCount,
    required this.color,
  });
}

/// ChannelPerformanceChart - Bar chart showing messages by channel
/// Exact specification from Screen_Layouts_v2.5.1
class ChannelPerformanceChart extends StatelessWidget {
  final String title;
  final List<ChannelPerformanceData> channels;
  final Function(int index)? onChannelTap;

  const ChannelPerformanceChart({
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

    final maxValue = channels.map((c) => c.messageCount).reduce((a, b) => a > b ? a : b);

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
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Theme.of(context).cardColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final channel = channels[groupIndex];
                      return BarTooltipItem(
                        '${channel.channel}\n${channel.messageCount} messages',
                        TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      return;
                    }
                    final index = barTouchResponse.spot!.touchedBarGroupIndex;
                    onChannelTap?.call(index);
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
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
                borderData: FlBorderData(show: false),
                barGroups: channels.asMap().entries.map((entry) {
                  final index = entry.key;
                  final channel = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: channel.messageCount.toDouble(),
                        color: channel.color,
                        width: 24,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(SwiftleadTokens.radiusCard),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          // Legend
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceXS,
            children: channels.map((channel) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: channel.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${channel.channel} (${channel.messageCount})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

