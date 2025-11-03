import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import 'change_password_screen.dart';

/// Security Settings Screen - Dedicated security configuration
/// Exact specification from UI_Inventory_v2.5.1
class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _sessionTimeoutEnabled = true;
  int _sessionTimeoutMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Security Settings',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Two-Factor Authentication
          FrostedContainer(
            padding: const EdgeInsets.all(20),
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
                            'Two-Factor Authentication',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add an extra layer of security to your account',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _twoFactorEnabled,
                      onChanged: (value) {
                        setState(() {
                          _twoFactorEnabled = value;
                        });
                        if (value) {
                          _setupTwoFactor();
                        }
                      },
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                if (_twoFactorEnabled) ...[
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  const Divider(),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Text(
                    'Configure 2FA',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Text(
                    'Use an authenticator app to generate verification codes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  PrimaryButton(
                    label: 'Set Up 2FA',
                    onPressed: _setupTwoFactor,
                    icon: Icons.security,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Biometric Authentication
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biometric Authentication',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use fingerprint or face ID to unlock',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                  activeColor: const Color(SwiftleadTokens.primaryTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Session Timeout
          FrostedContainer(
            padding: const EdgeInsets.all(20),
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
                            'Session Timeout',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Automatically log out after inactivity',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _sessionTimeoutEnabled,
                      onChanged: (value) {
                        setState(() {
                          _sessionTimeoutEnabled = value;
                        });
                      },
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                if (_sessionTimeoutEnabled) ...[
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  const Divider(),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Text(
                    'Timeout Duration',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  DropdownButton<int>(
                    value: _sessionTimeoutMinutes,
                    isExpanded: true,
                    items: [15, 30, 60, 120, 240].map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text('$minutes minutes'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sessionTimeoutMinutes = value;
                        });
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Active Sessions
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Sessions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _SessionItem(
                  device: 'iPhone 14 Pro',
                  location: 'London, UK',
                  lastActive: 'Active now',
                  isCurrent: true,
                ),
                const Divider(),
                _SessionItem(
                  device: 'MacBook Pro',
                  location: 'London, UK',
                  lastActive: '2 hours ago',
                  isCurrent: false,
                ),
                const Divider(),
                _SessionItem(
                  device: 'iPad',
                  location: 'London, UK',
                  lastActive: '1 day ago',
                  isCurrent: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Change Password
          PrimaryButton(
            label: 'Change Password',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
            icon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }

  Future<void> _setupTwoFactor() async {
    // TODO: Implement 2FA setup flow
    Toast.show(
      context,
      message: '2FA setup coming soon',
      type: ToastType.info,
    );
  }
}

class _SessionItem extends StatelessWidget {
  final String device;
  final String location;
  final String lastActive;
  final bool isCurrent;

  const _SessionItem({
    required this.device,
    required this.location,
    required this.lastActive,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.devices,
          size: 24,
          color: const Color(SwiftleadTokens.primaryTeal),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    device,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Current',
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(SwiftleadTokens.successGreen),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$location • $lastActive',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (!isCurrent)
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: () {
              _showSignOutDialog(context);
            },
            tooltip: 'Sign out',
          ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Sign Out Device',
      description: 'Are you sure you want to sign out from $device?',
      primaryActionLabel: 'Sign Out',
      secondaryActionLabel: 'Cancel',
      icon: Icons.logout,
    ).then((confirmed) {
      if (confirmed == true) {
        Toast.show(
          context,
          message: 'Signed out from $device',
          type: ToastType.success,
        );
      }
    });
  }
}

