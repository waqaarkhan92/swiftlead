import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/campaign_card.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/confirmation_dialog.dart';
import 'campaign_builder_screen.dart';
import 'campaign_analytics_screen.dart';

/// Campaign Detail Screen - View campaign details and analytics
/// Exact specification from UI_Inventory_v2.5.1
class CampaignDetailScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _isLoading = false;
  bool _isPaused = false;
  bool _isArchived = false;
  int _selectedTab = 0; // 0 = Overview, 1 = Analytics, 2 = Recipients

  Future<void> _handlePauseCampaign() async {
    if (_isPaused) {
      // Resume campaign
      final confirmed = await SwiftleadConfirmationDialog.show(
        context: context,
        title: 'Resume Campaign',
        description: 'Are you sure you want to resume "${widget.campaignName}"?',
        primaryActionLabel: 'Resume',
        secondaryActionLabel: 'Cancel',
        icon: Icons.play_arrow,
      );

      if (confirmed == true && mounted) {
        setState(() {
          _isPaused = false;
        });
        Toast.show(
          context,
          message: 'Campaign resumed',
          type: ToastType.success,
        );
      }
    } else {
      // Pause campaign
      final confirmed = await SwiftleadConfirmationDialog.show(
        context: context,
        title: 'Pause Campaign',
        description: 'Are you sure you want to pause "${widget.campaignName}"? The campaign will stop sending messages.',
        primaryActionLabel: 'Pause',
        secondaryActionLabel: 'Cancel',
        icon: Icons.pause,
      );

      if (confirmed == true && mounted) {
        setState(() {
          _isPaused = true;
        });
        Toast.show(
          context,
          message: 'Campaign paused',
          type: ToastType.success,
        );
      }
    }
  }

  Future<void> _handleArchiveCampaign() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Archive Campaign',
      description: 'Are you sure you want to archive "${widget.campaignName}"? You can restore it later.',
      primaryActionLabel: 'Archive',
      secondaryActionLabel: 'Cancel',
      icon: Icons.archive,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isArchived = true;
      });
      Toast.show(
        context,
        message: 'Campaign archived',
        type: ToastType.success,
      );
    }
  }

  Future<void> _handleDeleteCampaign() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete Campaign',
      description: 'Are you sure you want to permanently delete "${widget.campaignName}"? This action cannot be undone.',
      primaryActionLabel: 'Delete',
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      Toast.show(
        context,
        message: 'Campaign deleted',
        type: ToastType.success,
      );
      Navigator.of(context).pop(true); // Return true to signal deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.campaignName,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignBuilderScreen(
                    campaignId: widget.campaignId,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'pause':
                  _handlePauseCampaign();
                  break;
                case 'archive':
                  _handleArchiveCampaign();
                  break;
                case 'delete':
                  _handleDeleteCampaign();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pause',
                child: Text(_isPaused ? 'Resume' : 'Pause'),
              ),
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
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
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        SkeletonLoader(
          width: double.infinity,
          height: 150,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Tab Bar
        SegmentedControl(
          segments: const ['Overview', 'Analytics', 'Recipients'],
          selectedIndex: _selectedTab,
          onSelectionChanged: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
        
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildOverviewTab(),
              _buildAnalyticsTab(),
              _buildRecipientsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Campaign Status Card
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campaign Status',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SwiftleadBadge(
                    label: 'Sent',
                    variant: BadgeVariant.success,
                    size: BadgeSize.medium,
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _InfoRow(label: 'Type', value: 'Email'),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Recipients', value: '250'),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Sent Date', value: '15/11/2024'),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Metrics Summary
        Row(
          children: [
            Expanded(
              child: FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  children: [
                    Text(
                      '24.5%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Open Rate',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  children: [
                    Text(
                      '6.2%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Click Rate',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campaign Analytics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CampaignAnalyticsScreen(
                            campaignId: widget.campaignId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('View Full Analytics'),
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Quick Analytics Summary\n(Tap "View Full Analytics" for details)',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientsTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Recipients',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // Recipient list would go here
        Text(
          '250 recipients',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

