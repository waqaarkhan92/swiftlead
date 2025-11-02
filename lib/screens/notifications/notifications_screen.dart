import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';

/// Notifications Screen - Notification preferences and center
/// Exact specification from UI_Inventory_v2.5.1
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Notifications',
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Preferences'),
              Tab(text: 'Center'),
              Tab(text: 'Settings'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPreferencesTab(),
                _buildCenterTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification Preferences',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Choose which notifications you want to receive and how',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              // Preference Grid would go here
              _NotificationPreferenceRow(
                title: 'New Messages',
                channels: ['Push', 'Email', 'SMS'],
                enabled: true,
              ),
              const Divider(),
              _NotificationPreferenceRow(
                title: 'Job Updates',
                channels: ['Push', 'Email'],
                enabled: true,
              ),
              const Divider(),
              _NotificationPreferenceRow(
                title: 'Payment Received',
                channels: ['Push', 'Email'],
                enabled: true,
              ),
              const Divider(),
              _NotificationPreferenceRow(
                title: 'Campaign Results',
                channels: ['Email'],
                enabled: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterTab() {
    final hasNotifications = true; // Replace with actual data check

    if (!hasNotifications) {
      return EmptyStateCard(
        title: 'All caught up!',
        description: 'You have no new notifications.',
        icon: Icons.notifications_none,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(5, (index) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
        child: _NotificationCard(
          title: _getNotificationTitle(index),
          message: _getNotificationMessage(index),
          time: _getNotificationTime(index),
          isUnread: index < 2,
        ),
      )),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do Not Disturb',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              SwitchListTile(
                title: const Text('Enable DND Schedule'),
                subtitle: const Text('Automatically silence notifications during set hours'),
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              const Divider(),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Digest Schedule',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              SwitchListTile(
                title: const Text('Daily Digest'),
                subtitle: const Text('Receive a summary of all notifications once per day'),
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getNotificationTitle(int index) {
    final titles = [
      'New message from John',
      'Payment received',
      'Job completed',
      'Campaign sent',
      'Team member added',
    ];
    return titles[index % titles.length];
  }

  String _getNotificationMessage(int index) {
    final messages = [
      'John sent you a WhatsApp message',
      '£500 payment received for Job #1234',
      'Kitchen repair completed successfully',
      'Summer Promotion sent to 250 recipients',
      'Sarah joined your team',
    ];
    return messages[index % messages.length];
  }

  String _getNotificationTime(int index) {
    final times = [
      'Just now',
      '5 minutes ago',
      '1 hour ago',
      '2 hours ago',
      'Yesterday',
    ];
    return times[index % times.length];
  }
}

class _NotificationPreferenceRow extends StatelessWidget {
  final String title;
  final List<String> channels;
  final bool enabled;

  const _NotificationPreferenceRow({
    required this.title,
    required this.channels,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: channels.map((channel) => SwiftleadChip(
                  label: channel,
                  isSelected: enabled,
                  onTap: null,
                )).toList(),
              ),
            ],
          ),
        ),
        Switch(
          value: enabled,
          onChanged: (value) {},
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isUnread;

  const _NotificationCard({
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: isUnread
                  ? const Color(SwiftleadTokens.primaryTeal)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

