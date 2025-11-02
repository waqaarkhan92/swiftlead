import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/job_card.dart';
import '../../theme/tokens.dart';

/// JobsScreen - Job management pipeline
/// Exact specification from Screen_Layouts_v2.5.1
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool _isLoading = true;
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All', 'Active', 'Completed', 'Cancelled'];
  final List<int> _tabCounts = [24, 18, 6, 0];
  int _activeFilters = 0;

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
        title: 'Jobs',
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_outlined),
                onPressed: () {
                  // FilterSheet opens
                },
              ),
              if (_activeFilters > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(SwiftleadTokens.primaryTeal),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_activeFilters',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Sort dropdown
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Quick actions: "From Quote", "From Scratch", "From Template"
        },
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Job',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: SkeletonCard(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // PipelineTabs - SegmentedControl with counts
        Container(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: SegmentedControl(
            segments: _tabs,
            selectedIndex: _selectedTabIndex,
            badgeCounts: _tabCounts,
            onSelectionChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() => _selectedTabIndex = index);
            },
          ),
        ),
        
        // JobCardList - Card grid with rich information
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildJobList(),
          ),
        ),
      ],
    );
  }

  Widget _buildJobList() {
    // Empty state when no jobs
    return EmptyStateCard(
      title: 'Create your first job',
      description: 'Start tracking work and managing payments.',
      icon: Icons.work_outline,
      actionLabel: 'Create Job',
      onAction: () {},
    );
  }
}
