import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Support & Help',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
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
            onPressed: () {},
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
                onTap: () {},
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.play_circle_outline,
                label: 'Video Tutorials',
                onTap: () {},
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
                onTap: () {},
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: _QuickLinkCard(
                icon: Icons.help_outline,
                label: 'FAQ',
                onTap: () {},
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
            // Handle expansion
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
            isExpanded: false,
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
            isExpanded: false,
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
            isExpanded: false,
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
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.email_outlined,
            label: 'Send us an email',
            subtitle: 'support@swiftlead.co',
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.phone_outlined,
            label: 'Call us',
            subtitle: 'Mon-Fri 9am-6pm GMT',
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ContactOption(
            icon: Icons.forum_outlined,
            label: 'Community Forum',
            subtitle: 'Ask the community',
            onTap: () {},
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
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.delete_outline,
            label: 'Clear Cache',
            subtitle: 'Reset local data',
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.bug_report_outlined,
            label: 'Report Bug',
            subtitle: 'Submit bug with logs',
            onTap: () {},
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _ToolOption(
            icon: Icons.lightbulb_outline,
            label: 'Request Feature',
            subtitle: 'Submit feature request',
            onTap: () {},
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

