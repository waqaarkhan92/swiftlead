import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/badge.dart';

/// IntegrationCard - Card showing integration logo, status, connect/disconnect button
/// Exact specification from UI_Inventory_v2.5.1
class IntegrationCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isConnected;
  final String? lastSyncTime;
  final String? statusMessage;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;
  final VoidCallback? onConfigure;

  const IntegrationCard({
    super.key,
    required this.name,
    required this.icon,
    this.isConnected = false,
    this.lastSyncTime,
    this.statusMessage,
    this.onConnect,
    this.onDisconnect,
    this.onConfigure,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (lastSyncTime != null)
                      Text(
                        'Last synced: $lastSyncTime',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              SwiftleadBadge(
                label: isConnected ? 'Connected' : 'Not Connected',
                variant: isConnected ? BadgeVariant.success : BadgeVariant.secondary,
                size: BadgeSize.small,
              ),
            ],
          ),
          if (statusMessage != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              statusMessage!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              if (isConnected) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDisconnect,
                    child: const Text('Disconnect'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: PrimaryButton(
                    label: 'Configure',
                    onPressed: onConfigure,
                    size: ButtonSize.small,
                  ),
                ),
              ] else
                Expanded(
                  child: PrimaryButton(
                    label: 'Connect',
                    onPressed: onConnect,
                    icon: Icons.link,
                    size: ButtonSize.small,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

