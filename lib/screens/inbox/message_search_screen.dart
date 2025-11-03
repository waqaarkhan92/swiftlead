import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/components/chat_bubble.dart';
import '../../widgets/components/date_separator.dart';
import '../../theme/tokens.dart';
import '../../mock/mock_messages.dart';
import '../../models/message.dart';

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
  List<Message> _searchResults = [];
  List<MessageThread> _allThreads = [];

  @override
  void initState() {
    super.initState();
    _loadAllMessages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllMessages() async {
    // Load all threads and their messages for search
    _allThreads = await MockMessages.fetchAllThreads();
    setState(() {});
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _hasResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Full-text search across all messages
    final queryLower = query.toLowerCase();
    final results = <Message>[];

    for (final thread in _allThreads) {
      for (final message in thread.messages) {
        // Search in message content
        if (message.content.toLowerCase().contains(queryLower)) {
          results.add(message);
        }
        // Search in contact name
        if (thread.contactName.toLowerCase().contains(queryLower)) {
          results.add(message);
        }
      }
    }

    setState(() {
      _searchResults = results;
      _hasResults = results.isNotEmpty;
    });
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
                _performSearch(value);
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
    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    // Group results by date
    final groupedResults = <DateTime, List<Message>>{};
    for (final message in _searchResults) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      if (!groupedResults.containsKey(date)) {
        groupedResults[date] = [];
      }
      groupedResults[date]!.add(message);
    }

    final sortedDates = groupedResults.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          '${_searchResults.length} result${_searchResults.length != 1 ? 's' : ''} found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ...sortedDates.expand((date) {
          final messages = groupedResults[date]!;
          return [
            DateSeparator(date: date),
            const SizedBox(height: SwiftleadTokens.spaceS),
            ...messages.map((message) {
              // Find thread for this message
              final thread = _allThreads.firstWhere(
                (t) => t.messages.any((m) => m.id == message.id),
                orElse: () => _allThreads.first,
              );
              
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: ChatBubble(
                  message: message.content,
                  type: message.isInbound ? BubbleType.inbound : BubbleType.outbound,
                  timestamp: _formatTime(message.timestamp),
                  senderName: message.isInbound ? thread.contactName : null,
                ),
              );
            }),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ];
        }),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
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

