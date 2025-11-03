import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';
import '../../models/contact.dart';
import '../../mock/mock_contacts.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../inbox/inbox_thread_screen.dart';
import '../jobs/create_edit_job_screen.dart';

/// Contact Detail Screen - Comprehensive contact view
/// Exact specification from UI_Inventory_v2.5.1
class ContactDetailScreen extends StatefulWidget {
  final String contactId;

  const ContactDetailScreen({
    super.key,
    required this.contactId,
  });

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  int _selectedTab = 0;
  Contact? _contact;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final contact = await MockContacts.fetchById(widget.contactId);
      if (mounted) {
        setState(() {
          _contact = contact;
          _isLoading = false;
          if (contact == null) {
            _error = 'Contact not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading contact: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  void _handleCreateQuoteFromContact() {
    if (_contact == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuoteScreen(
          initialData: {
            'clientName': _contact!.name,
            'taxRate': 20.0,
          },
        ),
      ),
    ).then((_) {
      Toast.show(
        context,
        message: 'Quote created for contact',
        type: ToastType.success,
      );
    });
  }

  void _handleMessageContact() {
    if (_contact == null) return;
    
    // Determine channel - use SMS as default, could be enhanced
    final channel = 'SMS';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxThreadScreen(
          contactName: _contact!.name,
          channel: channel,
          contactId: _contact!.id,
        ),
      ),
    );
  }

  void _handleCreateJobFromContact() {
    if (_contact == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditJobScreen(
          initialData: {
            'clientName': _contact!.name,
          },
        ),
      ),
    );
  }

  void _handleCallContact() async {
    if (_contact == null || _contact!.phone == null) {
      Toast.show(
        context,
        message: 'Phone number not available',
        type: ToastType.error,
      );
      return;
    }
    
    final uri = Uri.parse('tel:${_contact!.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Cannot make phone call',
          type: ToastType.error,
        );
      }
    }
  }

  void _handleEmailContact() async {
    if (_contact == null || _contact!.email == null) {
      Toast.show(
        context,
        message: 'Email address not available',
        type: ToastType.error,
      );
      return;
    }
    
    final uri = Uri.parse('mailto:${_contact!.email}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Cannot open email',
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: _isLoading ? 'Loading...' : (_contact?.name ?? 'Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SkeletonLoader(
            width: double.infinity,
            height: 100,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ],
      );
    }

    if (_error != null || _contact == null) {
      return Center(
        child: EmptyStateCard(
          title: 'Contact not found',
          description: _error ?? 'Unable to load contact details',
          icon: Icons.person_off,
          actionLabel: 'Retry',
          onAction: _loadContact,
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // ContactProfileCard
          _buildProfileCard(),
          
          // TabBar
          TabBar(
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Timeline'),
              Tab(text: 'Notes'),
              Tab(text: 'Related'),
            ],
            onTap: (index) {
              setState(() => _selectedTab = index);
            },
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildTimelineTab(),
                _buildNotesTab(),
                _buildRelatedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_contact == null) return const SizedBox.shrink();
    
    return FrostedContainer(
      margin: const EdgeInsets.all(SwiftleadTokens.spaceM),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
              image: _contact!.avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_contact!.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _contact!.avatarUrl == null
                ? Center(
                    child: Text(
                      _getInitials(_contact!.name),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Name
          Text(
            _contact!.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          
          // Contact Info
          if (_contact!.email != null)
            Text(
              _contact!.email!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (_contact!.phone != null)
            Text(
              _contact!.phone!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (_contact!.company != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              _contact!.company!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Stage Progress Bar
          _buildStageProgressBar(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Score Indicator
          _buildScoreIndicator(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.phone,
                label: 'Call',
                onTap: _handleCallContact,
              ),
              _QuickActionButton(
                icon: Icons.message,
                label: 'Message',
                onTap: _handleMessageContact,
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                onTap: _handleEmailContact,
              ),
              _QuickActionButton(
                icon: Icons.work_outline,
                label: 'Create Job',
                onTap: _handleCreateJobFromContact,
              ),
              _QuickActionButton(
                icon: Icons.description,
                label: 'Create Quote',
                onTap: _handleCreateQuoteFromContact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageProgressBar() {
    if (_contact == null) return const SizedBox.shrink();
    
    final stages = ['Lead', 'Prospect', 'Customer', 'Repeat Customer'];
    final currentStage = _contact!.stage.displayName;
    final currentIndex = stages.indexWhere((s) => s == currentStage);
    final displayIndex = currentIndex >= 0 ? currentIndex : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lifecycle Stage',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.06)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: (displayIndex + 1) / stages.length,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          currentStage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreIndicator() {
    if (_contact == null) return const SizedBox.shrink();
    
    final score = _contact!.score;
    final classification = score >= 80 ? 'Hot' : (score >= 60 ? 'Warm' : 'Cold');
    final color = score >= 80 
        ? const Color(SwiftleadTokens.errorRed)
        : (score >= 60 ? const Color(SwiftleadTokens.warningYellow) : const Color(SwiftleadTokens.infoBlue));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lead Score',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$score',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              classification,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              if (_contact!.email != null) ...[
                _InfoRow(label: 'Email', value: _contact!.email!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.phone != null) ...[
                _InfoRow(label: 'Phone', value: _contact!.phone!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.company != null) ...[
                _InfoRow(label: 'Company', value: _contact!.company!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.source != null) ...[
                _InfoRow(label: 'Source', value: _contact!.source!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              _InfoRow(label: 'Stage', value: _contact!.stage.displayName),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Tags', value: _contact!.tags.isEmpty ? 'None' : _contact!.tags.join(', ')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity Timeline',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Timeline items would go here
              _TimelineItem(
                icon: Icons.message,
                title: 'Message received',
                subtitle: 'From John via WhatsApp',
                time: '2 hours ago',
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _TimelineItem(
                icon: Icons.work,
                title: 'Job created',
                subtitle: 'Kitchen sink repair',
                time: '1 day ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Add Note'),
                  ),
                ],
              ),
              // Notes list would go here
              Text(
                'No notes yet',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Items',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Jobs, Quotes, Invoices related to this contact',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(SwiftleadTokens.primaryTeal),
            size: 20,
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

