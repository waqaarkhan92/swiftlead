import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/job_card.dart';
import '../../theme/tokens.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';

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
  List<int> _tabCounts = [0, 0, 0, 0];
  int _activeFilters = 0;
  List<Job> _allJobs = [];
  List<Job> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      _allJobs = await MockJobs.fetchAll();
      final statusCounts = await MockJobs.getCountByStatus();

      _tabCounts = [
        _allJobs.length, // All
        (statusCounts[JobStatus.inProgress] ?? 0) +
            (statusCounts[JobStatus.scheduled] ?? 0), // Active
        statusCounts[JobStatus.completed] ?? 0, // Completed
        statusCounts[JobStatus.cancelled] ?? 0, // Cancelled
      ];
    }

    _applyFilter();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    if (_selectedTabIndex == 0) {
      _filteredJobs = List.from(_allJobs);
    } else if (_selectedTabIndex == 1) {
      // Active jobs
      _filteredJobs = _allJobs
          .where((j) =>
              j.status == JobStatus.inProgress ||
              j.status == JobStatus.scheduled)
          .toList();
    } else if (_selectedTabIndex == 2) {
      // Completed
      _filteredJobs = _allJobs
          .where((j) => j.status == JobStatus.completed)
          .toList();
    } else if (_selectedTabIndex == 3) {
      // Cancelled
      _filteredJobs = _allJobs
          .where((j) => j.status == JobStatus.cancelled)
          .toList();
    }
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
              setState(() {
                _selectedTabIndex = index;
                _applyFilter();
              });
            },
          ),
        ),
        
        // JobCardList - Card grid with rich information
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadJobs();
            },
            child: _buildJobList(),
          ),
        ),
      ],
    );
  }

  Widget _buildJobList() {
    if (_filteredJobs.isEmpty) {
      return EmptyStateCard(
        title: _selectedTabIndex == 0
            ? 'Create your first job'
            : 'No ${_tabs[_selectedTabIndex].toLowerCase()} jobs',
        description: _selectedTabIndex == 0
            ? 'Start tracking work and managing payments.'
            : 'Jobs will appear here when their status matches this filter.',
        icon: Icons.work_outline,
        actionLabel: _selectedTabIndex == 0 ? 'Create Job' : null,
        onAction: _selectedTabIndex == 0 ? () {} : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _filteredJobs.length,
      itemBuilder: (context, index) {
        final job = _filteredJobs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: JobCard(
            jobTitle: job.title,
            clientName: job.contactName,
            serviceType: job.serviceType,
            status: job.status.displayName,
            dueDate: job.scheduledDate,
            price: '£${job.value.toStringAsFixed(2)}',
            teamMemberName: job.assignedTo,
            onTap: () {
              // Navigate to job detail
            },
          ),
        );
      },
    );
  }
}
