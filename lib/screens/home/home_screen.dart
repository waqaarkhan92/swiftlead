import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/quick_action_chip.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';

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
  
  @override
  void initState() {
    super.initState();
    // Progressive loading: metrics → chart → feed
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
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
          onPressed: () {},
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
        // Metrics skeleton
        Row(
          children: List.generate(4, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 3 ? 8.0 : 0.0),
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
      ],
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull-to-refresh: updates only what's changed
        await Future.delayed(const Duration(milliseconds: 500));
        // Show "Updated just now" toast would go here
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // MetricsRow with TrendTile (sparklines, tooltips, animated counters)
          _buildMetricsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // ChartCard with interactive legend
          _buildChartCard(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // SmartTileGrid with badges
          _buildTileGrid(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // QuickActionChipsRow
          _buildQuickActionChipsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // AIInsightBanner
          if (_showAIBanner)
            AIInsightBanner(
              message: 'AI found 3 unconfirmed bookings — confirm now?',
              onTap: () {},
              onDismiss: () {
                setState(() => _showAIBanner = false);
              },
            ),
          
          // ActivityFeed with swipe actions
          _buildActivityFeed(),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: TrendTile(
            label: 'Revenue',
            value: '£2,450',
            trend: '+12%',
            isPositive: true,
            sparklineData: [1200, 1500, 1800, 2000, 2100, 2300, 2450],
            tooltip: 'Revenue breakdown: Services £1,800, Products £650',
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceS),
        Expanded(
          child: TrendTile(
            label: 'Active Jobs',
            value: '18',
            trend: '+3',
            isPositive: true,
            sparklineData: [12, 14, 15, 16, 17, 17, 18],
            tooltip: 'Active jobs by status: In Progress 12, Scheduled 6',
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceS),
        Expanded(
          child: TrendTile(
            label: 'Messages',
            value: '24',
            trend: 'Unread',
            isPositive: false,
            sparklineData: [5, 8, 12, 15, 18, 22, 24],
            tooltip: 'Unread by channel: SMS 15, WhatsApp 6, Email 3',
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceS),
        Expanded(
          child: TrendTile(
            label: 'Conversion',
            value: '68%',
            trend: '+5%',
            isPositive: true,
            sparklineData: [55, 58, 60, 62, 65, 66, 68],
            tooltip: 'Quote to job conversion rate',
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Trend',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // Period selector (7/30/90 days) - interactive legend
              Row(
                children: [
                  _PeriodChip(label: '7D', isSelected: false),
                  const SizedBox(width: 8),
                  _PeriodChip(label: '30D', isSelected: true),
                  const SizedBox(width: 8),
                  _PeriodChip(label: '90D', isSelected: false),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          SizedBox(
            height: 150,
            child: Center(
              child: Text(
                'Chart will be implemented with fl_chart\n(Tap data points for breakdown, swipe for period change)',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SmartTile(
                icon: Icons.inbox_outlined,
                label: 'Inbox',
                badge: '24',
                preview: '24 unread messages across 5 channels',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _SmartTile(
                icon: Icons.work_outline,
                label: 'Jobs',
                badge: '18',
                preview: '18 active jobs, 6 scheduled today',
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: _SmartTile(
                icon: Icons.calendar_today_outlined,
                label: 'Calendar',
                badge: '8',
                preview: '8 bookings today, 3 tomorrow',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _SmartTile(
                icon: Icons.attach_money_outlined,
                label: 'Money',
                badge: '£2.4k',
                preview: '£2.4k pending, £450 overdue',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickActionChip(
            label: 'Add Job',
            icon: Icons.add,
            tooltip: 'Create a new job',
            onTap: () {},
          ),
          QuickActionChip(
            label: 'Send Payment',
            icon: Icons.attach_money,
            tooltip: 'Request or send payment',
            onTap: () {},
          ),
          QuickActionChip(
            label: 'Book Slot',
            icon: Icons.calendar_today,
            tooltip: 'Schedule an appointment',
            onTap: () {},
          ),
          QuickActionChip(
            label: 'AI Insights',
            icon: Icons.auto_awesome,
            tooltip: 'View AI-powered insights',
            onTap: () {},
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
}

enum _EventType { payment, job, message, booking, quote }

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  
  const _PeriodChip({
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _SmartTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final String? preview;

  const _SmartTile({
    required this.icon,
    required this.label,
    this.badge,
    this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Haptic feedback on tap
        HapticFeedback.mediumImpact();
      },
      onLongPress: preview != null
          ? () {
              // Show contextual preview data on long-press
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(preview!),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              HapticFeedback.lightImpact();
            }
          : null,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        return Icons.attach_money;
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
