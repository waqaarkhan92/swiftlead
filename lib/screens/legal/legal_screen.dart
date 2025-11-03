import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart' as main_nav;

/// Legal / Privacy Screen - Legal documents and privacy information
/// Exact specification from Screen_Layouts_v2.5.1
class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Legal / Privacy',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // LegalDocumentList
        FrostedContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _LegalDocumentItem(
                title: 'Privacy Policy',
                lastUpdated: 'Updated: November 1, 2025',
                onTap: () => _showDocument('Privacy Policy'),
              ),
              const Divider(height: 1),
              _LegalDocumentItem(
                title: 'Terms of Service',
                lastUpdated: 'Updated: November 1, 2025',
                onTap: () => _showDocument('Terms of Service'),
              ),
              const Divider(height: 1),
              _LegalDocumentItem(
                title: 'Cookie Policy',
                lastUpdated: 'Updated: November 1, 2025',
                onTap: () => _showDocument('Cookie Policy'),
              ),
              const Divider(height: 1),
              _LegalDocumentItem(
                title: 'Data Processing Agreement',
                lastUpdated: 'Updated: November 1, 2025',
                onTap: () => _showDocument('Data Processing Agreement'),
              ),
              const Divider(height: 1),
              _LegalDocumentItem(
                title: 'GDPR Information',
                lastUpdated: 'Updated: November 1, 2025',
                onTap: () => _showDocument('GDPR Information'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDocument(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              'This is a placeholder for the $title. In a real implementation, this would load the full document from a URL or asset file.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _LegalDocumentItem extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final VoidCallback onTap;

  const _LegalDocumentItem({
    required this.title,
    required this.lastUpdated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        lastUpdated,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

