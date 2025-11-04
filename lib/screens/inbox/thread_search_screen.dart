import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/components/chat_bubble.dart' as chat_bubble show ChatBubble, BubbleType, MessageStatus;
import '../../widgets/components/date_separator.dart';
import '../../theme/tokens.dart';
import '../../models/message.dart' as msg_model;
import '../../mock/mock_messages.dart';

/// ThreadSearchScreen - Search messages within a specific thread
/// Exact specification from UI_Inventory_v2.5.1
class ThreadSearchScreen extends StatefulWidget {
  final String threadId;
  final String contactName;
  final String channel;
  
  const ThreadSearchScreen({
    super.key,
    required this.threadId,
    required this.contactName,
    required this.channel,
  });

  @override
  State<ThreadSearchScreen> createState() => _ThreadSearchScreenState();
}

class _ThreadSearchScreenState extends State<ThreadSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<msg_model.Message> _searchResults = [];
  List<msg_model.Message> _allMessages = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final thread = await MockMessages.fetchThreadById(widget.threadId);
    if (thread != null && mounted) {
      setState(() {
        _allMessages = thread.messages;
      });
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allMessages.where((message) {
        return message.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
      _currentQuery = query; // Store query for highlighting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Search in Conversation',
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
              hintText: 'Search messages in this conversation...',
              onChanged: _performSearch,
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? _searchResults.isNotEmpty
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
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Tips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Search for specific messages in your conversation with ${widget.contactName}.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        _TipItem(
          icon: Icons.search,
          tip: 'Search by keywords or phrases',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.message,
          tip: 'Results show matching messages with context',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.arrow_upward,
          tip: 'Tap a result to jump to that message',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateCard(
      title: 'No results found',
      description: 'Try different keywords or check your spelling.',
      icon: Icons.search_off,
    );
  }

  Widget _buildSearchResults() {
    // Group messages by date
    final groupedResults = <DateTime, List<msg_model.Message>>{};
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

    // Flatten results with date separators
    final items = <Widget>[];
    for (final date in sortedDates) {
      items.add(Padding(
        padding: const EdgeInsets.only(
          top: SwiftleadTokens.spaceM,
          bottom: SwiftleadTokens.spaceS,
        ),
        child: DateSeparator(date: date),
      ));
      
      for (final message in groupedResults[date]!) {
        // Format timestamp
        final now = DateTime.now();
        final difference = now.difference(message.timestamp);
        String timestampStr;
        if (difference.inSeconds < 60) {
          timestampStr = 'Just now';
        } else if (difference.inMinutes < 60) {
          timestampStr = '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          timestampStr = '${difference.inHours}h ago';
        } else if (difference.inDays == 1) {
          timestampStr = 'Yesterday';
        } else if (difference.inDays < 7) {
          timestampStr = '${difference.inDays}d ago';
        } else {
          timestampStr = '${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year}';
        }
        
        // Map msg_model.MessageStatus to ChatBubble MessageStatus
        chat_bubble.MessageStatus? bubbleStatus;
        switch (message.status) {
          case msg_model.MessageStatus.sent:
            bubbleStatus = chat_bubble.MessageStatus.sent;
            break;
          case msg_model.MessageStatus.delivered:
            bubbleStatus = chat_bubble.MessageStatus.delivered;
            break;
          case msg_model.MessageStatus.read:
            bubbleStatus = chat_bubble.MessageStatus.read;
            break;
          case msg_model.MessageStatus.failed:
            bubbleStatus = chat_bubble.MessageStatus.failed;
            break;
          case msg_model.MessageStatus.sending:
            bubbleStatus = chat_bubble.MessageStatus.sending;
            break;
        }
        
        items.add(Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _buildHighlightedMessageBubble(
            message: message,
            timestamp: timestampStr,
            status: bubbleStatus,
          ),
        ));
      }
    }
    
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: items,
    );
  }
  
  /// Build a message bubble with highlighted search matches
  Widget _buildHighlightedMessageBubble({
    required msg_model.Message message,
    required String timestamp,
    chat_bubble.MessageStatus? status,
  }) {
    final isOutbound = !message.isInbound;
    final brightness = Theme.of(context).brightness;
    
    // Build highlighted text if there's a search query
    Widget messageText;
    if (_currentQuery.isNotEmpty) {
      messageText = _buildHighlightedText(
        text: message.content,
        query: _currentQuery,
        isOutbound: isOutbound,
      );
    } else {
      messageText = Text(
        message.content,
        style: TextStyle(
          color: isOutbound
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        mainAxisAlignment: isOutbound
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isOutbound
                    ? const LinearGradient(
                        colors: [
                          Color(SwiftleadTokens.primaryTeal),
                          Color(SwiftleadTokens.accentAqua),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).colors.first
                    : (brightness == Brightness.light
                        ? Colors.black.withOpacity(0.08)
                        : Colors.white.withOpacity(0.12)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: Radius.circular(isOutbound ? 22 : 4),
                  bottomRight: Radius.circular(isOutbound ? 4 : 22),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messageText,
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style: TextStyle(
                          color: isOutbound
                              ? Colors.white.withOpacity(0.7)
                              : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                      if (status != null && isOutbound) ...[
                        const SizedBox(width: 4),
                        Icon(
                          status == chat_bubble.MessageStatus.read
                              ? Icons.done_all
                              : status == chat_bubble.MessageStatus.delivered
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 12,
                          color: status == chat_bubble.MessageStatus.read
                              ? Colors.blue
                              : Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build RichText with highlighted search matches
  Widget _buildHighlightedText({
    required String text,
    required String query,
    required bool isOutbound,
  }) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: isOutbound
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
        ),
      );
    }
    
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];
    int lastIndex = 0;
    
    // Find all matches (case-insensitive)
    int index = textLower.indexOf(queryLower, lastIndex);
    while (index != -1) {
      // Add text before match
      if (index > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, index),
          style: TextStyle(
            color: isOutbound
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 14,
          ),
        ));
      }
      
      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          color: isOutbound
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          backgroundColor: isOutbound
              ? Colors.white.withOpacity(0.3)
              : const Color(SwiftleadTokens.warningYellow).withOpacity(0.4),
        ),
      ));
      
      lastIndex = index + query.length;
      index = textLower.indexOf(queryLower, lastIndex);
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: isOutbound
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 14,
        ),
      ));
    }
    
    return RichText(
      text: TextSpan(children: spans),
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
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
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

