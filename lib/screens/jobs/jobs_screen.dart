import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/job_card.dart';
import '../../widgets/global/badge.dart' show SwiftleadBadge, BadgeVariant, BadgeSize;
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
import '../../widgets/global/haptic_feedback.dart' as app_haptics;
import '../../widgets/global/spring_animation.dart';
import '../../widgets/components/animated_counter.dart';
import '../../widgets/components/smart_collapsible_section.dart';
import '../../widgets/components/celebration_banner.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/active_filter_chips.dart';
import '../../utils/keyboard_shortcuts.dart' show AppShortcuts, SearchIntent, CreateIntent, RefreshIntent, CloseIntent, CreateJobIntent;
import '../../utils/profession_config.dart';
import '../../utils/responsive_layout.dart';
import '../../models/job.dart';
import '../calendar/create_edit_booking_screen.dart';
import '../money/create_edit_invoice_screen.dart';
import '../contacts/create_edit_contact_screen.dart';

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
  final List<String> _tabs = ['All', 'Active', 'Completed'];
  String _viewMode = 'list'; // 'list' or 'kanban'
  List<int> _tabCounts = [0, 0, 0];
  int _activeFilters = 0;
  List<Job> _allJobs = [];
  List<Job> _filteredJobs = [];
  JobsFilters? _currentFilters;
  
  // Smart prioritization tracking
  final Map<String, int> _jobTapCounts = {};
  final Map<String, DateTime> _jobLastOpened = {};
  
  // Celebration tracking
  final Set<String> _milestonesShown = {};
  String? _celebrationMessage;
  
  // AI Insight Banner dismissal tracking
  bool _aiInsightDismissed = false;
  
  // Progressive disclosure states
  bool _todayExpanded = true;
  bool _thisWeekExpanded = true;
  bool _upcomingExpanded = false;

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
            (statusCounts[JobStatus.booked] ?? 0), // Active
        statusCounts[JobStatus.completed] ?? 0, // Completed
        statusCounts[JobStatus.cancelled] ?? 0, // Cancelled
      ];
    }

    _applyFilter();
    _checkForMilestones();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
  
  // Track job interaction for smart prioritization
  void _trackJobInteraction(String jobId) {
    setState(() {
      _jobTapCounts[jobId] = (_jobTapCounts[jobId] ?? 0) + 1;
      _jobLastOpened[jobId] = DateTime.now();
    });
  }
  
  // Phase 3: Expanded celebration milestones
  void _checkForMilestones() {
    final activeJobs = _filteredJobs.where((j) => 
      j.status == JobStatus.inProgress || j.status == JobStatus.booked
    ).length;
    
    // 100 total jobs milestone
    if (_allJobs.length >= 100 && !_milestonesShown.contains('100jobs')) {
      _milestonesShown.add('100jobs');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎉 100 total jobs! Milestone reached!';
          });
        }
      });
    }
    
    // 50 active jobs milestone
    if (activeJobs >= 50 && !_milestonesShown.contains('50active')) {
      _milestonesShown.add('50active');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🚀 50 active jobs! Amazing work!';
          });
        }
      });
    }
    
    // Phase 3: 25 active jobs milestone
    if (activeJobs >= 25 && activeJobs < 50 && !_milestonesShown.contains('25active')) {
      _milestonesShown.add('25active');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '💼 25 active jobs! You\'re busy!';
          });
        }
      });
    }
    
    // Phase 3: 10 active jobs milestone
    if (activeJobs >= 10 && activeJobs < 25 && !_milestonesShown.contains('10active')) {
      _milestonesShown.add('10active');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '⚡ 10 active jobs! Great momentum!';
          });
        }
      });
    }
    
    // Phase 3: First job milestone
    if (_allJobs.length == 1 && !_milestonesShown.contains('firstjob')) {
      _milestonesShown.add('firstjob');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎯 First job created! Welcome to Swiftlead!';
          });
        }
      });
    }
  }
  
  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
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
              j.status == JobStatus.booked)
          .toList();
    } else if (_selectedTabIndex == 2) {
      // Completed
      baseList = _allJobs
          .where((j) => j.status == JobStatus.completed)
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
    
    // Phase 2: Smart prioritization - sort using interaction tracking
    _filteredJobs.sort((a, b) {
      // Active jobs first
      final aIsActive = a.status == JobStatus.inProgress || a.status == JobStatus.booked;
      final bIsActive = b.status == JobStatus.inProgress || b.status == JobStatus.booked;
      if (aIsActive != bIsActive) {
        return aIsActive ? -1 : 1;
      }
      
      // Phase 2: Favor frequently accessed jobs
      final aTapCount = _jobTapCounts[a.id] ?? 0;
      final bTapCount = _jobTapCounts[b.id] ?? 0;
      if (aTapCount != bTapCount) {
        return bTapCount.compareTo(aTapCount);
      }
      
      // Phase 2: Favor recently opened jobs
      final aLastOpened = _jobLastOpened[a.id];
      final bLastOpened = _jobLastOpened[b.id];
      if (aLastOpened != null && bLastOpened != null) {
        return bLastOpened.compareTo(aLastOpened);
      }
      if (aLastOpened != null) return -1;
      if (bLastOpened != null) return 1;
      
      // Finally by scheduled date or creation date
      final aDate = a.scheduledDate ?? a.createdAt;
      final bDate = b.scheduledDate ?? b.createdAt;
      return bDate.compareTo(aDate);
    });
    
    // Phase 2: Contextual hiding - hide completed jobs >30 days old (unless recently opened)
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    _filteredJobs = _filteredJobs.where((job) {
      if (job.status == JobStatus.inProgress || job.status == JobStatus.booked) return true;
      if (_jobLastOpened[job.id] != null && 
          _jobLastOpened[job.id]!.isAfter(thirtyDaysAgo)) return true;
      final jobDate = job.completedAt ?? job.createdAt;
      if (jobDate.isAfter(thirtyDaysAgo)) return true;
      return false; // Hide old completed jobs
    }).toList();
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
    // Count status filters (excluding 'All')
    if (filters.statusFilters.isNotEmpty && !filters.statusFilters.contains('All')) {
      count += filters.statusFilters.length;
    } else if (filters.statusFilters.length > 1) {
      // If 'All' is present but there are other filters, count the others
      count += filters.statusFilters.length - 1;
    }
    // Count service type filters (excluding 'All')
    if (filters.serviceTypeFilters.isNotEmpty && !filters.serviceTypeFilters.contains('All')) {
      count += filters.serviceTypeFilters.length;
    } else if (filters.serviceTypeFilters.length > 1) {
      count += filters.serviceTypeFilters.length - 1;
    }
    // Count date range filter
    if (filters.dateRange != 'All Time') {
      count++;
    }
    return count;
  }

  void _showJobContextMenu(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Job'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    _createPageRoute(CreateEditJobScreen(jobId: job.id)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement duplicate
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement archive
                },
              ),
              Divider(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(SwiftleadTokens.errorRed)),
                title: const Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
                onTap: () {
                  Navigator.pop(context);
                  // Delete confirmed via swipe
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    if (_currentFilters == null || _activeFilters == 0) {
      return const SizedBox.shrink();
    }

    final activeFilters = <ActiveFilter>[];

    // Status filters
    if (_currentFilters!.statusFilters.isNotEmpty && 
        !_currentFilters!.statusFilters.contains('All')) {
      for (final status in _currentFilters!.statusFilters) {
        activeFilters.add(ActiveFilter(
          label: 'Status',
          value: status,
          onRemove: () {
            setState(() {
              _currentFilters!.statusFilters.remove(status);
              if (_currentFilters!.statusFilters.isEmpty) {
                _currentFilters!.statusFilters.add('All');
              }
              _activeFilters = _countActiveFilters(_currentFilters!);
              if (_activeFilters == 0) {
                _currentFilters = null;
              }
              _applyFilter();
            });
          },
        ));
      }
    }

    // Service type filters
    if (_currentFilters!.serviceTypeFilters.isNotEmpty && 
        !_currentFilters!.serviceTypeFilters.contains('All')) {
      for (final type in _currentFilters!.serviceTypeFilters) {
        activeFilters.add(ActiveFilter(
          label: 'Service',
          value: type,
          onRemove: () {
            setState(() {
              _currentFilters!.serviceTypeFilters.remove(type);
              if (_currentFilters!.serviceTypeFilters.isEmpty) {
                _currentFilters!.serviceTypeFilters.add('All');
              }
              _activeFilters = _countActiveFilters(_currentFilters!);
              if (_activeFilters == 0) {
                _currentFilters = null;
              }
              _applyFilter();
            });
          },
        ));
      }
    }

    // Date range filter
    if (_currentFilters!.dateRange != 'All Time') {
      activeFilters.add(ActiveFilter(
        label: 'Date',
        value: _currentFilters!.dateRange,
        onRemove: () {
          setState(() {
            _currentFilters!.dateRange = 'All Time';
            _activeFilters = _countActiveFilters(_currentFilters!);
            if (_activeFilters == 0) {
              _currentFilters = null;
            }
            _applyFilter();
          });
        },
      ));
    }

    return ActiveFilterChipsRow(
      filters: activeFilters,
      onClearAll: () {
        setState(() {
          _currentFilters = null;
          _activeFilters = 0;
          _applyFilter();
        });
      },
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final filters = await JobsFilterSheet.show(
      context: context,
      initialFilters: _currentFilters,
    );
    print('[JOBS FILTER] Filter sheet returned: ${filters?.statusFilters} | ${filters?.serviceTypeFilters} | ${filters?.dateRange}');
    if (filters != null && mounted) {
      setState(() {
        _currentFilters = filters;
        _activeFilters = _countActiveFilters(filters);
        print('[JOBS FILTER] Setting filters: activeFilters=$_activeFilters, status=${filters.statusFilters}, serviceType=${filters.serviceTypeFilters}, dateRange=${filters.dateRange}');
        _applyFilter();
      });
    } else if (filters == null && _currentFilters != null && mounted) {
      // Clear filters if user cancelled
      setState(() {
        _currentFilters = null;
        _activeFilters = 0;
        _applyFilter();
      });
    } else if (filters != null && _countActiveFilters(filters) == 0 && mounted) {
      // Filters were cleared (all set to 'All')
      setState(() {
        _currentFilters = null;
        _activeFilters = 0;
        _applyFilter();
      });
    }
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
          _createPageRoute(const CreateEditJobScreen()),
        );
        break;
      case 'create_booking':
        Navigator.push(
          context,
          _createPageRoute(const CreateEditBookingScreen()),
        );
        break;
      case 'send_invoice':
        Navigator.push(
          context,
          _createPageRoute(const CreateEditInvoiceScreen()),
        );
        break;
      case 'payment_link':
        // TODO: Navigate to payment link screen when implemented
        Toast.show(
          context,
          message: 'Payment link feature coming soon',
          type: ToastType.info,
        );
        break;
      case 'add_contact':
        Navigator.push(
          context,
          _createPageRoute(const CreateEditContactScreen()),
        );
        break;
      case 'new_message':
        // TODO: Navigate to compose message screen when implemented
        Toast.show(
          context,
          message: 'Compose message feature coming soon',
          type: ToastType.info,
        );
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
    // Phase 3: Keyboard shortcuts wrapper
    return Shortcuts(
      shortcuts: AppShortcuts.getJobsShortcuts(() {
        // Create new job
        Navigator.push(
          context,
          _createPageRoute(const CreateEditJobScreen()),
        );
      }),
      child: Actions(
        actions: {
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                _createPageRoute(const JobSearchScreen()),
              );
            },
          ),
          CreateJobIntent: CallbackAction<CreateJobIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                _createPageRoute(const CreateEditJobScreen()),
              );
            },
          ),
          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) {
              _loadJobs();
            },
          ),
          CloseIntent: CallbackAction<CloseIntent>(
            onInvoke: (_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: ProfessionState.config.getLabel('Jobs'),
        actions: [
          // Primary action: Add Job
          Semantics(
            label: 'Add job',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Job',
              onPressed: () async {
                final action = await JobsQuickActionsSheet.show(context: context);
                if (action != null && mounted) {
                  _handleQuickAction(action);
                }
              },
            ),
          ),
          // More menu for secondary actions (iOS-aligned: max 2 icons)
          Semantics(
            label: 'More options',
            button: true,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'More',
              onSelected: (value) {
              switch (value) {
                case 'filter':
                  _showFilterSheet(context);
                  break;
                case 'search':
                  Navigator.push(
                    context,
                    _createPageRoute(const JobSearchScreen()),
                  );
                  break;
                case 'sort':
                  _showSortMenu(context);
                  break;
                // Kanban view removed - keeping list view as primary
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.filter_list_outlined, size: 20),
                        if (_activeFilters > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(SwiftleadTokens.spaceXXS),
                              decoration: const BoxDecoration(
                                color: Color(SwiftleadTokens.primaryTeal),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '$_activeFilters',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      'Filter${_activeFilters > 0 ? ' ($_activeFilters)' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'search',
                child: Builder(
                  builder: (context) => Row(
                  children: [
                      const Icon(Icons.search_outlined, size: 20),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        'Search',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'sort',
                child: Builder(
                  builder: (context) => Row(
                  children: [
                      const Icon(Icons.sort, size: 20),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        'Sort',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                  ),
                ),
              ),
              // Kanban view toggle removed - list view is the primary view
            ],
            ),
          ),
        ],
      ),
            body: _isLoading
                ? _buildLoadingState()
                : _buildContent(),
          ),
        ),
      ),
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
        // Celebration banner (if milestone reached)
        if (_celebrationMessage != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: SwiftleadTokens.spaceM,
              right: SwiftleadTokens.spaceM,
              top: SwiftleadTokens.spaceM,
            ),
            child: CelebrationBanner(
              message: _celebrationMessage!,
              onDismiss: () {
                setState(() => _celebrationMessage = null);
              },
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
        ],
        
        // Quick Stats Summary (Visual Enhancement)
        if (_filteredJobs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
            child: _buildQuickStatsSummary(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
        ],
        
        // Active Filter Chips Row
        if (_currentFilters != null && _activeFilters > 0)
          _buildActiveFilterChips(),
        
        // Phase 2: AI Insight Banner - Predictive insights
        if (_filteredJobs.isNotEmpty && !_aiInsightDismissed) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
            child: Builder(
              builder: (context) {
                final activeJobs = _filteredJobs.where((j) => 
                  j.status == JobStatus.inProgress || j.status == JobStatus.booked
                ).length;
                final overdueJobs = _filteredJobs.where((j) => 
                  j.status == JobStatus.inProgress && 
                  j.scheduledDate != null && 
                  j.scheduledDate!.isBefore(DateTime.now())
                ).length;
                
                String? insight;
                VoidCallback? onTap;
                if (overdueJobs > 0) {
                  insight = 'You have $overdueJobs overdue jobs. Consider updating due dates or delegating.';
                  onTap = () {
                    // Filter to show overdue jobs
                    // Note: JobsFilters constructor may need adjustment
                    _applyFilter();
                  };
                } else if (activeJobs > 10) {
                  insight = 'You have $activeJobs active jobs. Consider using templates to speed up workflow.';
                }
                
                if (insight != null) {
                  return AIInsightBanner(
                    message: insight,
                    onTap: onTap,
                    onDismiss: () {
                      setState(() {
                        _aiInsightDismissed = true;
                      });
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
        ],
        
        // View Mode Toggle - Hidden by default, can be enabled in settings if needed
        // Removed to simplify UI - List view is the default and primary view
        // PipelineTabs - SegmentedControl with counts
        Padding(
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
        
        // JobCardList - Card grid with rich information OR Kanban board
        // Desktop: Always show grid, Mobile: Respect view mode
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadJobs();
            },
            child: ResponsiveLayout.isDesktop(context)
                ? _buildDesktopGridView()
                : _buildJobList(),
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
        onAction: _selectedTabIndex == 0 ? () {
          Navigator.push(
            context,
            _createPageRoute(const CreateEditJobScreen()),
          );
        } : null,
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
      cacheExtent: 200, // Cache items for better performance
      itemBuilder: (context, index) {
        final job = _filteredJobs[index];
        // Phase 3: Staggered animation delay with spring physics
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
          curve: SpringAnimation.smooth,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Dismissible(
            key: Key(job.id),
            background: Container(
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.successGreen),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: SwiftleadTokens.spaceM),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 32,
              ),
            ),
            secondaryBackground: Container(
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.errorRed),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: SwiftleadTokens.spaceM),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // Mark complete
                // TODO: Implement mark complete
              } else {
                // Delete
                // TODO: Implement delete
              }
              setState(() {
                _filteredJobs.removeAt(index);
              });
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
              // Confirm delete
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Job'),
                  content: const Text('Are you sure you want to delete this job?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(SwiftleadTokens.errorRed),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
                return confirmed ?? false;
              }
              return true;
            },
          child: Semantics(
            label: 'Job ${job.title}. Long press for options.',
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                _showJobContextMenu(context, job);
              },
              onSecondaryTap: () {
                HapticFeedback.mediumImpact();
                _showJobContextMenu(context, job);
              },
              child: Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: JobCard(
                jobTitle: job.title,
                clientName: job.contactName ?? '',
                serviceType: job.serviceType ?? '',
                status: job.status.displayName,
                dueDate: job.scheduledDate,
                price: '£${job.value.toStringAsFixed(2)}',
                onTap: () {
                  _trackJobInteraction(job.id);
                  Navigator.push(
                    context,
                    _createPageRoute(JobDetailScreen(
                      jobId: job.id,
                      jobTitle: job.title,
                    )),
                  );
                },
              ),
            ),
            ),
          ),
          ),
        );
      },
    );
  }

  /// Desktop Grid View - Responsive grid layout for desktop
  Widget _buildDesktopGridView() {
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
        onAction: _selectedTabIndex == 0 ? () {
          Navigator.push(
            context,
            _createPageRoute(const CreateEditJobScreen()),
          );
        } : null,
      );
    }

    final columnCount = ResponsiveLayout.getColumnCount(context);
    final gutter = ResponsiveLayout.getGutter(context);

    return ResponsiveGrid(
      children: _filteredJobs.map((job) {
        return JobCard(
          jobTitle: job.title,
          clientName: job.contactName ?? '',
          serviceType: job.serviceType ?? '',
          status: job.status.displayName,
          dueDate: job.scheduledDate,
          price: '£${job.value.toStringAsFixed(2)}',
          onTap: () {
            _trackJobInteraction(job.id);
            Navigator.push(
              context,
              _createPageRoute(JobDetailScreen(
                jobId: job.id,
                jobTitle: job.title,
              )),
            );
          },
        );
      }).toList(),
      childAspectRatio: 1.1,
      crossAxisSpacing: gutter,
      mainAxisSpacing: gutter,
    );
  }

  Widget _buildKanbanView() {
    // Group jobs by status
    final proposedJobs = _filteredJobs.where((j) => j.status == JobStatus.proposed).toList();
    final bookedJobs = _filteredJobs.where((j) => j.status == JobStatus.booked).toList();
    final inProgressJobs = _filteredJobs.where((j) => j.status == JobStatus.inProgress).toList();
    final completedJobs = _filteredJobs.where((j) => j.status == JobStatus.completed).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: constraints.maxHeight,
            child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                _buildKanbanColumn('Proposed', proposedJobs, constraints.maxHeight),
                _buildKanbanColumn('Booked', bookedJobs, constraints.maxHeight),
                _buildKanbanColumn('In Progress', inProgressJobs, constraints.maxHeight),
                _buildKanbanColumn('Completed', completedJobs, constraints.maxHeight),
      ],
            ),
          ),
    );
      },
    );
  }

  Widget _buildKanbanColumn(String title, List<Job> jobs, double maxHeight) {
    // Determine target status based on column title
    JobStatus? targetStatus;
    switch (title) {
      case 'Proposed':
        targetStatus = JobStatus.proposed;
        break;
      case 'Booked':
        targetStatus = JobStatus.booked;
        break;
      case 'In Progress':
        targetStatus = JobStatus.inProgress;
        break;
      case 'Completed':
        targetStatus = JobStatus.completed;
        break;
    }

    return SizedBox(
      width: 320, // Wider to accommodate card content with padding
      child: Container(
        margin: const EdgeInsets.only(left: SwiftleadTokens.spaceS, right: SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withOpacity(0.3),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Column header
            Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  SwiftleadBadge(
                    label: jobs.length.toString(),
                    variant: BadgeVariant.secondary,
                    size: BadgeSize.small,
                  ),
                ],
              ),
            ),
            // Jobs in this column with drag-drop support
            Flexible(
              child: DragTarget<Job>(
                onWillAccept: (data) {
                  // Haptic feedback when dragging over column
                  if (data != null && targetStatus != null && data.status != targetStatus) {
                    app_haptics.HapticFeedback.light();
                  }
                  return data != null && targetStatus != null;
                },
                onAccept: (draggedJob) {
                  // Update job status when dropped on column
                  if (targetStatus != null && draggedJob.status != targetStatus) {
                    setState(() {
                      final jobIndex = _allJobs.indexWhere((j) => j.id == draggedJob.id);
                      if (jobIndex != -1) {
                        // Create updated job with new status
                        _allJobs[jobIndex] = Job(
                          id: draggedJob.id,
                          orgId: draggedJob.orgId,
                          title: draggedJob.title,
                          contactId: draggedJob.contactId,
                          contactName: draggedJob.contactName,
                          jobType: draggedJob.jobType,
                          serviceType: draggedJob.serviceType,
                          description: draggedJob.description,
                          status: targetStatus!,
                          priority: draggedJob.priority,
                          priceEstimate: draggedJob.priceEstimate,
                          startTime: draggedJob.startTime,
                          endTime: draggedJob.endTime,
                          location: draggedJob.location,
                          createdAt: draggedJob.createdAt,
                          completedAt: draggedJob.completedAt,
                          assignedTo: draggedJob.assignedTo,
                        );
                        _applyFilter();
                        app_haptics.HapticFeedback.success();
                        Toast.show(
                          context,
                          message: 'Job moved to $title',
                          type: ToastType.success,
                        );
                      }
                    });
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    child: SizedBox(
                      height: maxHeight - 80, // Subtract header height
              child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
                itemCount: jobs.length,
                        cacheExtent: 200, // Cache items for better performance
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Draggable<Job>(
                                  data: job,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Opacity(
                                      opacity: 0.9,
                                      child: Container(
                                        width: constraints.maxWidth,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: JobCard(
                      jobTitle: job.title,
                      clientName: job.contactName ?? '',
                      serviceType: job.serviceType ?? '',
                      status: job.status.displayName,
                      dueDate: job.scheduledDate,
                      price: job.value > 0 ? '£${job.value.toStringAsFixed(2)}' : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      child: JobCard(
                                        jobTitle: job.title,
                                        clientName: job.contactName ?? '',
                                        serviceType: job.serviceType ?? '',
                                        status: job.status.displayName,
                                        dueDate: job.scheduledDate,
                                        price: job.value > 0 ? '£${job.value.toStringAsFixed(2)}' : null,
                                      ),
                                    ),
                                  ),
                                  onDragStarted: () {
                                    app_haptics.HapticFeedback.dragStart();
                                  },
                                  onDragEnd: (details) {
                                    app_haptics.HapticFeedback.dragEnd();
                                  },
                                  child: Semantics(
                                    label: 'Job ${job.title}, ${job.contactName ?? ''}, ${job.status.displayName}${job.value > 0 ? ", £${job.value.toStringAsFixed(2)}" : ""}',
                                    button: true,
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      child: JobCard(
                                        jobTitle: job.title,
                                        clientName: job.contactName ?? '',
                                        serviceType: job.serviceType ?? '',
                                        status: job.status.displayName,
                                        dueDate: job.scheduledDate,
                                        price: job.value > 0 ? '£${job.value.toStringAsFixed(2)}' : null,
                      onTap: () {
                                          _trackJobInteraction(job.id);
                        Navigator.push(
                          context,
                          _createPageRoute(JobDetailScreen(
                            jobId: job.id,
                            jobTitle: job.title,
                          )),
                        );
                      },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSummary() {
    final activeJobs = _filteredJobs.where((j) => 
      j.status == JobStatus.inProgress || j.status == JobStatus.booked
    ).length;
    final completedJobs = _filteredJobs.where((j) => 
      j.status == JobStatus.completed
    ).length;
    final totalValue = _filteredJobs.fold<double>(
      0.0,
      (sum, job) => sum + (job.value ?? 0.0),
    );

    return Container(
      height: 161, // Slightly increased to prevent overflow
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E88E5), // Rich blue
            Color(SwiftleadTokens.infoBlue),
            Color(SwiftleadTokens.successGreen),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        boxShadow: [
          BoxShadow(
            color: const Color(SwiftleadTokens.infoBlue).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(SwiftleadTokens.infoBlue).withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jobs Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      'Track your work pipeline',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.95),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total',
                  '${_filteredJobs.length}',
                  Icons.work_outline,
                  Colors.white,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Active',
                  '$activeJobs',
                  Icons.play_circle_outline,
                  Colors.white,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Value',
                  '£${totalValue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.95),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
