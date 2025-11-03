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
import '../main_navigation.dart' as main_nav;
import 'job_detail_screen.dart';
import 'job_search_screen.dart';
import 'create_edit_job_screen.dart';
import '../../widgets/forms/jobs_filter_sheet.dart';
import '../../widgets/forms/jobs_quick_actions_sheet.dart';
import '../../widgets/global/toast.dart';

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
  JobsFilters? _currentFilters;

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
    // Start with tab filtering
    List<Job> baseList;
    if (_selectedTabIndex == 0) {
      baseList = List.from(_allJobs);
    } else if (_selectedTabIndex == 1) {
      // Active jobs
      baseList = _allJobs
          .where((j) =>
              j.status == JobStatus.inProgress ||
              j.status == JobStatus.scheduled)
          .toList();
    } else if (_selectedTabIndex == 2) {
      // Completed
      baseList = _allJobs
          .where((j) => j.status == JobStatus.completed)
          .toList();
    } else if (_selectedTabIndex == 3) {
      // Cancelled
      baseList = _allJobs
          .where((j) => j.status == JobStatus.cancelled)
          .toList();
    } else {
      baseList = List.from(_allJobs);
    }
    
    // Then apply additional filters if any
    if (_currentFilters != null) {
      final beforeCount = baseList.length;
      print('[JOBS FILTER] Applying filters: ${_currentFilters!.statusFilters} | ${_currentFilters!.serviceTypeFilters} | ${_currentFilters!.dateRange}');
      _filteredJobs = _applyFiltersTo(baseList, _currentFilters!);
      final afterCount = _filteredJobs.length;
      print('[JOBS FILTER] Applied filters: Base: $beforeCount -> Filtered: $afterCount');
    } else {
      print('[JOBS FILTER] No filters applied, using base list');
      _filteredJobs = baseList;
    }
  }

  List<Job> _applyFiltersTo(List<Job> jobs, JobsFilters filters) {
    List<Job> filtered = List.from(jobs);
    
    // Apply status filters
    if (!filters.statusFilters.contains('All') && filters.statusFilters.isNotEmpty) {
      final beforeCount = filtered.length;
      filtered = filtered.where((job) {
        final statusName = job.status.displayName;
        final matches = filters.statusFilters.contains(statusName);
        print('[JOBS FILTER] Job "${job.title}" status: "$statusName" matches: $matches (filter: ${filters.statusFilters})');
        return matches;
      }).toList();
      print('[JOBS FILTER] Status filter: $beforeCount -> ${filtered.length}');
    }
    
    // Apply service type filters
    if (!filters.serviceTypeFilters.contains('All') && filters.serviceTypeFilters.isNotEmpty) {
      final beforeCount = filtered.length;
      filtered = filtered.where((job) {
        final matches = filters.serviceTypeFilters.contains(job.serviceType);
        print('[JOBS FILTER] Job "${job.title}" serviceType: "${job.serviceType}" matches: $matches');
        return matches;
      }).toList();
      print('[JOBS FILTER] Service type filter: $beforeCount -> ${filtered.length}');
    }
    
    // Apply date range filters (simplified for now)
    if (filters.dateRange != 'All Time') {
      final now = DateTime.now();
      DateTime? startDate;
      switch (filters.dateRange) {
        case 'Today':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'This Week':
          startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
        case 'This Month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        default:
          break;
      }
      if (startDate != null) {
        filtered = filtered.where((job) {
          final scheduled = job.scheduledDate;
          return scheduled != null && scheduled.isAfter(startDate!);
        }).toList();
      }
    }
    
    return filtered;
  }

  int _countActiveFilters(JobsFilters filters) {
    int count = 0;
    if (!filters.statusFilters.contains('All') || filters.statusFilters.length > 1) {
      count += filters.statusFilters.length - (filters.statusFilters.contains('All') ? 1 : 0);
    }
    if (!filters.serviceTypeFilters.contains('All') || filters.serviceTypeFilters.length > 1) {
      count += filters.serviceTypeFilters.length - (filters.serviceTypeFilters.contains('All') ? 1 : 0);
    }
    if (filters.dateRange != 'All Time') {
      count++;
    }
    return count;
  }

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(SwiftleadTokens.radiusModal),
            topRight: Radius.circular(SwiftleadTokens.radiusModal),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Sort by Name'),
                onTap: () {
                  setState(() {
                    _filteredJobs.sort((a, b) => a.title.compareTo(b.title));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Sort by Date'),
                onTap: () {
                  setState(() {
                    _filteredJobs.sort((a, b) {
                      final aDate = a.scheduledDate ?? DateTime(1900);
                      final bDate = b.scheduledDate ?? DateTime(1900);
                      return bDate.compareTo(aDate);
                    });
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Sort by Value'),
                onTap: () {
                  setState(() {
                    _filteredJobs.sort((a, b) => b.value.compareTo(a.value));
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'create_job':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateEditJobScreen(),
          ),
        );
        break;
      case 'create_booking':
        // Navigate to calendar create booking
        Navigator.pushNamed(context, '/calendar/create');
        break;
      case 'send_invoice':
        // Navigate to create invoice
        Navigator.pushNamed(context, '/money/invoice/create');
        break;
      case 'payment_link':
        // Navigate to payment link
        Navigator.pushNamed(context, '/money/payment-link');
        break;
      case 'add_contact':
        // Navigate to add contact
        Navigator.pushNamed(context, '/contacts/create');
        break;
      case 'new_message':
        // Navigate to compose message
        Navigator.pushNamed(context, '/inbox/compose');
        break;
      default:
        Toast.show(
          context,
          message: 'Action not implemented yet',
          type: ToastType.info,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Jobs',
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_outlined),
                onPressed: () async {
                  final filters = await JobsFilterSheet.show(
                    context: context,
                    initialFilters: _currentFilters,
                  );
                  print('[JOBS FILTER] Filter sheet returned: ${filters?.statusFilters} | ${filters?.serviceTypeFilters} | ${filters?.dateRange}');
                  if (filters != null && mounted) {
                    // Always apply filters, even if they're defaults
                    setState(() {
                      _currentFilters = filters;
                      _activeFilters = _countActiveFilters(filters);
                      print('[JOBS FILTER] Setting filters: activeFilters=$_activeFilters');
                      // Always reapply filters
                      _applyFilter();
                    });
                  } else if (filters == null && _currentFilters != null && mounted) {
                    // Clear filters if user cancelled or cleared
                    setState(() {
                      _currentFilters = null;
                      _activeFilters = 0;
                      _applyFilter();
                    });
                  }
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
              _showSortMenu(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final action = await JobsQuickActionsSheet.show(context: context);
              if (action != null && mounted) {
                _handleQuickAction(action);
              }
            },
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
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        top: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
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
                _applyFilter(); // This will combine tab filter with any active filters
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
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        top: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                    jobId: job.id,
                    jobTitle: job.title,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
