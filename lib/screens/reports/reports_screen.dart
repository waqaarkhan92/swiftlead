import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/kpi_card.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../widgets/components/conversion_funnel_chart.dart';
import '../../widgets/components/lead_source_pie_chart.dart';
import '../../widgets/components/team_performance_card.dart';
import '../../widgets/components/data_table.dart';
import '../../widgets/components/channel_performance_chart.dart';
import '../../widgets/components/response_times_chart.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart' as main_nav;

/// Reports & Analytics Screen
/// Exact specification from Screen_Layouts_v2.5.1
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  int _selectedReportType = 0;
  final List<String> _reportTypes = ['Overview', 'Revenue', 'Jobs', 'Clients', 'AI Performance', 'Team'];
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Reports & Analytics',
        actions: [
          // Custom Report Builder (v2.5.1)
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: () => _showCustomReportBuilder(context),
            tooltip: 'Custom Report Builder',
          ),
          // Goal Tracking (v2.5.1)
          IconButton(
            icon: const Icon(Icons.track_changes_outlined),
            onPressed: () => _showGoalTracking(context),
            tooltip: 'Goal Tracking',
          ),
          // Date range picker
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () => _showDateRangePicker(context),
            tooltip: 'Date Range',
          ),
          // Export button
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () => _showExportSheet(context),
            tooltip: 'Export',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(
          width: double.infinity,
          height: 80,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        Column(
          children: [
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 1 ? 8.0 : 0.0),
                  child: SkeletonLoader(
                    width: double.infinity,
                    height: 120,
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              )),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 1 ? 8.0 : 0.0),
                  child: SkeletonLoader(
                    width: double.infinity,
                    height: 120,
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // ReportTypeTabs - SegmentedControl
        SegmentedControl(
          segments: _reportTypes,
          selectedIndex: _selectedReportType,
          onSelectionChanged: (index) {
            setState(() => _selectedReportType = index);
          },
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Tab-specific content
        IndexedStack(
          index: _selectedReportType,
          children: [
            _buildOverviewTab(),
            _buildRevenueTab(),
            _buildJobsTab(),
            _buildClientsTab(),
            _buildAIPerformanceTab(),
            _buildTeamTab(),
          ],
        ),
        const SizedBox(height: 96), // Bottom padding for nav bar
      ],
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      children: [
        // KPISummaryRow - Top-level metrics
        _buildKPISummaryRow(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // ChartCardGrid - 2×2 or 3×1 chart layout
        _buildChartCardGrid(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // DataTableSection - Detailed breakdowns
        _buildDataTableSection(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // AutomationHistoryTable (v2.5.1)
        _buildAutomationHistory(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Goal Tracking Section (v2.5.1)
        _buildGoalTrackingSection(),
      ],
    );
  }

  Widget _buildRevenueTab() {
    return Column(
      children: [
        _buildKPISummaryRow(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        TrendLineChart(
          title: 'Revenue Trends',
          dataPoints: [
            ChartDataPoint(label: 'Week 1', value: 5000),
            ChartDataPoint(label: 'Week 2', value: 6200),
            ChartDataPoint(label: 'Week 3', value: 5800),
            ChartDataPoint(label: 'Week 4', value: 7500),
          ],
          periodData: {
            '7D': [
              ChartDataPoint(label: 'D1', value: 800),
              ChartDataPoint(label: 'D2', value: 950),
              ChartDataPoint(label: 'D3', value: 720),
              ChartDataPoint(label: 'D4', value: 1050),
              ChartDataPoint(label: 'D5', value: 920),
              ChartDataPoint(label: 'D6', value: 1100),
              ChartDataPoint(label: 'D7', value: 1250),
            ],
            '30D': [
              ChartDataPoint(label: 'Week 1', value: 5000),
              ChartDataPoint(label: 'Week 2', value: 6200),
              ChartDataPoint(label: 'Week 3', value: 5800),
              ChartDataPoint(label: 'Week 4', value: 7500),
            ],
            '90D': [
              ChartDataPoint(label: 'Month 1', value: 22000),
              ChartDataPoint(label: 'Month 2', value: 24800),
              ChartDataPoint(label: 'Month 3', value: 28500),
            ],
          },
          lineColor: const Color(SwiftleadTokens.primaryTeal),
          yAxisLabel: '£',
        ),
      ],
    );
  }

  Widget _buildJobsTab() {
    return Column(
      children: [
        ConversionFunnelChart(
          stages: [
            FunnelStage(label: 'Inquiries', value: 100),
            FunnelStage(label: 'Quotes', value: 75),
            FunnelStage(label: 'Bookings', value: 50),
            FunnelStage(label: 'Completed', value: 42),
          ],
          onStageTap: () {},
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _buildJobsDataTable(),
      ],
    );
  }

  Widget _buildJobsDataTable() {
    final jobsByStatusData = [
      {'status': 'In Progress', 'count': 8, 'value': 3200.0},
      {'status': 'Scheduled', 'count': 12, 'value': 4800.0},
      {'status': 'Quoted', 'count': 15, 'value': 4500.0},
      {'status': 'Completed', 'count': 42, 'value': 16800.0},
    ];

    return SwiftleadDataTable(
      title: 'Jobs by Status',
      columns: const [
        DataTableColumn(label: 'Status'),
        DataTableColumn(label: 'Count', alignment: TextAlign.right),
        DataTableColumn(label: 'Total Value', alignment: TextAlign.right),
      ],
      rows: jobsByStatusData.map((status) {
        return DataTableRow(
          cells: [
            Text(
              status['status'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${status['count']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '£${(status['value'] as double).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        );
      }).toList(),
      showLoadMore: false,
    );
  }

  Widget _buildClientsTab() {
    return Column(
      children: [
        LeadSourcePieChart(
          sources: [
            LeadSourceData(label: 'Website', value: 45, color: const Color(SwiftleadTokens.primaryTeal)),
            LeadSourceData(label: 'Referral', value: 25, color: const Color(SwiftleadTokens.successGreen)),
            LeadSourceData(label: 'Social Media', value: 20, color: const Color(SwiftleadTokens.warningYellow)),
            LeadSourceData(label: 'Other', value: 10, color: Colors.grey),
          ],
          onSourceTap: (index) {},
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _buildClientsDataTable(),
      ],
    );
  }

  Widget _buildClientsDataTable() {
    final clientAcquisitionData = [
      {'period': 'This Month', 'new': 12, 'returning': 8, 'total': 20},
      {'period': 'Last Month', 'new': 15, 'returning': 6, 'total': 21},
      {'period': '2 Months Ago', 'new': 10, 'returning': 5, 'total': 15},
    ];

    return SwiftleadDataTable(
      title: 'Client Acquisition Over Time',
      columns: const [
        DataTableColumn(label: 'Period'),
        DataTableColumn(label: 'New', alignment: TextAlign.right),
        DataTableColumn(label: 'Returning', alignment: TextAlign.right),
        DataTableColumn(label: 'Total', alignment: TextAlign.right),
      ],
      rows: clientAcquisitionData.map((period) {
        return DataTableRow(
          cells: [
            Text(
              period['period'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${period['new']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${period['returning']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${period['total']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        );
      }).toList(),
      showLoadMore: false,
    );
  }

  Widget _buildAIPerformanceTab() {
    return Column(
      children: [
        _buildKPISummaryRow(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _buildAutomationHistory(),
      ],
    );
  }

  Widget _buildTeamTab() {
    return Column(
      children: [
        EmptyStateCard(
          title: 'Team Performance',
          description: 'Individual team member stats (if multi-user)',
          icon: Icons.people_outline,
          actionLabel: 'Add Team Members',
          onAction: () {
            // Navigate to team management
          },
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        // Mock team members for now
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: TeamPerformanceCard(
              memberName: ['Alex Johnson', 'Sam Smith', 'Taylor Brown'][index],
              jobsCompleted: [42, 38, 35][index],
              revenue: [12500.0, 11200.0, 9800.0][index],
              rating: 4,
              trendPercentage: [12.5, 8.3, -2.1][index],
              isPositiveTrend: index < 2,
              onTap: () {
                // Navigate to team member detail
              },
            ),
          );
        }),
      ],
    );
  }

  void _showCustomReportBuilder(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Custom Report Builder',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Build a custom report by selecting metrics and visualizations:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Available Metrics:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ...['Revenue', 'Jobs', 'Clients', 'Conversion Rate', 'Response Time', 'AI Performance'].map((metric) {
            return ListTile(
              leading: Checkbox(value: metric == 'Revenue', onChanged: (v) {}),
              title: Text(metric),
              trailing: const Icon(Icons.drag_handle),
            );
          }).toList(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Create Custom Report',
            onPressed: () {
              Navigator.pop(context);
              // Create custom report
            },
          ),
        ],
      ),
    );
  }

  void _showGoalTracking(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Goal Tracking',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          _GoalCard(
            label: 'Monthly Revenue',
            target: 15000,
            current: 12400,
            deadline: DateTime.now().add(const Duration(days: 15)),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _GoalCard(
            label: 'New Clients',
            target: 20,
            current: 12,
            deadline: DateTime.now().add(const Duration(days: 15)),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Add New Goal',
            onPressed: () {
              // Add goal
            },
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Select Date Range',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          ...['Last 7 days', 'Last 30 days', 'Last 90 days', 'This month', 'Last month', 'Custom'].map((range) {
            return ListTile(
              title: Text(range),
              trailing: range == 'Last 30 days' ? const Icon(Icons.check, color: Color(SwiftleadTokens.primaryTeal)) : null,
              onTap: () {
                Navigator.pop(context);
                // Apply date range
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showExportSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Export Report',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Format',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            children: ['PDF', 'Excel', 'CSV'].map((format) {
              return SwiftleadChip(
                label: format,
                isSelected: format == 'PDF',
                onTap: () {},
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Template',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          DropdownButtonFormField<String>(
            value: 'Summary',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: ['Summary', 'Detailed', 'Tax-Ready'].map((template) {
              return DropdownMenuItem(
                value: template,
                child: Text(template),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Row(
            children: [
              Checkbox(value: false, onChanged: (v) {}),
              const Expanded(
                child: Text('Email report to me'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Generate Report',
            onPressed: () {
              Navigator.pop(context);
              // Generate export
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKPISummaryRow() {
    // Use KPICard for the primary metric (Revenue) and TrendTile for others
    return Column(
      children: [
        // Large KPICard for Revenue
        KPICard(
          label: 'Revenue',
          value: '£12.4k',
          trend: '+12%',
          vsPreviousPeriod: 'Last Month',
          isPositive: true,
          sparklineData: [8000, 9000, 10000, 11000, 12000, 12200, 12400],
          tooltip: 'Total revenue this month vs last month',
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // TrendTiles for secondary metrics
        Row(
          children: [
            Expanded(
              child: TrendTile(
                label: 'Jobs',
                value: '42',
                trend: '+8',
                isPositive: true,
                sparklineData: [30, 32, 35, 38, 40, 41, 42],
                tooltip: 'Completed jobs',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: TrendTile(
                label: 'Clients',
                value: '156',
                trend: '+12',
                isPositive: true,
                sparklineData: [140, 144, 148, 150, 152, 154, 156],
                tooltip: 'Total clients',
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: TrendTile(
                label: 'Conversion',
                value: '68%',
                trend: '+5%',
                isPositive: true,
                sparklineData: [60, 62, 64, 65, 66, 67, 68],
                tooltip: 'Inquiry to booking rate',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            // Empty space to maintain grid
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCardGrid() {
    return Column(
      children: [
        // Revenue Chart
        TrendLineChart(
          title: 'Revenue Chart',
          dataPoints: [
            ChartDataPoint(label: 'Week 1', value: 5000),
            ChartDataPoint(label: 'Week 2', value: 6200),
            ChartDataPoint(label: 'Week 3', value: 5800),
            ChartDataPoint(label: 'Week 4', value: 7500),
          ],
          lineColor: const Color(SwiftleadTokens.primaryTeal),
          yAxisLabel: '£',
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Jobs Pipeline - Conversion Funnel
        ConversionFunnelChart(
          stages: [
            FunnelStage(label: 'Inquiries', value: 100),
            FunnelStage(label: 'Quotes', value: 75),
            FunnelStage(label: 'Bookings', value: 50),
            FunnelStage(label: 'Completed', value: 42),
          ],
          onStageTap: () {},
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Row of two charts - stacked vertically on small screens
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Stack vertically on small screens
              return Column(
                children: [
                  LeadSourcePieChart(
                    sources: [
                      LeadSourceData(label: 'New', value: 60, color: const Color(SwiftleadTokens.primaryTeal)),
                      LeadSourceData(label: 'Returning', value: 40, color: const Color(SwiftleadTokens.successGreen)),
                    ],
                    onSourceTap: (index) {},
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  ChannelPerformanceChart(
                    title: 'Channel Performance',
                    channels: [
                      ChannelPerformanceData(channel: 'SMS', messageCount: 45, color: const Color(SwiftleadTokens.primaryTeal)),
                      ChannelPerformanceData(channel: 'WhatsApp', messageCount: 78, color: const Color(SwiftleadTokens.successGreen)),
                      ChannelPerformanceData(channel: 'Email', messageCount: 32, color: const Color(SwiftleadTokens.warningYellow)),
                      ChannelPerformanceData(channel: 'Instagram', messageCount: 21, color: Colors.purple),
                    ],
                  ),
                ],
              );
            }
            
            // Side by side on larger screens
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LeadSourcePieChart(
                    sources: [
                      LeadSourceData(label: 'New', value: 60, color: const Color(SwiftleadTokens.primaryTeal)),
                      LeadSourceData(label: 'Returning', value: 40, color: const Color(SwiftleadTokens.successGreen)),
                    ],
                    onSourceTap: (index) {},
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: ChannelPerformanceChart(
                    title: 'Channel Performance',
                    channels: [
                      ChannelPerformanceData(channel: 'SMS', messageCount: 45, color: const Color(SwiftleadTokens.primaryTeal)),
                      ChannelPerformanceData(channel: 'WhatsApp', messageCount: 78, color: const Color(SwiftleadTokens.successGreen)),
                      ChannelPerformanceData(channel: 'Email', messageCount: 32, color: const Color(SwiftleadTokens.warningYellow)),
                      ChannelPerformanceData(channel: 'Instagram', messageCount: 21, color: Colors.purple),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Response Times Chart
        ResponseTimesChart(
          title: 'Response Times',
          channels: [
            ResponseTimeData(channel: 'SMS', averageMinutes: 12.5, color: const Color(SwiftleadTokens.primaryTeal)),
            ResponseTimeData(channel: 'WhatsApp', averageMinutes: 18.3, color: const Color(SwiftleadTokens.successGreen)),
            ResponseTimeData(channel: 'Email', averageMinutes: 45.2, color: const Color(SwiftleadTokens.warningYellow)),
            ResponseTimeData(channel: 'Instagram', averageMinutes: 22.1, color: Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTableSection() {
    // Top Services Table
    final topServicesData = [
      {'service': 'Boiler Repair', 'count': 24, 'revenue': 7200.0},
      {'service': 'Plumbing', 'count': 18, 'revenue': 5400.0},
      {'service': 'Electrical', 'count': 15, 'revenue': 4500.0},
      {'service': 'Heating', 'count': 12, 'revenue': 3600.0},
      {'service': 'Emergency Callout', 'count': 8, 'revenue': 3200.0},
    ];

    // Top Clients Table
    final topClientsData = [
      {'client': 'John Smith', 'lifetime': 12500.0, 'jobs': 12},
      {'client': 'Sarah Johnson', 'lifetime': 9800.0, 'jobs': 8},
      {'client': 'Mike Brown', 'lifetime': 7600.0, 'jobs': 6},
      {'client': 'Emma Davis', 'lifetime': 6400.0, 'jobs': 5},
    ];

    return Column(
      children: [
        SwiftleadDataTable(
          title: 'Top Services',
          columns: const [
            DataTableColumn(label: 'Service Type'),
            DataTableColumn(label: 'Count', alignment: TextAlign.right),
            DataTableColumn(label: 'Revenue', alignment: TextAlign.right),
          ],
          rows: topServicesData.map((service) {
            return DataTableRow(
              cells: [
                Text(
                  service['service'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${service['count']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '£${(service['revenue'] as double).toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        SwiftleadDataTable(
          title: 'Top Clients',
          columns: const [
            DataTableColumn(label: 'Client'),
            DataTableColumn(label: 'Lifetime Value', alignment: TextAlign.right),
            DataTableColumn(label: 'Jobs', alignment: TextAlign.right),
          ],
          rows: topClientsData.map((client) {
            return DataTableRow(
              cells: [
                Text(
                  client['client'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '£${(client['lifetime'] as double).toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${client['jobs']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        _buildBusiestDaysTable(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _buildPeakHoursTable(),
      ],
    );
  }

  Widget _buildBusiestDaysTable() {
    final busiestDaysData = [
      {'day': 'Monday', 'bookings': 12, 'revenue': 3600.0},
      {'day': 'Tuesday', 'bookings': 15, 'revenue': 4500.0},
      {'day': 'Wednesday', 'bookings': 18, 'revenue': 5400.0},
      {'day': 'Thursday', 'bookings': 14, 'revenue': 4200.0},
      {'day': 'Friday', 'bookings': 16, 'revenue': 4800.0},
      {'day': 'Saturday', 'bookings': 8, 'revenue': 2400.0},
      {'day': 'Sunday', 'bookings': 3, 'revenue': 900.0},
    ];

    return SwiftleadDataTable(
      title: 'Busiest Days',
      columns: const [
        DataTableColumn(label: 'Day of Week'),
        DataTableColumn(label: 'Bookings', alignment: TextAlign.right),
        DataTableColumn(label: 'Revenue', alignment: TextAlign.right),
      ],
      rows: busiestDaysData.map((day) {
        return DataTableRow(
          cells: [
            Text(
              day['day'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${day['bookings']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '£${(day['revenue'] as double).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        );
      }).toList(),
      showLoadMore: false,
    );
  }

  Widget _buildPeakHoursTable() {
    final peakHoursData = [
      {'hour': '08:00', 'activity': 'Low'},
      {'hour': '09:00', 'activity': 'Medium'},
      {'hour': '10:00', 'activity': 'High'},
      {'hour': '11:00', 'activity': 'High'},
      {'hour': '12:00', 'activity': 'Medium'},
      {'hour': '13:00', 'activity': 'Low'},
      {'hour': '14:00', 'activity': 'Medium'},
      {'hour': '15:00', 'activity': 'High'},
      {'hour': '16:00', 'activity': 'High'},
      {'hour': '17:00', 'activity': 'Medium'},
    ];

    return SwiftleadDataTable(
      title: 'Peak Hours',
      columns: const [
        DataTableColumn(label: 'Hour of Day'),
        DataTableColumn(label: 'Activity Level'),
      ],
      rows: peakHoursData.map((hour) {
        final activity = hour['activity'] as String;
        Color activityColor;
        switch (activity) {
          case 'High':
            activityColor = const Color(SwiftleadTokens.errorRed);
            break;
          case 'Medium':
            activityColor = const Color(SwiftleadTokens.warningYellow);
            break;
          default:
            activityColor = const Color(SwiftleadTokens.successGreen);
        }

        return DataTableRow(
          cells: [
            Text(
              hour['hour'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: activityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Text(
                activity,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: activityColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        );
      }).toList(),
      showLoadMore: false,
    );
  }

  Widget _buildAutomationHistory() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Automation History',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ...List.generate(5, (index) => Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: _AutomationHistoryRow(
              timestamp: DateTime.now().subtract(Duration(hours: index * 2)),
              action: ['Auto-reply', 'Booking Offer', 'Quote Chase', 'Review Request', 'Smart Reply'][index],
              outcome: ['Successful', 'Booked', 'Sent', 'Delivered', 'Accepted'][index],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildGoalTrackingSection() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goals Progress',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () => _showGoalTracking(context),
                child: const Text('Manage Goals'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _GoalProgressCard(
            label: 'Monthly Revenue',
            target: 15000,
            current: 12400,
            progress: 12400 / 15000,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _GoalProgressCard(
            label: 'New Clients',
            target: 20,
            current: 12,
            progress: 12 / 20,
          ),
        ],
      ),
    );
  }
}


class _AutomationHistoryRow extends StatelessWidget {
  final DateTime timestamp;
  final String action;
  final String outcome;

  const _AutomationHistoryRow({
    required this.timestamp,
    required this.action,
    required this.outcome,
  });

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatTime(timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            outcome,
            style: const TextStyle(
              color: Color(SwiftleadTokens.successGreen),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  final String label;
  final double target;
  final double current;
  final double progress;

  const _GoalProgressCard({
    required this.label,
    required this.target,
    required this.current,
    required this.progress,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.06)
                : Colors.white.withOpacity(0.06),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(SwiftleadTokens.primaryTeal),
            ),
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          '£${current.toStringAsFixed(0)} / £${target.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String label;
  final double target;
  final double current;
  final DateTime deadline;

  const _GoalCard({
    required this.label,
    required this.target,
    required this.current,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / target;
    final daysRemaining = deadline.difference(DateTime.now()).inDays;

    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$daysRemaining days left',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.06)
                  : Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0
                    ? const Color(SwiftleadTokens.successGreen)
                    : const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '£${current.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Target: £${target.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


