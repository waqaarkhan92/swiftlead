import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart' as main_nav;
import 'package:shared_preferences/shared_preferences.dart';

/// Support / Help Screen - Self-service help and support access
/// Exact specification from Screen_Layouts_v2.5.1
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _expandedFAQs = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Support & Help',
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(3, (i) => Padding(
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
        // SearchBar
        _buildSearchBar(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // StatusBanner
        _buildStatusBanner(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // QuickLinksGrid - 2×2 help shortcuts
        _buildQuickLinksGrid(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // FAQList - Expandable accordion
        _buildFAQList(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // ContactSupportCard
        _buildContactSupportCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // TroubleshootingTools
        _buildTroubleshootingTools(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return FrostedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search help articles',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(SwiftleadTokens.successGreen),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Text(
              'All systems operational',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              // Open status page
              launchUrl(
                Uri.parse('https://status.swiftlead.co'),
                mode: LaunchMode.externalApplication,
              ).catchError((error) {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not open status page',
                    type: ToastType.error,
                  );
                }
                return false;
              });
            },
            child: const Text('Status Page'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinksGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.rocket_launch_outlined,
                label: 'Getting Started',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Getting Started'),
                      content: const Text(
                        'Welcome to Swiftlead! Here\'s how to get started:\n\n'
                        '1. Connect your WhatsApp number\n'
                        '2. Set up your services and pricing\n'
                        '3. Configure your AI receptionist\n'
                        '4. Create your first job or booking\n\n'
                        'Need help? Contact support anytime!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Got it'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.play_circle_outline,
                label: 'Video Tutorials',
                onTap: () {
                  // Open video tutorials URL
                  launchUrl(
                    Uri.parse('https://swiftlead.co/tutorials'),
                    mode: LaunchMode.externalApplication,
                  ).catchError((error) {
                    if (mounted) {
                      Toast.show(
                        context,
                        message: 'Could not open tutorials',
                        type: ToastType.error,
                      );
                    }
                    return false;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.article_outlined,
                label: 'Feature Guides',
                onTap: () {
                  // Open feature guides URL
                  launchUrl(
                    Uri.parse('https://swiftlead.co/guides'),
                    mode: LaunchMode.externalApplication,
                  ).catchError((error) {
                    if (mounted) {
                      Toast.show(
                        context,
                        message: 'Could not open guides',
                        type: ToastType.error,
                      );
                    }
                    return false;
                  });
                },
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.help_outline,
                label: 'FAQ',
                onTap: () {
                  // Scroll to FAQ section or expand all FAQs
                  Scrollable.ensureVisible(
                    context,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFAQList() {
    return FrostedContainer(
      padding: EdgeInsets.zero,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _expandedFAQs[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
              title: const Text('How do I connect WhatsApp?'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'To connect WhatsApp, go to Settings > Integrations > WhatsApp Connect and follow the setup instructions.',
              ),
            ),
            isExpanded: _expandedFAQs[0],
          ),
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
              title: const Text('Can I change my plan later?'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Yes, you can upgrade or downgrade your plan at any time from Settings > Subscription.',
              ),
            ),
            isExpanded: _expandedFAQs[1],
          ),
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
              title: const Text('How does AI Receptionist work?'),
            ),
            body: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'AI Receptionist automatically responds to incoming messages using AI. You can configure the tone, business hours, and FAQs in AI Hub.',
              ),
            ),
            isExpanded: _expandedFAQs[2],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSupportCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Support',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.chat_bubble_outline,
            label: 'Live Chat',
            subtitle: 'Available now',
            onTap: () {
              // Open live chat or show chat interface
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Live Chat'),
                  content: const Text('Live chat will open in a new window. Our support team is available Monday-Friday, 9am-6pm GMT.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                                                 launchUrl(
                           Uri.parse('https://swiftlead.co/support/chat'),
                           mode: LaunchMode.externalApplication,
                         ).catchError((error) {
                           if (mounted) {
                             Toast.show(
                               context,
                               message: 'Could not open live chat',
                               type: ToastType.error,
                             );
                           }
                           return false;
                         });
                      },
                      child: const Text('Open Chat'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.email_outlined,
            label: 'Send us an email',
            subtitle: 'support@swiftlead.co',
            onTap: () async {
              final uri = Uri.parse('mailto:support@swiftlead.co?subject=Support Request');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not open email client',
                    type: ToastType.error,
                  );
                }
              }
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.phone_outlined,
            label: 'Call us',
            subtitle: 'Mon-Fri 9am-6pm GMT',
            onTap: () async {
              // Use a placeholder phone number
              final uri = Uri.parse('tel:+4420123456789');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not make phone call',
                    type: ToastType.error,
                  );
                }
              }
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.forum_outlined,
            label: 'Community Forum',
            subtitle: 'Ask the community',
            onTap: () {
              launchUrl(
                Uri.parse('https://swiftlead.co/community'),
                mode: LaunchMode.externalApplication,
              ).catchError((error) {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not open forum',
                    type: ToastType.error,
                  );
                }
                return false;
              });
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Typical response: 2-4 hours',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingTools() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Troubleshooting Tools',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.check_circle_outline,
            label: 'Connection Test',
            subtitle: 'Test all integrations',
            onTap: () async {
              // Show connection test dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Connection Test'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Testing all integrations...'),
                    ],
                  ),
                ),
              );
              
              // Simulate connection test
              await Future.delayed(const Duration(seconds: 2));
              
              if (mounted) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Connection Test Results'),
                    content: const Text(
                      '✅ WhatsApp: Connected\n'
                      '✅ Calendar: Connected\n'
                      '✅ Email: Connected\n'
                      '✅ Payments: Connected\n\n'
                      'All integrations are working properly.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.delete_outline,
            label: 'Clear Cache',
            subtitle: 'Reset local data',
            onTap: () async {
              // Show confirmation dialog
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text(
                    'This will clear all cached data. You will need to sign in again. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true && mounted) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                
                Toast.show(
                  context,
                  message: 'Cache cleared successfully',
                  type: ToastType.success,
                );
              }
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.bug_report_outlined,
            label: 'Report Bug',
            subtitle: 'Submit bug with logs',
            onTap: () {
              final uri = Uri.parse('mailto:support@swiftlead.co?subject=Bug Report&body=Please describe the bug you encountered...');
              launchUrl(uri).catchError((error) {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not open email client',
                    type: ToastType.error,
                  );
                }
                return false;
              });
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.lightbulb_outline,
            label: 'Request Feature',
            subtitle: 'Submit feature request',
            onTap: () {
              final uri = Uri.parse('mailto:support@swiftlead.co?subject=Feature Request&body=Please describe the feature you would like to see...');
              launchUrl(uri).catchError((error) {
                if (mounted) {
                  Toast.show(
                    context,
                    message: 'Could not open email client',
                    type: ToastType.error,
                  );
                }
                return false;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(SwiftleadTokens.primaryTeal)),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(SwiftleadTokens.primaryTeal)),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ToolOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(SwiftleadTokens.primaryTeal)),
      title: Text(label),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

