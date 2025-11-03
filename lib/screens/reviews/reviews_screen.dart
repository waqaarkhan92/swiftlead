import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/badge.dart' show SwiftleadBadge, BadgeVariant, BadgeSize;
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/components/data_table.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart' as main_nav;
import 'review_response_form.dart';
import 'nps_survey_view.dart';

/// Reviews Screen - Review management and reputation tracking
/// Exact specification from Cross_Reference_Matrix_v2.5.1 Module 8
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isLoading = true;
  int _selectedTab = 0;
  final List<String> _tabs = ['Dashboard', 'Requests', 'All Reviews', 'Analytics', 'NPS'];
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Google', 'Facebook', 'Yelp', 'Internal'];
  String _reviewStatusFilter = 'All';
  final List<String> _statusFilters = ['All', 'Pending', 'Sent', 'Received', 'Responded'];

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
        title: 'Reviews',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              setState(() => _isLoading = true);
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _isLoading = false);
              });
            },
            tooltip: 'Refresh Reviews',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showReviewSettings(context),
            tooltip: 'Review Settings',
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
          height: 120,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        SkeletonLoader(
          width: double.infinity,
          height: 80,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        SkeletonLoader(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Tab Selector
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceS,
          ),
          child: SegmentedControl(
            segments: _tabs,
            selectedIndex: _selectedTab,
            onSelectionChanged: (index) {
              setState(() => _selectedTab = index);
            },
          ),
        ),
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildDashboardTab(),
              _buildRequestsTab(),
              _buildAllReviewsTab(),
              _buildAnalyticsTab(),
              _buildNPSTab(),
            ],
          ),
        ),
      ],
    );
  }

  // Dashboard Tab - Overview metrics and recent reviews
  Widget _buildDashboardTab() {
    final averageRating = 4.7;
    final totalReviews = 142;
    final thisMonth = 23;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) setState(() => _isLoading = false);
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Summary Metrics
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Rating',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.6),
                              ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(SwiftleadTokens.primaryTeal),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 4),
                              child: Icon(
                                Icons.star,
                                color: const Color(SwiftleadTokens.warningYellow),
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Reviews',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.6),
                              ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text(
                          totalReviews.toString(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text(
                          '+$thisMonth this month',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(SwiftleadTokens.successGreen),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                // Star Distribution
                _buildStarDistribution(),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Rating Trend Chart
          TrendLineChart(
            title: 'Rating Trend',
            dataPoints: [
              ChartDataPoint(label: 'Jan', value: 4.5),
              ChartDataPoint(label: 'Feb', value: 4.6),
              ChartDataPoint(label: 'Mar', value: 4.7),
              ChartDataPoint(label: 'Apr', value: 4.8),
              ChartDataPoint(label: 'May', value: 4.7),
              ChartDataPoint(label: 'Jun', value: 4.7),
            ],
            periodData: {
              '7D': [
                ChartDataPoint(label: 'Mon', value: 4.6),
                ChartDataPoint(label: 'Tue', value: 4.7),
                ChartDataPoint(label: 'Wed', value: 4.8),
                ChartDataPoint(label: 'Thu', value: 4.7),
                ChartDataPoint(label: 'Fri', value: 4.6),
                ChartDataPoint(label: 'Sat', value: 4.7),
                ChartDataPoint(label: 'Sun', value: 4.8),
              ],
              '30D': [
                ChartDataPoint(label: 'Week 1', value: 4.6),
                ChartDataPoint(label: 'Week 2', value: 4.7),
                ChartDataPoint(label: 'Week 3', value: 4.8),
                ChartDataPoint(label: 'Week 4', value: 4.7),
              ],
              '90D': [
                ChartDataPoint(label: 'Month 1', value: 4.6),
                ChartDataPoint(label: 'Month 2', value: 4.7),
                ChartDataPoint(label: 'Month 3', value: 4.8),
              ],
            },
            lineColor: const Color(SwiftleadTokens.primaryTeal),
            yAxisLabel: 'Rating',
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Recent Reviews
          _buildRecentReviews(),
        ],
      ),
    );
  }

  Widget _buildStarDistribution() {
    final distribution = [0.05, 0.08, 0.12, 0.25, 0.50]; // 5%, 8%, 12%, 25%, 50%
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating Distribution',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ...List.generate(5, (index) {
          final stars = 5 - index;
          final percentage = distribution[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceXS),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      child: Text(
                        '$stars',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star,
                      size: 14,
                      color: const Color(SwiftleadTokens.warningYellow),
                    ),
                  ],
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.1)
                          : Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(SwiftleadTokens.primaryTeal),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentReviews() {
    final recentReviews = [
      {
        'platform': 'Google',
        'rating': 5,
        'author': 'Sarah Johnson',
        'comment': 'Excellent service! Very professional and on time.',
        'date': '2 days ago',
      },
      {
        'platform': 'Facebook',
        'rating': 4,
        'author': 'Mike Davis',
        'comment': 'Good work, would recommend.',
        'date': '5 days ago',
      },
      {
        'platform': 'Yelp',
        'rating': 5,
        'author': 'Emma Wilson',
        'comment': 'Amazing experience from start to finish!',
        'date': '1 week ago',
      },
    ];

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Reviews',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedTab = 2),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          ...recentReviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: Container(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.02)
              : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SwiftleadBadge(
                      label: review['platform'] as String,
                      variant: BadgeVariant.info,
                      size: BadgeSize.small,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    ...List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 16,
                        color: index < (review['rating'] as int)
                            ? const Color(SwiftleadTokens.warningYellow)
                            : Colors.grey.withOpacity(0.3),
                      );
                    }),
                  ],
                ),
                Text(
                  review['date'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                      ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              review['author'] as String,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              review['comment'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            if ((review['rating'] as int) < 5)
              PrimaryButton(
                label: 'Respond',
                onPressed: () => _showResponseForm(context, review),
                size: ButtonSize.small,
              ),
          ],
        ),
      ),
    );
  }

  // Requests Tab - Review request list and status
  Widget _buildRequestsTab() {
    return Column(
      children: [
        // Filter Chips
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceS,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _statusFilters.map((filter) {
                final isSelected = _reviewStatusFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _reviewStatusFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Request List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildRequestList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestList() {
    final requests = _getFilteredRequests();

    if (requests.isEmpty) {
      return EmptyStateCard(
        title: 'No Review Requests',
        description: _reviewStatusFilter == 'All'
            ? 'Start requesting reviews from your satisfied customers'
            : 'No ${_reviewStatusFilter.toLowerCase()} requests',
        icon: Icons.rate_review_outlined,
        actionLabel: 'Request Review',
        onAction: () => _showRequestReview(context),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildRequestCard(request);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredRequests() {
    final allRequests = [
      {
        'id': '1',
        'clientName': 'Sarah Johnson',
        'jobTitle': 'Bathroom Renovation',
        'status': 'Received',
        'platform': 'Google',
        'sentDate': '2 days ago',
        'receivedDate': '1 day ago',
        'rating': 5,
      },
      {
        'id': '2',
        'clientName': 'Mike Davis',
        'jobTitle': 'Plumbing Repair',
        'status': 'Sent',
        'platform': 'Facebook',
        'sentDate': '3 days ago',
        'receivedDate': null,
        'rating': null,
      },
      {
        'id': '3',
        'clientName': 'Emma Wilson',
        'jobTitle': 'Kitchen Installation',
        'status': 'Pending',
        'platform': 'Google',
        'sentDate': null,
        'receivedDate': null,
        'rating': null,
      },
      {
        'id': '4',
        'clientName': 'John Smith',
        'jobTitle': 'Heating Service',
        'status': 'Responded',
        'platform': 'Yelp',
        'sentDate': '1 week ago',
        'receivedDate': '6 days ago',
        'rating': 4,
      },
    ];

    if (_reviewStatusFilter == 'All') {
      return allRequests;
    }

    return allRequests
        .where((r) => r['status'].toString().toLowerCase() ==
            _reviewStatusFilter.toLowerCase())
        .toList();
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
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
                        request['clientName'] as String,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request['jobTitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                SwiftleadBadge(
                  label: request['status'] as String,
                  variant: _getStatusVariant(request['status'] as String),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                SwiftleadBadge(
                  label: request['platform'] as String,
                  variant: BadgeVariant.info,
                  size: BadgeSize.small,
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                if (request['rating'] != null) ...[
                  ...List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 14,
                      color: index < (request['rating'] as int)
                          ? const Color(SwiftleadTokens.warningYellow)
                          : Colors.grey.withOpacity(0.3),
                    );
                  }),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                ],
                Text(
                  request['sentDate'] != null
                      ? 'Sent ${request['sentDate']}'
                      : 'Not sent',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                      ),
                ),
              ],
            ),
            if (request['status'] == 'Received' && request['rating'] != null)
              Padding(
                padding: const EdgeInsets.only(top: SwiftleadTokens.spaceS),
                child: PrimaryButton(
                  label: 'Respond to Review',
                  onPressed: () => _showResponseForm(context, {
                    'platform': request['platform'],
                    'author': request['clientName'],
                    'rating': request['rating'],
                  }),
                  size: ButtonSize.small,
                ),
              ),
          ],
        ),
      ),
    );
  }

  BadgeVariant _getStatusVariant(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return BadgeVariant.success;
      case 'sent':
        return BadgeVariant.info;
      case 'pending':
        return BadgeVariant.warning;
      case 'responded':
        return BadgeVariant.success;
      default:
        return BadgeVariant.info;
    }
  }

  // All Reviews Tab - Complete review list
  Widget _buildAllReviewsTab() {
    return Column(
      children: [
        // Filter Chips
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceS,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Reviews List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildReviewsList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsList() {
    final reviews = _getFilteredReviews();

    if (reviews.isEmpty) {
      return EmptyStateCard(
        title: 'No Reviews',
        description: _selectedFilter == 'All'
            ? 'Reviews from your customers will appear here'
            : 'No reviews from $_selectedFilter',
        icon: Icons.star_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _buildReviewCard(review),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredReviews() {
    final allReviews = [
      {
        'platform': 'Google',
        'rating': 5,
        'author': 'Sarah Johnson',
        'comment': 'Excellent service! Very professional and on time.',
        'date': '2 days ago',
      },
      {
        'platform': 'Facebook',
        'rating': 4,
        'author': 'Mike Davis',
        'comment': 'Good work, would recommend.',
        'date': '5 days ago',
      },
      {
        'platform': 'Yelp',
        'rating': 5,
        'author': 'Emma Wilson',
        'comment': 'Amazing experience from start to finish!',
        'date': '1 week ago',
      },
      {
        'platform': 'Google',
        'rating': 5,
        'author': 'David Brown',
        'comment': 'Fast response and excellent quality work.',
        'date': '2 weeks ago',
      },
      {
        'platform': 'Facebook',
        'rating': 5,
        'author': 'Lisa Anderson',
        'comment': 'Highly recommend! Professional team.',
        'date': '3 weeks ago',
      },
    ];

    if (_selectedFilter == 'All') {
      return allReviews;
    }

    return allReviews
        .where((r) => r['platform'].toString().toLowerCase() ==
            _selectedFilter.toLowerCase())
        .toList();
  }

  // Analytics Tab - Review analytics dashboard
  Widget _buildAnalyticsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Analytics Metrics
          Row(
            children: [
              Expanded(
                child: TrendTile(
                  label: 'Avg Rating',
                  value: '4.7',
                  trend: '+0.2',
                  isPositive: true,
                  sparklineData: [4.5, 4.6, 4.7, 4.7, 4.8],
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: TrendTile(
                  label: 'Response Rate',
                  value: '85%',
                  trend: '+5%',
                  isPositive: true,
                  sparklineData: [75, 78, 80, 82, 85],
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Expanded(
                child: TrendTile(
                  label: 'Total Reviews',
                  value: '142',
                  trend: '+23',
                  isPositive: true,
                  sparklineData: [110, 120, 130, 135, 142],
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: TrendTile(
                  label: 'Response Time',
                  value: '12h',
                  trend: '-3h',
                  isPositive: true,
                  sparklineData: [18, 16, 15, 14, 12],
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Sentiment Analysis
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sentiment Analysis',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _buildSentimentChart(),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Top Keywords
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Keywords',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  runSpacing: SwiftleadTokens.spaceS,
                  children: [
                    'Professional',
                    'On Time',
                    'Excellent',
                    'Recommend',
                    'Quality',
                    'Fast',
                    'Reliable',
                    'Satisfied',
                  ].map((keyword) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SwiftleadTokens.spaceM,
                        vertical: SwiftleadTokens.spaceS,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.05)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                      child: Text(
                        keyword,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentChart() {
    final positive = 0.75;
    final neutral = 0.15;
    final negative = 0.10;

    return Column(
      children: [
        _buildSentimentBar('Positive', positive, const Color(SwiftleadTokens.successGreen)),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _buildSentimentBar('Neutral', neutral, const Color(SwiftleadTokens.warningYellow)),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _buildSentimentBar('Negative', negative, const Color(SwiftleadTokens.errorRed)),
      ],
    );
  }

  Widget _buildSentimentBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 24,
            ),
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceS),
        SizedBox(
          width: 50,
          child: Text(
            '${(value * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // NPS Tab - NPS Survey View
  Widget _buildNPSTab() {
    return NpsSurveyView();
  }

  void _showReviewSettings(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Review Settings',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Auto-fetch Reviews'),
            subtitle: const Text('Automatically fetch reviews daily'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Review Notifications'),
            subtitle: const Text('Notify when new reviews are received'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('AI Responses'),
            subtitle: const Text('Use AI to suggest review responses'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          PrimaryButton(
            label: 'Save Settings',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showRequestReview(BuildContext context) {
    // This would typically open the ReviewRequestSheet
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request Review feature - Use from Job Detail')),
    );
  }

  void _showResponseForm(BuildContext context, Map<String, dynamic> review) {
    ReviewResponseForm.show(
      context: context,
      platform: review['platform'] as String? ?? 'Google',
      reviewAuthor: review['author'] as String? ?? 'Customer',
      reviewRating: review['rating'] as int? ?? 5,
      reviewComment: review['comment'] as String?,
      onSent: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review response sent successfully')),
        );
      },
    );
  }
}

