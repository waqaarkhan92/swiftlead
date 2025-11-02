import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/components/chat_bubble.dart';
import '../../widgets/components/date_separator.dart';
import '../../theme/tokens.dart';

/// MessageSearchScreen - Full-text search for messages
/// Exact specification from UI_Inventory_v2.5.1
class MessageSearchScreen extends StatefulWidget {
  const MessageSearchScreen({super.key});

  @override
  State<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends State<MessageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _hasResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Search Messages',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // SearchBar
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SwiftleadSearchBar(
              controller: _searchController,
              hintText: 'Search messages, contacts, or keywords...',
              onChanged: (value) {
                setState(() {
                  _isSearching = value.isNotEmpty;
                  _hasResults = value.isNotEmpty; // Replace with actual search
                });
              },
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? _hasResults
                    ? _buildSearchResults()
                    : _buildEmptyState()
                : _buildSearchTips(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTips() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Search Tips',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        _TipItem(
          icon: Icons.search,
          tip: 'Search by contact name, phone number, or email',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.message,
          tip: 'Search message content across all channels',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.calendar_today,
          tip: 'Use date filters to narrow results',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.filter_list,
          tip: 'Filter by channel (WhatsApp, SMS, Email, etc.)',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateCard(
      title: 'No results found',
      description: 'Try different keywords or check your filters.',
      icon: Icons.search_off,
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Search Results',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        DateSeparator(date: DateTime.now()),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ChatBubble(
          message: 'Found matching message: "Can you schedule the repair?"',
          type: BubbleType.inbound,
          timestamp: '2 hours ago',
          senderName: 'John Smith',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ChatBubble(
          message: 'Response: "Yes, we can come tomorrow at 2pm."',
          type: BubbleType.outbound,
          timestamp: '1 hour ago',
        ),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String tip;

  const _TipItem({
    required this.icon,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(SwiftleadTokens.primaryTeal),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: Text(
            tip,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

