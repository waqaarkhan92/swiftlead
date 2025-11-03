import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Meta Business Setup Screen
/// For Facebook and Instagram integration setup
/// Spec: Cross_Reference_Matrix_v2.5.1 Module 16
class MetaBusinessSetupScreen extends StatefulWidget {
  const MetaBusinessSetupScreen({super.key});

  @override
  State<MetaBusinessSetupScreen> createState() => _MetaBusinessSetupScreenState();
}

class _MetaBusinessSetupScreenState extends State<MetaBusinessSetupScreen> {
  bool _isLoading = false;
  bool _isConnected = true;
  String _connectedPlatform = 'Facebook'; // or Instagram

  void _handleConnectDisconnect() {
    setState(() => _isConnected = !_isConnected);
    Toast.show(
      context,
      message: _isConnected ? 'Meta Business connected successfully' : 'Meta Business disconnected',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Meta Business Setup'),
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
                  Icon(Icons.facebook, color: const Color(SwiftleadTokens.primaryTeal), size: 32),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meta Business', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text('Manage Facebook & Instagram messages', style: Theme.of(context).textTheme.bodySmall),
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
        
        // Connected Platforms
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Connected Platforms', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _ConnectedPlatformTile(platform: 'Facebook', isConnected: _isConnected, connectedPlatform: _connectedPlatform),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _ConnectedPlatformTile(platform: 'Instagram', isConnected: _isConnected, connectedPlatform: _connectedPlatform),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Connect/Disconnect Button
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: _isConnected ? 'Disconnect' : 'Connect to Meta',
            onPressed: _handleConnectDisconnect,
          ),
        ),
      ],
    );
  }
}

class _ConnectedPlatformTile extends StatelessWidget {
  final String platform;
  final bool isConnected;
  final String connectedPlatform;

  const _ConnectedPlatformTile({
    required this.platform,
    required this.isConnected,
    required this.connectedPlatform,
  });

  @override
  Widget build(BuildContext context) {
    final bool platformConnected = isConnected && connectedPlatform == platform;
    
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        border: Border.all(
          color: platformConnected 
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            platform == 'Facebook' ? Icons.facebook : Icons.camera_alt,
            color: const Color(SwiftleadTokens.primaryTeal),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Text(platform, style: Theme.of(context).textTheme.bodyLarge),
          ),
          SwiftleadBadge.status(
            status: platformConnected ? BadgeStatus.success : BadgeStatus.neutral,
            label: platformConnected ? 'Connected' : 'Not connected',
          ),
        ],
      ),
    );
  }
}

