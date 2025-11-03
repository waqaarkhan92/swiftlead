import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import 'canned_responses_screen.dart';
import 'organization_profile_screen.dart';
import 'team_management_screen.dart';
import 'twilio_configuration_screen.dart';
import 'meta_business_setup_screen.dart';
import 'google_calendar_setup_screen.dart';
import 'stripe_connection_screen.dart';
import 'email_configuration_screen.dart';
import '../notifications/notifications_screen.dart';
import '../support/support_screen.dart';
import '../main_navigation.dart' as main_nav;
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'security_settings_screen.dart';
import 'data_export_screen.dart';
import 'account_deletion_screen.dart';
import 'app_preferences_screen.dart';
import 'invoice_customization_screen.dart';
import 'subscription_billing_screen.dart';
import 'custom_fields_manager_screen.dart';
import '../../widgets/forms/business_hours_editor_sheet.dart';
import '../calendar/service_catalog_screen.dart';
import '../calendar/service_editor_screen.dart';
import '../ai_hub/ai_configuration_screen.dart';
import '../ai_hub/faq_management_screen.dart';
import '../legal/legal_screen.dart';

/// Settings Screen - Organization configuration and preferences
/// Exact specification from Screen_Layouts_v2.5.1 and UI_Inventory_v2.5.1
class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  
  const SettingsScreen({super.key, required this.onThemeChanged, required this.currentThemeMode});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;
  String _profileName = 'Alex Johnson';
  String _profileEmail = 'alex@abcplumbing.co.uk';
  String _profilePhone = '+44 20 1234 5678';
  String _profileCompany = 'ABC Plumbing';
  
  ThemeMode get _themeMode => widget.currentThemeMode;

  void _handleHelpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SupportScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Settings',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _handleHelpTap,
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
          height: 100,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // ProfileCard
        _buildProfileCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // SettingsSectionList - Grouped settings
        _buildSettingsSectionList(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // PlanCard
        _buildPlanCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // DangerZone
        _buildDangerZone(),
      ],
    );
  }

  Widget _buildProfileCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: () {
                  // Tap to change photo
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name (tap to edit)
                    GestureDetector(
                      onTap: () {
                        // Edit profile
                      },
                      child: Text(
                        _profileName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      _profileEmail,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      _profilePhone,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // OrganisationName
          Text(
            _profileCompany,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          // PlanBadge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Swiftlead Pro',
              style: TextStyle(
                color: const Color(SwiftleadTokens.primaryTeal),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSectionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsSection(
          title: 'Account',
          items: [
            _SettingsItem(
              icon: Icons.person_outline,
              label: 'Edit Profile',
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
                if (result != null && mounted) {
                  setState(() {
                    final data = result as Map<String, dynamic>;
                    _profileName = data['name'] ?? _profileName;
                    _profileEmail = data['email'] ?? _profileEmail;
                    _profilePhone = data['phone'] ?? _profilePhone;
                    _profileCompany = data['company'] ?? _profileCompany;
                  });
                }
              },
            ),
            _SettingsItem(
              icon: Icons.lock_outline,
              label: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.security,
              label: 'Security Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecuritySettingsScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.email_outlined,
              label: 'Email Preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailConfigurationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.notifications_outlined,
              label: 'Notification Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Settings',
              onTap: () {
                // Navigate to security settings for privacy options
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecuritySettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'Business',
          items: [
            _SettingsItem(
              icon: Icons.business_outlined,
              label: 'Organisation Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganizationProfileScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.people_outline,
              label: 'Team Members',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamManagementScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.label_outline,
              label: 'Custom Fields',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomFieldsManagerScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.access_time_outlined,
              label: 'Business Hours',
              onTap: () async {
                final hours = await BusinessHoursEditorSheet.show(
                  context: context,
                  currentHours: 'Mon-Fri, 9:00-17:00',
                );
                if (hours != null && mounted) {
                  Toast.show(
                    context,
                    message: 'Business hours updated',
                    type: ToastType.success,
                  );
                }
              },
            ),
            _SettingsItem(
              icon: Icons.construction_outlined,
              label: 'Services & Pricing',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceCatalogScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.receipt_outlined,
              label: 'Tax Settings',
              onTap: () {
                // Show tax settings dialog - placeholder for now
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tax Settings'),
                    content: const Text('Tax settings configuration coming soon. You can set tax rates when creating invoices.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'Integrations',
          items: [
            _SettingsItem(
              icon: Icons.chat_bubble_outline,
              label: 'WhatsApp Connect',
              trailing: _IntegrationStatus(isConnected: true),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TwilioConfigurationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.camera_alt_outlined,
              label: 'Instagram Connect',
              trailing: _IntegrationStatus(isConnected: false),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MetaBusinessSetupScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.facebook,
              label: 'Facebook Connect',
              trailing: _IntegrationStatus(isConnected: true),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MetaBusinessSetupScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.calendar_today_outlined,
              label: 'Google Calendar Sync',
              trailing: _IntegrationStatus(isConnected: true),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoogleCalendarSetupScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.payment_outlined,
              label: 'Stripe Connect',
              trailing: _IntegrationStatus(isConnected: true),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StripeConnectionScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.email_outlined,
              label: 'IMAP/SMTP Email',
              trailing: _IntegrationStatus(isConnected: false),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailConfigurationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'AI Configuration',
          items: [
            _SettingsItem(
              icon: Icons.auto_awesome,
              label: 'AI Receptionist Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AIConfigurationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.record_voice_over_outlined,
              label: 'Tone & Language',
              onTap: () {
                // Navigate to AI Configuration screen (tone is configured there)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AIConfigurationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.reply_outlined,
              label: 'Auto-Response Rules',
              onTap: () {
                // Navigate to AI Configuration screen (auto-response rules are there)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AIConfigurationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.help_outline,
              label: 'FAQ Management',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQManagementScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.reply_all_outlined,
              label: 'Canned Responses',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CannedResponsesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'Notifications',
          items: [
            _SettingsItem(
              icon: Icons.notifications_outlined,
              label: 'Push Notifications',
              trailing: Switch(value: true, onChanged: (v) {}),
              onTap: null,
            ),
            _SettingsItem(
              icon: Icons.email_outlined,
              label: 'Email Notifications',
              trailing: Switch(value: true, onChanged: (v) {}),
              onTap: null,
            ),
            _SettingsItem(
              icon: Icons.sms_outlined,
              label: 'SMS Notifications',
              trailing: Switch(value: false, onChanged: (v) {}),
              onTap: null,
            ),
            _SettingsItem(
              icon: Icons.notifications_active_outlined,
              label: 'Notification Sounds',
              trailing: Switch(value: true, onChanged: (v) {}),
              onTap: null,
            ),
            _SettingsItem(
              icon: Icons.bedtime_outlined,
              label: 'Do Not Disturb Schedule',
              onTap: () {
                // Show DND schedule editor - placeholder for now
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Do Not Disturb Schedule'),
                    content: const Text('DND schedule configuration coming soon. This will allow you to set quiet hours for notifications.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'Appearance',
          items: [
            _SettingsItem(
              icon: Icons.palette_outlined,
              label: 'Theme',
              trailing: Text(
                _getThemeModeLabel(_themeMode),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () => _showThemeSelector(context),
            ),
            _SettingsItem(
              icon: Icons.color_lens_outlined,
              label: 'Accent Color',
              onTap: () {
                // Show accent color picker - placeholder for now
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Accent Color'),
                    content: const Text('Accent color customization coming soon. The app currently uses the default Swiftlead theme colors.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.view_compact_outlined,
              label: 'Density',
              trailing: Text(
                'Comfortable',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                // Show density selector - placeholder for now
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Display Density'),
                    content: const Text('Display density customization coming soon. Choose between Compact, Comfortable, and Spacious layouts.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.language_outlined,
              label: 'App Preferences',
              trailing: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppPreferencesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        _SettingsSection(
          title: 'Data & Privacy',
          items: [
            _SettingsItem(
              icon: Icons.download_outlined,
              label: 'Data Export',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataExportScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.receipt_long_outlined,
              label: 'Invoice Customization',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvoiceCustomizationScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.delete_outline,
              label: 'Delete Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountDeletionScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegalScreen(),
                  ),
                );
              },
            ),
            _SettingsItem(
              icon: Icons.description_outlined,
              label: 'Terms of Service',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegalScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscription',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Swiftlead Pro',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '£199 / month',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionBillingScreen(),
                    ),
                  );
                },
                child: const Text('Manage Plan'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          const Divider(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Next billing date: December 2, 2025',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            'Payment method: •••• 4242',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(SwiftleadTokens.errorRed),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Delete account with confirmation
                _showDeleteConfirmation(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(SwiftleadTokens.errorRed),
                side: const BorderSide(
                  color: Color(SwiftleadTokens.errorRed),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Logout
              },
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          TextButton(
            onPressed: () => _showClearCacheConfirmation(context),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'Auto';
    }
  }

  void _showThemeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Auto (System)'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  widget.onThemeChanged(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  widget.onThemeChanged(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                if (value != null) {
                  widget.onThemeChanged(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will clear all locally cached data. You may need to sign in again. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearCache();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(SwiftleadTokens.primaryTeal),
            ),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (mounted) {
        Toast.show(
          context,
          message: 'Cache cleared successfully',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        Toast.show(
          context,
          message: 'Failed to clear cache: $e',
          type: ToastType.error,
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and will permanently delete all your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete account
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(SwiftleadTokens.errorRed),
            ),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: SwiftleadTokens.spaceM,
            bottom: SwiftleadTokens.spaceS,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ),
        FrostedContainer(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: SwiftleadTokens.spaceXL,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.06)
                  : Colors.white.withOpacity(0.08),
            ),
            itemBuilder: (context, index) => items[index],
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.75)
            : Colors.white.withOpacity(0.8),
      ),
      title: Text(label),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _IntegrationStatus extends StatelessWidget {
  final bool isConnected;

  const _IntegrationStatus({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isConnected
                ? const Color(SwiftleadTokens.successGreen)
                : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceXS),
        Text(
          isConnected ? 'Connected' : 'Not Connected',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: SwiftleadTokens.spaceXS),
        const Icon(Icons.chevron_right, size: 16),
      ],
    );
  }
}

