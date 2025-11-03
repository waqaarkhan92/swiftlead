import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../theme/tokens.dart';

/// Goal Tracking Screen - Track and monitor business goals
/// Exact specification from UI_Inventory_v2.5.1, line 351
class GoalTrackingScreen extends StatefulWidget {
  const GoalTrackingScreen({super.key});

  @override
  State<GoalTrackingScreen> createState() => _GoalTrackingScreenState();
}

class _GoalTrackingScreenState extends State<GoalTrackingScreen> {
  final List<_Goal> _goals = [
    _Goal(
      id: '1',
      name: 'Monthly Revenue',
      target: 10000,
      current: 8500,
      deadline: DateTime.now().add(const Duration(days: 15)),
    ),
    _Goal(
      id: '2',
      name: 'Customer Satisfaction',
      target: 4.5,
      current: 4.2,
      deadline: DateTime.now().add(const Duration(days: 30)),
    ),
    _Goal(
      id: '3',
      name: 'Jobs Completed',
      target: 50,
      current: 35,
      deadline: DateTime.now().add(const Duration(days: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Goal Tracking',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGoalDialog(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Summary
          _buildSummaryCard(),
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Goals List
          ..._goals.map((goal) => _buildGoalCard(goal)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalGoals = _goals.length;
    final completedGoals = _goals.where((g) => g.progress >= 1.0).length;
    final onTrack = _goals.where((g) => g.progress >= 0.7 && g.progress < 1.0).length;
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total Goals', totalGoals.toString()),
              ),
              Expanded(
                child: _buildStatItem('Completed', completedGoals.toString()),
              ),
              Expanded(
                child: _buildStatItem('On Track', onTrack.toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildGoalCard(_Goal goal) {
    final progress = goal.progress;
    final daysRemaining = goal.deadline.difference(DateTime.now()).inDays;
    
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
                child: Text(
                  goal.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SwiftleadTokens.spaceS,
                  vertical: SwiftleadTokens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: _getProgressColor(progress).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getProgressColor(progress),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          // Progress Bar
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
            minHeight: 8,
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${goal.current} / ${goal.target}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$daysRemaining days remaining',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: daysRemaining < 7
                          ? const Color(SwiftleadTokens.errorRed)
                          : null,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) {
      return const Color(SwiftleadTokens.successGreen);
    } else if (progress >= 0.7) {
      return const Color(SwiftleadTokens.primaryTeal);
    } else if (progress >= 0.4) {
      return const Color(SwiftleadTokens.warningYellow);
    } else {
      return const Color(SwiftleadTokens.errorRed);
    }
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Goal'),
        content: const Text('Goal creation form would go here'),
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
                message: 'Goal created',
                type: ToastType.success,
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _Goal {
  final String id;
  final String name;
  final double target;
  final double current;
  final DateTime deadline;

  _Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
    required this.deadline,
  });

  double get progress => (current / target).clamp(0.0, 1.0);
}

