import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Contact Details',
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
            ),
            child: const Center(
              child: Text(
                'JS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Name
          Text(
            'John Smith',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          
          // Contact Info
          Text(
            'john.smith@example.com',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '+44 20 1234 5678',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.message,
                label: 'Message',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                onTap: () {},
              ),
              _QuickActionButton(
                icon: Icons.work_outline,
                label: 'Create Job',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageProgressBar() {
    final stages = ['Lead', 'Prospect', 'Customer', 'Repeat Customer'];
    final currentStage = 'Prospect';
    final currentIndex = stages.indexOf(currentStage);

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
            widthFactor: (currentIndex + 1) / stages.length,
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
    const score = 75;
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
              _InfoRow(label: 'Email', value: 'john.smith@example.com'),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Phone', value: '+44 20 1234 5678'),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Address', value: '123 Main St, London'),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Source', value: 'Website'),
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

