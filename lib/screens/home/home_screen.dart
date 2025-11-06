import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../widgets/components/quick_action_chip.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../settings/settings_screen.dart';
import '../main_navigation.dart' as main_nav;
import '../../widgets/forms/on_my_way_sheet.dart';
import '../jobs/create_edit_job_screen.dart';
import '../money/money_screen.dart';
import '../calendar/create_edit_booking_screen.dart';
import '../calendar/calendar_screen.dart';
import '../ai_hub/ai_hub_screen.dart';
import '../../widgets/global/info_banner.dart';
import '../../mock/mock_bookings.dart';
import '../../models/booking.dart';
import '../reports/goal_tracking_screen.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/automation_stats_card.dart';
import '../../widgets/components/animated_counter.dart';
import '../../widgets/components/metric_detail_sheet.dart';
import '../../widgets/components/celebration_banner.dart';
import '../../widgets/components/smart_collapsible_section.dart';
import '../../widgets/components/context_menu.dart';

/// HomeScreen - Dashboard hub
/// Exact specification from Screen_Layouts_v2.5.1
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _showAIBanner = true;
  
  // Progressive loading states
  bool _criticalMetricsLoaded = false;
  bool _chartsLoaded = false;
  bool _feedLoaded = false;

  // Dashboard metrics from mock data
  double _totalRevenue = 0;
  int _activeJobs = 0;
  int _unreadMessages = 0;
  double _conversionRate = 0;
  int _todayBookings = 0;
  double _pendingPayments = 0;
  
  // Previous period values for comparison
  double _previousRevenue = 0;
  int _previousActiveJobs = 0;
  int _previousUnreadMessages = 0;
  double _previousConversionRate = 0;
  
  // Date range selector for metrics
  String _selectedMetricPeriod = '30D';
  
  // Upcoming bookings
  List<Booking> _upcomingBookings = [];
  
  // Goal tracking summary
  Map<String, dynamic> _goalSummary = {
    'totalGoals': 3,
    'completedGoals': 0,
    'onTrackGoals': 2,
    'revenueProgress': 0.85,
    'jobsProgress': 0.70,
  };
  
  // Automation impact metrics
  Map<String, dynamic> _automationStats = {
    'timeSavedHours': 0.0,
    'actionsCompleted': 0,
    'successRate': 0,
    'costSaved': 0.0,
  };
  
  // PageController for swipeable cards
  final PageController _automationPageController = PageController();
  int _currentAutomationPage = 0;
  
  // Progressive disclosure states
  bool _weatherExpanded = true;
  bool _goalsExpanded = true;
  bool _scheduleExpanded = true;
  
  // Smart prioritization tracking
  final Map<String, int> _metricTapCounts = {};
  final Map<String, DateTime> _metricLastViewed = {};
  
  // Celebration tracking
  final Set<String> _milestonesShown = {};
  
  // Scroll controller for sticky headers and parallax
  final ScrollController _scrollController = ScrollController();
  
  // Predicted values
  double _predictedRevenue = 0;
  
  // User behavior tracking for smart defaults
  String? _userRole; // Will be determined from settings or user profile

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  void dispose() {
    _automationPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Loading state for metrics only (when period changes)
  bool _metricsLoading = false;

  // Progressive loading for instant perceived performance
  Future<void> _loadDashboardData({bool isPeriodChange = false}) async {
    if (!isPeriodChange) {
      setState(() {
        _isLoading = true;
        _criticalMetricsLoaded = false;
        _chartsLoaded = false;
        _feedLoaded = false;
      });
    } else {
      // Only set metrics loading state, don't reload entire screen
      setState(() {
        _metricsLoading = true;
      });
    }

    if (kUseMockData) {
      // Phase 1: Load critical metrics first (instant perceived speed)
      final revenueStats = await MockPayments.getRevenueStats();
      _totalRevenue = revenueStats.totalRevenue;
      _pendingPayments = revenueStats.outstanding;
      
      // Calculate previous period for comparison
      _previousRevenue = _totalRevenue * 0.88; // Mock: 12% growth

      final jobsByStatus = await MockJobs.getCountByStatus();
      _activeJobs = (jobsByStatus[JobStatus.inProgress] ?? 0) +
                    (jobsByStatus[JobStatus.scheduled] ?? 0);
      _previousActiveJobs = (_activeJobs * 0.8).toInt(); // Mock: 20% growth

      _unreadMessages = await MockMessages.getUnreadCount();
      _previousUnreadMessages = (_unreadMessages * 1.1).toInt(); // Mock

      final todayBookings = await MockBookings.fetchToday();
      _todayBookings = todayBookings.length;

      // Mock conversion rate
      _conversionRate = 68.0;
      _previousConversionRate = 63.0; // Mock: 5% improvement
      
      // Calculate predicted revenue
      final daysInMonth = DateTime.now().day;
      final dailyAverage = _totalRevenue / daysInMonth;
      final remainingDays = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - daysInMonth;
      _predictedRevenue = _totalRevenue + (dailyAverage * remainingDays);
      
      if (mounted) {
        setState(() {
          _criticalMetricsLoaded = true;
          _chartsLoaded = true; // Load charts immediately too
          _isLoading = false; // Show UI immediately
          _metricsLoading = false; // Clear metrics loading
        });
      }
      
      // Phase 2: Load charts (fast, non-blocking)
      await Future.delayed(const Duration(milliseconds: 100));
      final upcoming = await MockBookings.getUpcoming();
      _upcomingBookings = upcoming.take(3).toList();
      
      // Load goal summary (mock)
      _goalSummary = {
        'totalGoals': 3,
        'completedGoals': 0,
        'onTrackGoals': 2,
        'revenueProgress': 0.85,
        'jobsProgress': 0.70,
      };
      
      // Load automation stats (mock - in production would come from backend)
      _automationStats = {
        'timeSavedHours': 24.5,
        'actionsCompleted': 142,
        'successRate': 94,
        'costSaved': 367.5,
      };

    if (mounted) {
        setState(() => _chartsLoaded = true);
      }
      
      // Phase 3: Load feed (can wait)
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() => _feedLoaded = true);
      }
      
      // Check for milestones
      _checkForMilestones();
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
  
  // Helper methods for 10/10 features
  
  // Check for milestones and show celebrations
  void _checkForMilestones() {
    if (_totalRevenue >= 10000 && !_milestonesShown.contains('10k')) {
      _milestonesShown.add('10k');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showCelebration('🎉 You hit £10k revenue!');
        }
      });
    }
    
    if (_activeJobs >= 50 && !_milestonesShown.contains('50jobs')) {
      _milestonesShown.add('50jobs');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showCelebration('🚀 50 active jobs! Amazing work!');
        }
      });
    }
    
    if (_automationStats['actionsCompleted'] >= 100 && !_milestonesShown.contains('100actions')) {
      _milestonesShown.add('100actions');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showCelebration('⚡ 100+ automated actions completed!');
        }
      });
    }
  }
  
  void _showCelebration(String message) {
    // Celebration will be shown in the UI
    setState(() {
      _celebrationMessage = message;
    });
  }
  
  String? _celebrationMessage;
  
  // Calculate smart priority for metrics
  double _calculateMetricPriority(String metricId) {
    final tapCount = _metricTapCounts[metricId] ?? 0;
    final lastViewed = _metricLastViewed[metricId];
    final hoursSinceViewed = lastViewed != null
        ? DateTime.now().difference(lastViewed).inHours
        : 999;
    
    return (tapCount * 0.4) + 
           ((999 - hoursSinceViewed) / 100) + 
           (metricId == 'Revenue' ? 0.3 : 0.0); // Revenue is always important
  }
  
  // Track metric interaction
  void _trackMetricInteraction(String metricId) {
    setState(() {
      _metricTapCounts[metricId] = (_metricTapCounts[metricId] ?? 0) + 1;
      _metricLastViewed[metricId] = DateTime.now();
    });
  }
  
  // Check if weather should be shown
  bool _shouldShowWeather() {
    final hour = DateTime.now().hour;
    final hasOutdoorJobs = _upcomingBookings.any((b) {
      // Mock: assume some bookings are outdoor
      return b.serviceType.toLowerCase().contains('outdoor') ||
             b.serviceType.toLowerCase().contains('garden') ||
             b.serviceType.toLowerCase().contains('roof');
    });
    
    // Hide if evening/night and no outdoor jobs
    if (hour >= 18 && !hasOutdoorJobs) return false;
    
    // Hide if no upcoming outdoor jobs
    if (!hasOutdoorJobs && _upcomingBookings.isEmpty) return false;
    
    return true;
  }
  
  // Show metric detail sheet
  void _showMetricDetail(String metricId) {
    _trackMetricInteraction(metricId);
    HapticFeedback.mediumImpact();
    
    switch (metricId) {
      case 'Revenue':
        MetricDetailSheet.show(
          context: context,
          title: 'Revenue Details',
          currentValue: '£${_totalRevenue.toStringAsFixed(0)}',
          previousValue: '£${_previousRevenue.toStringAsFixed(0)}',
          trendPercentage: ((_totalRevenue - _previousRevenue) / _previousRevenue) * 100,
          chartData: [
            _previousRevenue * 0.5,
            _previousRevenue * 0.6,
            _previousRevenue * 0.7,
            _previousRevenue * 0.8,
            _previousRevenue * 0.9,
            _previousRevenue * 0.95,
            _totalRevenue,
          ],
          chartLabel: 'Revenue (£)',
          period: _selectedMetricPeriod,
          breakdown: {
            'Invoices': '£${(_totalRevenue * 0.7).toStringAsFixed(0)}',
            'Payments': '£${(_totalRevenue * 0.3).toStringAsFixed(0)}',
          },
        );
        break;
      case 'Active Jobs':
        MetricDetailSheet.show(
          context: context,
          title: 'Active Jobs Details',
          currentValue: '$_activeJobs',
          previousValue: '$_previousActiveJobs',
          trendPercentage: ((_activeJobs - _previousActiveJobs) / _previousActiveJobs) * 100,
          chartData: [
            _previousActiveJobs * 0.6,
            _previousActiveJobs * 0.7,
            _previousActiveJobs * 0.8,
            _previousActiveJobs * 0.85,
            _previousActiveJobs * 0.9,
            _previousActiveJobs * 0.95,
            _activeJobs.toDouble(),
          ],
          chartLabel: 'Jobs',
          period: _selectedMetricPeriod,
        );
        break;
      case 'Messages':
        MetricDetailSheet.show(
          context: context,
          title: 'Messages Details',
          currentValue: '$_unreadMessages',
          previousValue: '$_previousUnreadMessages',
          chartData: [
            (_previousUnreadMessages * 0.2).toDouble(),
            (_previousUnreadMessages * 0.4).toDouble(),
            (_previousUnreadMessages * 0.6).toDouble(),
            (_previousUnreadMessages * 0.7).toDouble(),
            (_previousUnreadMessages * 0.8).toDouble(),
            (_previousUnreadMessages * 0.9).toDouble(),
            _unreadMessages.toDouble(),
          ],
          chartLabel: 'Messages',
          period: _selectedMetricPeriod,
        );
        break;
      case 'Conversion':
        MetricDetailSheet.show(
          context: context,
          title: 'Conversion Rate Details',
          currentValue: '${_conversionRate.toInt()}%',
          previousValue: '${_previousConversionRate.toInt()}%',
          trendPercentage: _conversionRate - _previousConversionRate,
          chartData: [55, 58, 60, 62, 65, 66, _conversionRate],
          chartLabel: 'Conversion (%)',
          period: _selectedMetricPeriod,
        );
        break;
    }
  }
  
  // Show context menu for metric
  void _showMetricContextMenu(String metricId, Offset position) {
    HapticFeedback.heavyImpact();
    ContextMenu.show(
      context: context,
      position: position,
      actions: [
        ContextMenuAction(
          label: 'View Details',
          icon: Icons.info_outline,
          onTap: () => _showMetricDetail(metricId),
        ),
        ContextMenuAction(
          label: 'Compare Periods',
          icon: Icons.compare_arrows,
          onTap: () {
            // Show comparison view
            _showMetricDetail(metricId);
          },
        ),
        ContextMenuAction(
          label: 'Export Data',
          icon: Icons.download,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export functionality coming soon')),
            );
          },
        ),
        ContextMenuAction(
          label: 'Share',
          icon: Icons.share,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon')),
            );
          },
        ),
      ],
    );
  }

  void _handleProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onThemeChanged: (_) {},
          currentThemeMode: ThemeMode.system,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: '${_getGreeting()}, Alex',
        profileIcon: IconButton(
          icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person,
              size: 18,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            _handleProfileTap();
          },
        ),
        notificationBadgeCount: 3,
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
        // Metrics skeleton (2x2 grid)
        Row(
          children: List.generate(2, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? 8.0 : 0.0),
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
              padding: EdgeInsets.only(right: i == 0 ? 8.0 : 0.0),
              child: SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          )),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Tile grid skeleton
        Row(
          children: List.generate(2, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i == 0 ? 8 : 0,
                bottom: 8,
              ),
              child: SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          )),
        ),
        Row(
          children: List.generate(2, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? 8 : 0),
              child: SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          )),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Chart skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        await _loadDashboardData();
      },
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96,
        ),
        children: [
          // Celebration banner (if milestone reached)
          if (_celebrationMessage != null) ...[
            CelebrationBanner(
              message: _celebrationMessage!,
              onDismiss: () {
                setState(() => _celebrationMessage = null);
              },
            ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          ],
          
          // Swipeable Cards: Today's Summary + Automation Insights
          _buildChartCard(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Time Range Selector
          _buildDateRangeSelector(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // MetricsRow with TrendTile (sparklines, tooltips, animated counters)
          _buildMetricsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Predictive Insights
          if (_predictedRevenue > 0) ...[
            _buildPredictiveInsight(),
            const SizedBox(height: SwiftleadTokens.spaceL),
          ],
          
          // AIInsightBanner (urgent alerts first - if present)
          if (_showAIBanner) ...[
            AIInsightBanner(
              message: 'AI found 3 unconfirmed bookings — confirm now?',
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  _createPageRoute(const CalendarScreen()),
                ).then((_) {
                  if (mounted) {
                    setState(() => _showAIBanner = false);
                  }
                });
              },
              onDismiss: () {
                HapticFeedback.lightImpact();
                setState(() => _showAIBanner = false);
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
          ],

          // Upcoming Schedule Widget (actionable today) - Collapsible
          SmartCollapsibleSection(
            title: 'Upcoming Schedule',
            initiallyExpanded: _scheduleExpanded,
            onExpandedChanged: () {
              HapticFeedback.selectionClick();
            },
            child: _buildUpcomingScheduleContent(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Weather Widget (context for outdoor work) - Collapsible & Contextual
          if (_shouldShowWeather()) ...[
            SmartCollapsibleSection(
              title: 'Weather Forecast',
              initiallyExpanded: _weatherExpanded,
              onExpandedChanged: () {
                HapticFeedback.selectionClick();
              },
              child: _buildWeatherContent(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
          ],
          
          // Goal Tracking Summary (analytics/progress) - Collapsible
          SmartCollapsibleSection(
            title: 'Goal Progress',
            initiallyExpanded: _goalsExpanded,
            onExpandedChanged: () {
              HapticFeedback.selectionClick();
            },
            child: _buildGoalTrackingContent(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // QuickActionChipsRow (common tasks)
          _buildQuickActionChipsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // ActivityFeed (recent activity)
          _buildActivityFeed(),
        ],
      ),
    );
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
  
  // Sticky metrics section
  Widget _buildStickyMetricsSection() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickMetric('Revenue', '£${_totalRevenue.toStringAsFixed(0)}', 'Revenue'),
          _buildQuickMetric('Jobs', '$_activeJobs', 'Active Jobs'),
          _buildQuickMetric('Messages', '$_unreadMessages', 'Messages'),
        ],
      ),
    );
  }
  
  Widget _buildQuickMetric(String label, String value, String metricId) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showMetricDetail(metricId);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedCounter(
            value: metricId == 'Revenue' ? _totalRevenue : 
                  metricId == 'Active Jobs' ? _activeJobs.toDouble() : 
                  _unreadMessages.toDouble(),
            textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
            prefix: metricId == 'Revenue' ? '£' : '',
            decimals: metricId == 'Revenue' ? 0 : 0,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysSummaryCard() {
    return Container(
      height: 180, // Match height with automation cards
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(SwiftleadTokens.primaryTeal),
            Color(SwiftleadTokens.accentAqua),
          ],
        ),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        boxShadow: [
          BoxShadow(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Summary",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildSummaryStat(
                  'Active Jobs',
                  '$_activeJobs',
                  Icons.work_outline,
                ),
              ),
              Expanded(
                child: _buildSummaryStat(
                  'Bookings',
                  '$_todayBookings',
                  Icons.calendar_today,
                ),
              ),
              Expanded(
                child: _buildSummaryStat(
                  'Messages',
                  '$_unreadMessages',
                  Icons.inbox,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    // Show loading overlay on metrics if updating
    if (_metricsLoading) {
      return Stack(
        children: [
          _buildMetricsContent(),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    return _buildMetricsContent();
  }
  
  Widget _buildMetricsContent() {
    // Calculate trends with comparison (avoid division by zero)
    final revenueTrend = _previousRevenue > 0 
        ? ((_totalRevenue - _previousRevenue) / _previousRevenue) * 100 
        : 0.0;
    final jobsTrend = _previousActiveJobs > 0 
        ? ((_activeJobs - _previousActiveJobs) / _previousActiveJobs) * 100 
        : 0.0;
    final conversionTrend = _conversionRate - _previousConversionRate;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInteractiveTrendTile(
                metricId: 'Revenue',
                label: 'Revenue',
                currentValue: _totalRevenue,
                previousValue: _previousRevenue,
                trend: revenueTrend,
                isPositive: revenueTrend >= 0,
                sparklineData: [
                  _previousRevenue * 0.5,
                  _previousRevenue * 0.6,
                  _previousRevenue * 0.7,
                  _previousRevenue * 0.8,
                  _previousRevenue * 0.9,
                  _previousRevenue * 0.95,
                  _totalRevenue,
                ],
                tooltip: 'Total revenue from all paid invoices',
                prefix: '£',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _buildInteractiveTrendTile(
                metricId: 'Active Jobs',
                label: 'Active Jobs',
                currentValue: _activeJobs.toDouble(),
                previousValue: _previousActiveJobs.toDouble(),
                trend: jobsTrend,
                isPositive: jobsTrend >= 0,
                sparklineData: [
                  (_previousActiveJobs * 0.6).toDouble(),
                  (_previousActiveJobs * 0.7).toDouble(),
                  (_previousActiveJobs * 0.8).toDouble(),
                  (_previousActiveJobs * 0.85).toDouble(),
                  (_previousActiveJobs * 0.9).toDouble(),
                  (_previousActiveJobs * 0.95).toDouble(),
                  _activeJobs.toDouble(),
                ],
                tooltip: 'Jobs in progress or scheduled',
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: _buildInteractiveTrendTile(
                metricId: 'Messages',
                label: 'Messages',
                currentValue: _unreadMessages.toDouble(),
                previousValue: _previousUnreadMessages.toDouble(),
                trend: ((_unreadMessages - _previousUnreadMessages) / _previousUnreadMessages) * 100,
                isPositive: false,
                sparklineData: [
                  (_previousUnreadMessages * 0.2).toDouble(),
                  (_previousUnreadMessages * 0.4).toDouble(),
                  (_previousUnreadMessages * 0.6).toDouble(),
                  (_previousUnreadMessages * 0.7).toDouble(),
                  (_previousUnreadMessages * 0.8).toDouble(),
                  (_previousUnreadMessages * 0.9).toDouble(),
                  _unreadMessages.toDouble(),
                ],
                tooltip: 'Unread messages across all channels',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _buildInteractiveTrendTile(
                metricId: 'Conversion',
                label: 'Conversion',
                currentValue: _conversionRate,
                previousValue: _previousConversionRate,
                trend: conversionTrend,
                isPositive: conversionTrend >= 0,
                sparklineData: [55, 58, 60, 62, 65, 66, _conversionRate],
                tooltip: 'Quote to job conversion rate',
                suffix: '%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveTrendTile({
    required String metricId,
    required String label,
    required double currentValue,
    required double previousValue,
    required double trend,
    required bool isPositive,
    required List<double> sparklineData,
    required String tooltip,
    String? prefix,
    String? suffix,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showMetricDetail(metricId);
      },
      onLongPress: () {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final position = box?.localToGlobal(Offset.zero) ?? Offset.zero;
        _showMetricContextMenu(metricId, position);
      },
      child: FrostedContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedCounter(
              value: currentValue,
              prefix: prefix,
              suffix: suffix,
              decimals: prefix == '£' ? 0 : (suffix == '%' ? 0 : 0),
              textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (sparklineData.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 20,
                width: double.infinity,
                child: CustomPaint(
                  painter: _HomeSparklinePainter(
                    data: sparklineData,
                    color: isPositive
                        ? const Color(SwiftleadTokens.successGreen)
                        : const Color(SwiftleadTokens.errorRed),
                  ),
                ),
              ),
      ],
            if (trend != 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 12,
                    color: isPositive
                        ? const Color(SwiftleadTokens.successGreen)
                        : const Color(SwiftleadTokens.errorRed),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${trend.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isPositive
                          ? const Color(SwiftleadTokens.successGreen)
                          : const Color(SwiftleadTokens.errorRed),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'vs. last ${_selectedMetricPeriod.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  

  Widget _buildChartCard() {
    return Column(
      children: [
        // Swipeable Cards: Today's Summary + Automation Insight Cards
        SizedBox(
          height: 180, // Same height for all cards
          child: PageView.builder(
            controller: _automationPageController,
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() {
                _currentAutomationPage = index;
              });
            },
            itemCount: 5, // Today's Summary (0) + 4 Automation cards (1-4)
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                child: index == 0
                    ? _buildTodaysSummaryCard()
                    : _buildAutomationInsightCard(index - 1), // Offset by 1 for automation cards
              );
            },
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: _currentAutomationPage == index ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentAutomationPage == index
                    ? const Color(SwiftleadTokens.primaryTeal)
                    : const Color(SwiftleadTokens.primaryTeal).withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }
  
  Widget _buildAutomationInsightCard(int index) {
    // Simple version: Teal variations with colored accents
    final cards = [
      {
        'title': 'Time Saved',
        'value': '${_automationStats['timeSavedHours']}h',
        'subtitle': 'This month',
        'trend': '+12%',
        'icon': Icons.access_time,
        'accentColor': const Color(SwiftleadTokens.primaryTeal),
      },
      {
        'title': 'Actions Completed',
        'value': '${_automationStats['actionsCompleted']}',
        'subtitle': 'Automated tasks',
        'trend': '+18%',
        'icon': Icons.check_circle,
        'accentColor': const Color(SwiftleadTokens.accentAqua),
      },
      {
        'title': 'Success Rate',
        'value': '${_automationStats['successRate']}%',
        'subtitle': 'Automation accuracy',
        'trend': '+2%',
        'icon': Icons.trending_up,
        'accentColor': const Color(0xFF0FD6C7),
      },
      {
        'title': 'Cost Saved',
        'value': '£${_automationStats['costSaved'].toStringAsFixed(0)}',
        'subtitle': 'Estimated value',
        'trend': '+15%',
        'icon': Icons.savings,
        'accentColor': const Color(SwiftleadTokens.primaryTeal),
      },
    ];
    
    final card = cards[index];
    final accentColor = card['accentColor'] as Color;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AIHubScreen(),
          ),
        );
      },
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: accentColor.withOpacity(0.6),
              width: 3,
          ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    card['icon'] as IconData,
                    color: accentColor,
                    size: 20,
              ),
            ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        card['trend'] as String,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  card['title'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
                const SizedBox(height: 4),
                Text(
                  card['value'] as String,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  card['subtitle'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
        ),
      ),
    );
  }


  Widget _buildQuickActionChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickActionChip(
            label: 'On My Way',
            icon: Icons.directions_car,
            tooltip: 'Mark yourself as on the way',
            onTap: () {
              HapticFeedback.mediumImpact();
              OnMyWaySheet.show(
                context: context,
                onSendETA: (minutes) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ETA sent: ${minutes} minutes'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
          QuickActionChip(
            label: 'Add Job',
            icon: Icons.add,
            tooltip: 'Create a new job',
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                _createPageRoute(const CreateEditJobScreen()),
              );
            },
          ),
          QuickActionChip(
            label: 'Send Payment',
            customIcon: '£',
            tooltip: 'Request or send payment',
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                _createPageRoute(const MoneyScreen()),
              );
            },
          ),
          QuickActionChip(
            label: 'Book Slot',
            icon: Icons.calendar_today,
            tooltip: 'Schedule an appointment',
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                _createPageRoute(const CreateEditBookingScreen()),
              );
            },
          ),
          QuickActionChip(
            label: 'AI Insights',
            icon: Icons.auto_awesome,
            tooltip: 'View AI-powered insights',
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                _createPageRoute(const AIHubScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) => _ActivityFeedRow(
              eventType: _EventType.values[index % _EventType.values.length],
              title: _getActivityTitle(index),
              subtitle: _getActivitySubtitle(index),
              time: _getRelativeTime(index),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getActivityTitle(int index) {
    final titles = [
      'Payment received',
      'Job completed',
      'New message',
      'Booking confirmed',
      'Quote sent',
    ];
    return titles[index % titles.length];
  }
  
  String _getActivitySubtitle(int index) {
    final subtitles = [
      '£150 from John Smith',
      'Kitchen sink repair',
      'From Sarah Williams',
      'Tomorrow 2:00 PM',
      'To Mike Johnson',
    ];
    return subtitles[index % subtitles.length];
  }
  
  String _getRelativeTime(int index) {
    final times = [
      'Just now',
      '2 hours ago',
      'Yesterday',
      '2 days ago',
      '3 days ago',
    ];
    return times[index % times.length];
  }
  
  // Date Range Selector for Metrics
  Widget _buildDateRangeSelector() {
    final periods = ['7D', '30D', '90D'];
    final selectedIndex = periods.indexOf(_selectedMetricPeriod);
    
    return SegmentedControl(
      segments: periods,
      selectedIndex: selectedIndex >= 0 ? selectedIndex : 1,
      onSelectionChanged: (index) {
        HapticFeedback.selectionClick();
        final newPeriod = periods[index];
        if (newPeriod != _selectedMetricPeriod) {
          // Optimistic update - change period immediately
          setState(() {
            _selectedMetricPeriod = newPeriod;
          });
          // Update metrics in background without full reload
          _updateMetricsForPeriod(newPeriod);
        }
      },
    );
  }
  
  // Lightweight method to update only metrics for period change
  Future<void> _updateMetricsForPeriod(String period) async {
    setState(() {
      _metricsLoading = true;
    });
    
    // Simulate API call delay (in production, this would be actual API call)
    await Future.delayed(const Duration(milliseconds: 150));
    
    if (kUseMockData) {
      // Calculate period-specific multipliers (mock data)
      double periodMultiplier;
      switch (period) {
        case '7D':
          periodMultiplier = 0.23; // ~7 days of 30-day month
          break;
        case '90D':
          periodMultiplier = 3.0; // 90 days
          break;
        default: // 30D
          periodMultiplier = 1.0;
      }
      
      // Update only metrics, not entire dashboard
      final revenueStats = await MockPayments.getRevenueStats();
      _totalRevenue = revenueStats.totalRevenue * periodMultiplier;
      _previousRevenue = _totalRevenue * 0.88;

      final jobsByStatus = await MockJobs.getCountByStatus();
      _activeJobs = ((jobsByStatus[JobStatus.inProgress] ?? 0) +
                    (jobsByStatus[JobStatus.scheduled] ?? 0) * periodMultiplier).toInt();
      _previousActiveJobs = (_activeJobs * 0.8).toInt();

      _unreadMessages = (await MockMessages.getUnreadCount() * periodMultiplier).toInt();
      _previousUnreadMessages = (_unreadMessages * 1.1).toInt();

      // Recalculate predicted revenue
      final daysInMonth = DateTime.now().day;
      final dailyAverage = _totalRevenue / (period == '7D' ? 7 : period == '90D' ? 90 : daysInMonth);
      final remainingDays = period == '7D' ? 7 - DateTime.now().weekday : 
                          period == '90D' ? 90 - daysInMonth : 
                          DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - daysInMonth;
      _predictedRevenue = _totalRevenue + (dailyAverage * remainingDays);
    }
    
    if (mounted) {
      setState(() {
        _metricsLoading = false;
      });
    }
  }
  
  // Predictive Insight Widget
  Widget _buildPredictiveInsight() {
    return AIInsightBanner(
      message: 'Based on current trends, you\'re on track for £${_predictedRevenue.toStringAsFixed(0)} this month',
      onTap: () {
        HapticFeedback.mediumImpact();
        // Could navigate to detailed forecast
      },
      onDismiss: () {
        // Hide predictive insight
      },
    );
  }
  
  // Weather Widget Content (for collapsible)
  Widget _buildWeatherContent() {
    // Mock weather data - in production, this would fetch from weather API
    final mockWeather = {
      'condition': 'Partly Cloudy',
      'temperature': 18,
      'icon': Icons.wb_cloudy,
      'precipitation': 10,
      'wind': 15,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '${mockWeather['temperature']}°C',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
                Text(
                  mockWeather['condition'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 16, color: Color(SwiftleadTokens.primaryTeal)),
                    const SizedBox(width: SwiftleadTokens.spaceXS),
                    Text(
                      '${mockWeather['precipitation']}% chance',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceXS),
                Row(
                  children: [
                    const Icon(Icons.air, size: 16, color: Color(SwiftleadTokens.primaryTeal)),
                    const SizedBox(width: SwiftleadTokens.spaceXS),
                    Text(
                      '${mockWeather['wind']} km/h wind',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ],
          ),
              ],
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        InfoBanner(
          message: 'Weather forecast for today. Consider rescheduling outdoor jobs if conditions are unfavorable.',
          type: InfoBannerType.info,
        ),
      ],
    );
  }
  
  // Upcoming Schedule Content (for collapsible)
  Widget _buildUpcomingScheduleContent() {
    if (_upcomingBookings.isEmpty) {
      return Text(
        'No upcoming bookings',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            const SizedBox.shrink(),
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  _createPageRoute(const CalendarScreen()),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ...List.generate(_upcomingBookings.length, (index) {
            final booking = _upcomingBookings[index];
            final nextBooking = index < _upcomingBookings.length - 1 
                ? _upcomingBookings[index + 1] 
                : null;
            
            // Calculate travel time (mock - would use maps API in production)
            final travelTime = index == 0 ? '15 min' : null;
            
            // Check for conflicts (mock - would check against all bookings)
            final hasConflict = false; // Mock: no conflicts
            
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: _buildUpcomingBookingRow(
                booking: booking,
                travelTime: travelTime,
                hasConflict: hasConflict,
                nextBooking: nextBooking,
              ),
            );
          }),
      ],
    );
  }
  
  Widget _buildUpcomingBookingRow({
    required Booking booking,
    String? travelTime,
    bool hasConflict = false,
    Booking? nextBooking,
  }) {
    final timeUntil = booking.startTime.difference(DateTime.now());
    final hoursUntil = timeUntil.inHours;
    final minutesUntil = timeUntil.inMinutes % 60;
    String timeUntilText;
    
    if (hoursUntil > 0) {
      timeUntilText = '${hoursUntil}h ${minutesUntil}m';
    } else {
      timeUntilText = '${minutesUntil}m';
    }
    
    // Check if next booking is too close (conflict)
    bool hasTimeConflict = false;
    if (nextBooking != null) {
      final timeBetween = nextBooking.startTime.difference(booking.endTime);
      if (timeBetween.inMinutes < 15) {
        hasTimeConflict = true;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
      decoration: BoxDecoration(
        color: hasConflict || hasTimeConflict
            ? const Color(SwiftleadTokens.warningYellow).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        border: hasConflict || hasTimeConflict
            ? Border.all(
                color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
                  Container(
            width: 4,
            height: 50,
                    decoration: BoxDecoration(
              color: booking.status == BookingStatus.confirmed
                  ? const Color(SwiftleadTokens.successGreen)
                  : const Color(SwiftleadTokens.warningYellow),
              borderRadius: BorderRadius.circular(2),
                    ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                    child: Text(
                        booking.serviceType,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ),
                    if (hasConflict || hasTimeConflict)
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: const Color(SwiftleadTokens.warningYellow),
                  ),
              ],
            ),
                const SizedBox(height: 2),
                Text(
                  booking.contactName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (travelTime != null) ...[
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Icon(
                        Icons.directions_car,
                        size: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        travelTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                if (hasTimeConflict && nextBooking != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '⚠️ Only ${nextBooking.startTime.difference(booking.endTime).inMinutes} min between bookings',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(SwiftleadTokens.warningYellow),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeUntilText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
              Text(
                'until',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  // Goal Tracking Summary
  Widget _buildGoalTrackingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            TextButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  _createPageRoute(const GoalTrackingScreen()),
                );
              },
              child: const Text('Manage'),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // Summary stats
        Row(
          children: [
            Expanded(
              child: _buildGoalStatItem(
                'Total',
                _goalSummary['totalGoals'].toString(),
              ),
            ),
            Expanded(
              child: _buildGoalStatItem(
                'On Track',
                _goalSummary['onTrackGoals'].toString(),
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
            Expanded(
              child: _buildGoalStatItem(
                'Completed',
                _goalSummary['completedGoals'].toString(),
                color: const Color(SwiftleadTokens.successGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // Progress bars for key goals
        _buildGoalProgressItem(
          'Monthly Revenue',
          _goalSummary['revenueProgress'] as double,
          '£8,500 / £10,000',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _buildGoalProgressItem(
          'Jobs Completed',
          _goalSummary['jobsProgress'] as double,
          '35 / 50',
        ),
      ],
    );
  }
  
  Widget _buildGoalStatItem(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color ?? Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
            Text(
              label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildGoalProgressItem(String label, double progress, String valueText) {
    final progressColor = progress >= 0.7
        ? const Color(SwiftleadTokens.successGreen)
        : progress >= 0.4
            ? const Color(SwiftleadTokens.warningYellow)
            : const Color(SwiftleadTokens.errorRed);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              valueText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 6,
      ),
      ],
    );
  }
}

enum _EventType { payment, job, message, booking, quote }

class _ActivityFeedRow extends StatelessWidget {
  final _EventType eventType;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityFeedRow({
    required this.eventType,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  IconData _getIcon() {
    switch (eventType) {
      case _EventType.payment:
        return Icons.account_balance_wallet;
      case _EventType.job:
        return Icons.work;
      case _EventType.message:
        return Icons.message;
      case _EventType.booking:
        return Icons.calendar_today;
      case _EventType.quote:
        return Icons.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(
          Icons.visibility,
          color: Color(SwiftleadTokens.primaryTeal),
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(
          Icons.reply,
          color: Color(SwiftleadTokens.primaryTeal),
        ),
      ),
      onDismissed: (direction) {
        // Swipe right for quick actions (view details, respond)
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getIcon(),
                color: const Color(SwiftleadTokens.primaryTeal),
                size: 20,
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// Sparkline painter for home screen metrics
class _HomeSparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _HomeSparklinePainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = range > 0
          ? (data[i] - minValue) / range
          : 0.5;
      final y = size.height - (normalizedValue * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HomeSparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}

// Sticky header delegate for metrics
class _StickyMetricsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyMetricsHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyMetricsHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}
