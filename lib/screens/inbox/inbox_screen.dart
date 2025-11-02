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
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../../models/message.dart';
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
  int _unreadCount = 0;
  int _activeFilters = 0;
  List<MessageThread> _threads = [];
  List<MessageThread> _filteredThreads = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      // Load from mock repository
      _threads = await MockMessages.fetchAllThreads();
      _unreadCount = await MockMessages.getUnreadCount();
    } else {
      // TODO: Load from live backend
    }

    _applyFilter();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    if (_selectedChannel == 'All') {
      _filteredThreads = List.from(_threads);
    } else {
      final channelMap = {
        'SMS': MessageChannel.sms,
        'WhatsApp': MessageChannel.whatsapp,
        'Email': MessageChannel.email,
        'Facebook': MessageChannel.facebook,
        'Instagram': MessageChannel.instagram,
      };
      final channel = channelMap[_selectedChannel];
      if (channel != null) {
        _filteredThreads = _threads.where((t) => t.channel == channel).toList();
      } else {
        _filteredThreads = List.from(_threads);
      }
    }

    // Sort: Pinned → Unread → Recent
    _filteredThreads.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      if (a.unreadCount > 0 != b.unreadCount > 0) {
        return a.unreadCount > 0 ? -1 : 1;
      }
      return b.lastMessageTime.compareTo(a.lastMessageTime);
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
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        top: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
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
                      setState(() {
                        _selectedChannel = channel;
                        _applyFilter();
                      });
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
            onRefresh: _loadMessages,
            child: _buildChatList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    if (_filteredThreads.isEmpty) {
      return EmptyStateCard(
        title: 'No conversations yet',
        description: _selectedChannel == 'All'
            ? 'All caught up! Your inbox is empty.'
            : 'No conversations in $_selectedChannel.',
        icon: Icons.inbox_outlined,
        actionLabel: 'Start conversation',
        onAction: () {},
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
      itemCount: _filteredThreads.length,
      itemBuilder: (context, index) {
        final thread = _filteredThreads[index];
        final isPinned = thread.isPinned;
        final isUnread = thread.unreadCount > 0;
        final channelName = thread.channel.displayName;
        
        return Dismissible(
          key: Key('chat_${thread.id}'),
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
                    contactName: thread.contactName,
                    channel: channelName,
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
                    channel: channelName,
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
                                thread.contactName,
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
                              _formatRelativeTime(thread.lastMessageTime),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                thread.lastMessage,
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
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(SwiftleadTokens.primaryTeal),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${thread.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!isUnread && thread.status == MessageStatus.delivered)
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

  String _formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    }
  }
}
