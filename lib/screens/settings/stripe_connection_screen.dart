import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Stripe Connection Screen
/// Spec: Cross_Reference_Matrix_v2.5.1 Module 16
class StripeConnectionScreen extends StatefulWidget {
  const StripeConnectionScreen({super.key});

  @override
  State<StripeConnectionScreen> createState() => _StripeConnectionScreenState();
}

class _StripeConnectionScreenState extends State<StripeConnectionScreen> {
  bool _isLoading = false;
  bool _isConnected = true;

  void _handleConnectDisconnect() {
    setState(() => _isConnected = !_isConnected);
    Toast.show(
      context,
      message: _isConnected ? 'Stripe connected successfully' : 'Stripe disconnected',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Stripe Connection'),
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
                  Icon(Icons.payment, color: const Color(SwiftleadTokens.primaryTeal), size: 32),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stripe', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text('Accept payments online', style: Theme.of(context).textTheme.bodySmall),
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
        
        // Account Info
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Information', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _AccountInfoTile(
                icon: Icons.account_balance,
                label: 'Account Type',
                value: 'Express',
                isConnected: _isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _AccountInfoTile(
                icon: Icons.verified,
                label: 'Verification Status',
                value: 'Verified',
                isConnected: _isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _AccountInfoTile(
                icon: Icons.payments,
                label: 'Balance',
                value: '£1,234.56',
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
            label: _isConnected ? 'Disconnect' : 'Connect to Stripe',
            onPressed: _handleConnectDisconnect,
          ),
        ),
      ],
    );
  }
}

class _AccountInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isConnected;

  const _AccountInfoTile({
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
              fontWeight: FontWeight.bold,
              color: isConnected ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}

