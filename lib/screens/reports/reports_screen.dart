import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/kpi_card.dart';
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
  final List<String> _reportTypes = ['Overview', 'Revenue', 'Jobs', 'Clients', 'AI Performance'];
  
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
        Row(
          children: [
            Expanded(
              child: _ChartCard(
                title: 'Revenue Chart',
                description: 'Line/bar showing income over time',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _ChartCard(
                title: 'Jobs Pipeline',
                description: 'Funnel visualization',
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: _ChartCard(
                title: 'Client Acquisition',
                description: 'New vs returning (donut)',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _ChartCard(
                title: 'Channel Performance',
                description: 'Messages by channel (bar)',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTableSection() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Services',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // DataTable would go here
          Text(
            'Service type + count + revenue\n(Sortable columns, pagination)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
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

class _ChartCard extends StatelessWidget {
  final String title;
  final String description;

  const _ChartCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SizedBox(
            height: 150,
            child: Center(
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
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

