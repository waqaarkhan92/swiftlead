import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';
import 'campaign_detail_screen.dart';
import 'campaign_builder_screen.dart';
import '../main_navigation.dart' as main_nav;

/// Marketing Screen - Campaign list and management
/// Exact specification from UI_Inventory_v2.5.1
class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';

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
        title: 'Marketing',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCampaignSheet(context),
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
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 120,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    final hasCampaigns = true; // Replace with actual data check

    if (!hasCampaigns) {
      return EmptyStateCard(
        title: 'No campaigns yet',
        description: 'Create your first marketing campaign to reach your customers.',
        icon: Icons.campaign_outlined,
        actionLabel: 'Create Campaign',
        onAction: () => _showCreateCampaignSheet(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Draft', 'Scheduled', 'Sending', 'Sent'].map((filter) {
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
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Campaign List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8, // Example
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: _CampaignCard(
                campaignName: _getCampaignName(index),
                campaignType: _getCampaignType(index),
                status: _getStatus(index),
                recipients: _getRecipients(index),
                openRate: _getOpenRate(index),
                clickRate: _getClickRate(index),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(
                        campaignId: 'campaign_$index',
                        campaignName: _getCampaignName(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Filter Campaigns',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Filter options:\n- Status\n- Type\n- Date Range\n- Performance',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showCreateCampaignSheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CampaignBuilderScreen(),
      ),
    );
  }

  String _getCampaignName(int index) {
    final names = [
      'Summer Promotion',
      'New Service Announcement',
      'Weekly Newsletter',
      'Holiday Special',
      'Customer Appreciation',
      'Referral Program',
    ];
    return names[index % names.length];
  }

  String _getCampaignType(int index) {
    final types = ['Email', 'SMS', 'Multi-channel'];
    return types[index % types.length];
  }

  String _getStatus(int index) {
    final statuses = ['Draft', 'Scheduled', 'Sending', 'Sent'];
    return statuses[index % statuses.length];
  }

  int _getRecipients(int index) {
    return 100 + (index * 50);
  }

  double _getOpenRate(int index) {
    return 20.0 + (index * 5.0) % 30.0;
  }

  double _getClickRate(int index) {
    return 5.0 + (index * 2.0) % 15.0;
  }
}

class _CampaignCard extends StatelessWidget {
  final String campaignName;
  final String campaignType;
  final String status;
  final int recipients;
  final double openRate;
  final double clickRate;
  final VoidCallback onTap;

  const _CampaignCard({
    required this.campaignName,
    required this.campaignType,
    required this.status,
    required this.recipients,
    required this.openRate,
    required this.clickRate,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sent':
        return const Color(SwiftleadTokens.successGreen);
      case 'Sending':
        return const Color(SwiftleadTokens.primaryTeal);
      case 'Scheduled':
        return const Color(SwiftleadTokens.warningYellow);
      case 'Draft':
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
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
                        campaignName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        campaignType,
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
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    label: 'Recipients',
                    value: '$recipients',
                  ),
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Open Rate',
                    value: '${openRate.toStringAsFixed(1)}%',
                  ),
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Click Rate',
                    value: '${clickRate.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

