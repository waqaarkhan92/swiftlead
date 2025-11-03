import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import '../../widgets/components/trend_line_chart.dart';

/// Campaign Analytics Screen - Link heatmap, conversion funnel, activity log
/// Exact specification from UI_Inventory_v2.5.1
class CampaignAnalyticsScreen extends StatefulWidget {
  final String campaignId;

  const CampaignAnalyticsScreen({
    super.key,
    required this.campaignId,
  });

  @override
  State<CampaignAnalyticsScreen> createState() => _CampaignAnalyticsScreenState();
}

class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Campaign Analytics',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton('Overview', 0),
                ),
                Expanded(
                  child: _buildTabButton('Links', 1),
                ),
                Expanded(
                  child: _buildTabButton('Funnel', 2),
                ),
                Expanded(
                  child: _buildTabButton('Activity', 3),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? const Color(SwiftleadTokens.primaryTeal)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(SwiftleadTokens.primaryTeal)
                    : null,
              ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildLinksTab();
      case 2:
        return _buildFunnelTab();
      case 3:
        return _buildActivityTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Key Metrics
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Sent',
                '1,250',
                Icons.send,
                Colors.blue,
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: _buildMetricCard(
                'Opened',
                '892',
                Icons.mark_email_read,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Clicked',
                '234',
                Icons.link,
                Colors.orange,
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: _buildMetricCard(
                'Converted',
                '45',
                Icons.check_circle,
                const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Open Rate Chart
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Open Rate Over Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              SizedBox(
                height: 200,
                child: TrendLineChart(
                  title: '',
                  dataPoints: [
                    ChartDataPoint(label: 'Day 1', value: 65),
                    ChartDataPoint(label: 'Day 2', value: 72),
                    ChartDataPoint(label: 'Day 3', value: 68),
                    ChartDataPoint(label: 'Day 4', value: 75),
                    ChartDataPoint(label: 'Day 5', value: 71),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Link Performance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ...List.generate(5, (index) => Padding(
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
                        'https://example.com/link${index + 1}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SwiftleadTokens.spaceS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getHeatColor(100 - index * 15).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${100 - index * 15} clicks',
                        style: TextStyle(
                          color: _getHeatColor(100 - index * 15),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                LinearProgressIndicator(
                  value: (100 - index * 15) / 100,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getHeatColor(100 - index * 15),
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Color _getHeatColor(int clicks) {
    if (clicks >= 80) return Colors.red;
    if (clicks >= 60) return Colors.orange;
    if (clicks >= 40) return Colors.yellow.shade700;
    return Colors.green;
  }

  Widget _buildFunnelTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Conversion Funnel',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _buildFunnelStep('Sent', 1250, 100),
        _buildFunnelStep('Opened', 892, 71.4),
        _buildFunnelStep('Clicked', 234, 18.7),
        _buildFunnelStep('Converted', 45, 3.6),
      ],
    );
  }

  Widget _buildFunnelStep(String label, int count, double percentage) {
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
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$count (${percentage.toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Activity Log',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ...List.generate(10, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email, size: 20, color: Colors.blue),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0
                            ? 'Campaign sent to 1,250 recipients'
                            : 'Email opened by John Smith',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${index + 1} hours ago',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
