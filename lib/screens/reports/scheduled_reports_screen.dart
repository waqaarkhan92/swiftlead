import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

/// Scheduled Reports Screen - Manage automated report generation and delivery
/// Exact specification from UI_Inventory_v2.5.1, line 352
class ScheduledReportsScreen extends StatefulWidget {
  const ScheduledReportsScreen({super.key});

  @override
  State<ScheduledReportsScreen> createState() => _ScheduledReportsScreenState();
}

class _ScheduledReportsScreenState extends State<ScheduledReportsScreen> {
  final List<_ScheduledReport> _reports = [
    _ScheduledReport(
      id: '1',
      name: 'Weekly Revenue Report',
      frequency: 'Weekly',
      nextRun: DateTime.now().add(const Duration(days: 2)),
      recipients: ['team@example.com'],
      isActive: true,
    ),
    _ScheduledReport(
      id: '2',
      name: 'Monthly Performance Summary',
      frequency: 'Monthly',
      nextRun: DateTime.now().add(const Duration(days: 15)),
      recipients: ['manager@example.com'],
      isActive: true,
    ),
    _ScheduledReport(
      id: '3',
      name: 'Daily Job Status',
      frequency: 'Daily',
      nextRun: DateTime.now().add(const Duration(days: 1)),
      recipients: ['team@example.com'],
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Scheduled Reports',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateScheduleDialog(),
          ),
        ],
      ),
      body: _reports.isEmpty
          ? Center(
              child: EmptyStateCard(
                title: 'No scheduled reports',
                description: 'Create your first scheduled report',
                icon: Icons.schedule,
                actionLabel: 'Create Schedule',
                onAction: () => _showCreateScheduleDialog(),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: _reports.map((report) => _buildReportCard(report)).toList(),
            ),
    );
  }

  Widget _buildReportCard(_ScheduledReport report) {
    final daysUntil = report.nextRun.difference(DateTime.now()).inDays;
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      report.frequency,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: report.isActive,
                onChanged: (value) {
                  setState(() {
                    report.isActive = value;
                  });
                  Toast.show(
                    context,
                    message: value ? 'Report activated' : 'Report deactivated',
                    type: ToastType.success,
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          const Divider(),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceXS),
              Text(
                'Next run: ${_formatDate(report.nextRun)} ($daysUntil days)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceXS),
          
          Row(
            children: [
              Icon(
                Icons.email,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceXS),
              Expanded(
                child: Text(
                  'Recipients: ${report.recipients.join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _editReport(report),
                child: const Text('Edit'),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              TextButton(
                onPressed: () => _deleteReport(report),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(SwiftleadTokens.errorRed),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Report'),
        content: const Text('Report scheduling form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Report scheduled',
                type: ToastType.success,
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editReport(_ScheduledReport report) {
    // Navigate to edit screen
    Toast.show(
      context,
      message: 'Edit report: ${report.name}',
      type: ToastType.info,
    );
  }

  void _deleteReport(_ScheduledReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Scheduled Report'),
        content: Text('Are you sure you want to delete "${report.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _reports.remove(report);
              });
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Report deleted',
                type: ToastType.success,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(SwiftleadTokens.errorRed),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ScheduledReport {
  final String id;
  final String name;
  final String frequency;
  final DateTime nextRun;
  final List<String> recipients;
  bool isActive;

  _ScheduledReport({
    required this.id,
    required this.name,
    required this.frequency,
    required this.nextRun,
    required this.recipients,
    required this.isActive,
  });
}

