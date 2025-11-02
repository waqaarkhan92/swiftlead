import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/components/chat_title_row.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import 'inbox_thread_screen.dart';
import 'message_search_screen.dart';

/// InboxScreen - Unified messaging hub
/// Exact specification from Screen_Layouts_v2.5.1
class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _isLoading = true;
  final List<String> _channels = ['All', 'SMS', 'WhatsApp', 'Instagram', 'Facebook', 'Email'];
  String _selectedChannel = 'All';
  int _unreadCount = 24;
  int _activeFilters = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Inbox',
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageSearchScreen(),
                ),
              );
            },
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_outlined),
                onPressed: () {},
              ),
              if (_activeFilters > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(SwiftleadTokens.primaryTeal),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_activeFilters',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Compose new message
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildFAB() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(SwiftleadTokens.primaryTeal),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'New Chat',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (_unreadCount >= 24)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(SwiftleadTokens.errorRed),
                shape: BoxShape.circle,
              ),
              child: Text(
                '+24',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: SkeletonLoader(
            width: double.infinity,
            height: 80,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // ChannelFilterChipsRow - Horizontal scrollable chips
        Container(
          padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
            child: Row(
              children: _channels.map((channel) {
                final isSelected = channel == _selectedChannel;
                final count = channel == 'All' ? null : (channel == 'WhatsApp' ? 15 : 3);
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedChannel = channel);
                    },
                    onLongPress: () {
                      // Tooltip shows channel name on long-press
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$channel messages'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: SwiftleadChip(
                      label: count != null ? '$channel ($count)' : channel,
                      isSelected: isSelected,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // ChatListView - Full-width list with optimized performance
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Pull-to-refresh syncs all channels
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildChatList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    final hasConversations = true; // Replace with actual data check
    
    if (!hasConversations) {
      return EmptyStateCard(
        title: 'No conversations yet',
        description: 'All caught up! Your inbox is empty.',
        icon: Icons.inbox_outlined,
        actionLabel: 'Start conversation',
        onAction: () {},
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
      itemCount: 10, // Example count
      itemBuilder: (context, index) {
        final isPinned = index < 2;
        final isUnread = index % 3 == 0;
        final channel = ['WhatsApp', 'SMS', 'Email', 'Facebook', 'Instagram'][index % 5];
        
        return Dismissible(
          key: Key('chat_$index'),
          direction: DismissDirection.horizontal,
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: const Icon(
              Icons.archive,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.errorRed).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Color(SwiftleadTokens.errorRed),
            ),
          ),
          onDismissed: (direction) {
            HapticFeedback.mediumImpact();
            if (direction == DismissDirection.startToEnd) {
              // Archive
            } else {
              // Delete
            }
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InboxThreadScreen(
                    contactName: _getContactName(index),
                    channel: 'SMS',
                  ),
                ),
              );
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              // Context menu would show here
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Channel Icon Badge
                  ChannelIconBadge(
                    channel: channel,
                    size: 24,
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  
                  // Chat Title Row Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getContactName(index),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPinned)
                              const Icon(
                                Icons.push_pin,
                                size: 14,
                                color: Color(SwiftleadTokens.primaryTeal),
                              ),
                            const SizedBox(width: SwiftleadTokens.spaceXS),
                            Text(
                              _getRelativeTime(index),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getLastMessage(index),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
                                  color: isUnread
                                      ? Theme.of(context).textTheme.bodySmall?.color
                                      : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(SwiftleadTokens.primaryTeal),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (!isUnread && index % 4 == 0)
                              const Icon(
                                Icons.done_all,
                                size: 14,
                                color: Color(SwiftleadTokens.primaryTeal),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getContactName(int index) {
    final names = [
      'John Smith',
      'Sarah Williams',
      'Mike Johnson',
      'Emily Davis',
      'David Brown',
      'Lisa Anderson',
      'Tom Wilson',
      'Emma Thompson',
      'James Miller',
      'Olivia Garcia',
    ];
    return names[index % names.length];
  }

  String _getLastMessage(int index) {
    final messages = [
      'Thanks for the quick response!',
      'When can you start?',
      'That sounds perfect',
      'I need a quote for...',
      'Can we schedule for next week?',
      'The issue is still happening',
      'Payment sent, thanks!',
      'See you tomorrow at 2pm',
      'Could you send more details?',
      'Great work, thank you!',
    ];
    return messages[index % messages.length];
  }

  String _getRelativeTime(int index) {
    final times = [
      'Just now',
      '5m ago',
      '1h ago',
      '2h ago',
      'Yesterday',
      '2 days ago',
      '3 days ago',
      '1 week ago',
      '2 weeks ago',
      '1 month ago',
    ];
    return times[index % times.length];
  }
}
