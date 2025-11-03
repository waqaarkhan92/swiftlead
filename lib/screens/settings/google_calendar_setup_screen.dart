import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Google Calendar Setup Screen
/// Spec: Cross_Reference_Matrix_v2.5.1 Module 16
class GoogleCalendarSetupScreen extends StatefulWidget {
  const GoogleCalendarSetupScreen({super.key});

  @override
  State<GoogleCalendarSetupScreen> createState() => _GoogleCalendarSetupScreenState();
}

class _GoogleCalendarSetupScreenState extends State<GoogleCalendarSetupScreen> {
  bool _isLoading = false;
  bool _isConnected = true;

  void _handleConnectDisconnect() {
    setState(() => _isConnected = !_isConnected);
    Toast.show(
      context,
      message: _isConnected ? 'Google Calendar connected successfully' : 'Google Calendar disconnected',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Google Calendar Sync'),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(width: double.infinity, height: 200, borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard)),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Status Card
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: const Color(SwiftleadTokens.primaryTeal), size: 32),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Google Calendar', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text('Sync bookings with Google Calendar', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  SwiftleadBadge.status(
                    status: _isConnected ? BadgeStatus.success : BadgeStatus.error,
                    label: _isConnected ? 'Connected' : 'Disconnected',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Sync Settings
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sync Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _SyncSettingTile(
                icon: Icons.sync,
                label: 'Sync Direction',
                value: 'Two-way',
                isConnected: _isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _SyncSettingTile(
                icon: Icons.access_time,
                label: 'Last Sync',
                value: 'Just now',
                isConnected: _isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _SyncSettingTile(
                icon: Icons.event,
                label: 'Events Synced',
                value: '248',
                isConnected: _isConnected,
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Connect/Disconnect Button
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: _isConnected ? 'Disconnect' : 'Connect to Google',
            onPressed: _handleConnectDisconnect,
          ),
        ),
      ],
    );
  }
}

class _SyncSettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isConnected;

  const _SyncSettingTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(SwiftleadTokens.primaryTeal)),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isConnected ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}

