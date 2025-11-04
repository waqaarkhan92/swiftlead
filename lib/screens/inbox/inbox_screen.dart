import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
import '../../mock/mock_contacts.dart';
import '../../models/message.dart';
import 'inbox_thread_screen.dart';
import 'message_search_screen.dart';
import '../../widgets/forms/inbox_filter_sheet.dart';
import '../../widgets/forms/compose_message_sheet.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/context_menu.dart';
import '../../widgets/components/internal_notes_modal.dart';
import '../../widgets/forms/thread_assignment_sheet.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/components/conversation_preview_sheet.dart';
import '../../widgets/components/priority_badge.dart';
import 'scheduled_messages_screen.dart';
import '../main_navigation.dart' as main_nav;

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
  InboxFilters? _currentFilters;
  bool _isBatchMode = false;
  Set<String> _selectedThreadIds = {};

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      // Load from mock repository
      final allThreads = await MockMessages.fetchAllThreads();
      // Filter out threads from blocked contacts
      _threads = allThreads.where((t) => !MockContacts.isContactBlocked(t.contactId)).toList();
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
    if (_currentFilters != null) {
      _applyAdvancedFilters(_currentFilters!);
      return;
    }

    // Legacy channel-based filtering (for backward compatibility)
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

    // Sort: Pinned → Priority (High → Medium → Low) → Unread → Recent
    _filteredThreads.sort((a, b) {
      // Pinned first
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      
      // Then by priority (High → Medium → Low → null)
      final priorityOrder = {
        ThreadPriority.high: 0,
        ThreadPriority.medium: 1,
        ThreadPriority.low: 2,
        null: 3,
      };
      final aPriorityOrder = priorityOrder[a.priority] ?? 3;
      final bPriorityOrder = priorityOrder[b.priority] ?? 3;
      if (aPriorityOrder != bPriorityOrder) {
        return aPriorityOrder.compareTo(bPriorityOrder);
      }
      
      // Then unread
      if (a.unreadCount > 0 != b.unreadCount > 0) {
        return a.unreadCount > 0 ? -1 : 1;
      }
      
      // Finally by recency
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
  }

  void _applyAdvancedFilters(InboxFilters filters) {
    _filteredThreads = List.from(_threads);

    // Channel filter
    if (!filters.channelFilters.contains('All') && filters.channelFilters.isNotEmpty) {
      final channelMap = {
        'SMS': MessageChannel.sms,
        'WhatsApp': MessageChannel.whatsapp,
        'Email': MessageChannel.email,
        'Facebook': MessageChannel.facebook,
        'Instagram': MessageChannel.instagram,
      };
      _filteredThreads = _filteredThreads.where((thread) {
        final channelName = channelMap.entries
            .firstWhere((e) => e.value == thread.channel, orElse: () => MapEntry('', MessageChannel.sms))
            .key;
        return filters.channelFilters.contains(channelName);
      }).toList();
    }

    // Status filter - OR logic: show threads that match ANY selected status
    if (!filters.statusFilters.contains('All') && filters.statusFilters.isNotEmpty) {
      _filteredThreads = _filteredThreads.where((thread) {
        // Check if thread matches any of the selected status filters
        if (filters.statusFilters.contains('Unread') && thread.unreadCount > 0) return true;
        if (filters.statusFilters.contains('Read') && thread.unreadCount == 0) return true;
        if (filters.statusFilters.contains('Pinned') && thread.isPinned) return true;
        if (filters.statusFilters.contains('Archived')) {
          // Check if archived (would need archived tracking in model)
          // For now, skip archived filter
        }
        return false;
      }).toList();
    }

    // Date range filter
    if (filters.dateRange != 'All Time') {
      final now = DateTime.now();
      DateTime? startDate;
      
      switch (filters.dateRange) {
        case 'Today':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'This Week':
          // Start of current week (Monday)
          final daysFromMonday = now.weekday - 1;
          startDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysFromMonday));
          break;
        case 'This Month':
          startDate = DateTime(now.year, now.month, 1);
          break;
        case 'Custom':
          startDate = filters.customStartDate;
          break;
      }

      if (startDate != null) {
        final endDate = filters.customEndDate ?? now;
        _filteredThreads = _filteredThreads.where((thread) {
          return thread.lastMessageTime.isAfter(startDate!) && 
                 thread.lastMessageTime.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();
      }
    }

    // Priority filter - OR logic: show threads that match ANY selected priority
    if (!filters.priorityFilters.contains('All') && filters.priorityFilters.isNotEmpty) {
      _filteredThreads = _filteredThreads.where((thread) {
        if (thread.priority == null) return false;
        final priorityName = thread.priority!.name.substring(0, 1).toUpperCase() + 
                           thread.priority!.name.substring(1);
        return filters.priorityFilters.contains(priorityName);
      }).toList();
    }

    // Lead Source filter (Marketing Attribution) - OR logic
    if (!filters.leadSourceFilters.contains('All') && filters.leadSourceFilters.isNotEmpty) {
      // Map filter strings to LeadSource enum values
      final filterToLeadSource = {
        'Google Ads': LeadSource.googleAds,
        'Facebook Ads': LeadSource.facebookAds,
        'Website': LeadSource.website,
        'Referral': LeadSource.referral,
        'Direct': LeadSource.direct,
      };
      
      final selectedSources = filters.leadSourceFilters
          .where((f) => filterToLeadSource.containsKey(f))
          .map((f) => filterToLeadSource[f]!)
          .toSet();
      
      _filteredThreads = _filteredThreads.where((thread) {
        if (thread.leadSource == null) return false;
        return selectedSources.contains(thread.leadSource);
      }).toList();
    }

    // Sort: Pinned → Priority (High → Medium → Low) → Unread → Recent
    _filteredThreads.sort((a, b) {
      // Pinned first
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      
      // Then by priority (High → Medium → Low → null)
      final priorityOrder = {
        ThreadPriority.high: 0,
        ThreadPriority.medium: 1,
        ThreadPriority.low: 2,
        null: 3,
      };
      final aPriorityOrder = priorityOrder[a.priority] ?? 3;
      final bPriorityOrder = priorityOrder[b.priority] ?? 3;
      if (aPriorityOrder != bPriorityOrder) {
        return aPriorityOrder.compareTo(bPriorityOrder);
      }
      
      // Then unread
      if (a.unreadCount > 0 != b.unreadCount > 0) {
        return a.unreadCount > 0 ? -1 : 1;
      }
      
      // Finally by recency
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: _isBatchMode 
            ? '${_selectedThreadIds.length} selected'
            : 'Inbox',
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
                onPressed: () async {
                  final filters = await InboxFilterSheet.show(
                    context: context,
                    initialFilters: _currentFilters,
                  );
                  if (filters != null) {
                    setState(() {
                      _currentFilters = filters;
                      _activeFilters = filters.activeFilterCount;
                      // Apply filters inside setState to ensure UI updates
                      _applyAdvancedFilters(filters);
                    });
                  } else {
                    // User cancelled - clear filters
                    setState(() {
                      _currentFilters = null;
                      _activeFilters = 0;
                      _applyFilter(); // Reapply default filter
                    });
                  }
                },
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
          if (_isBatchMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isBatchMode = false;
                  _selectedThreadIds.clear();
                });
              },
            ),
          if (!_isBatchMode)
          IconButton(
            icon: const Icon(Icons.schedule_outlined),
            tooltip: 'Scheduled Messages',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduledMessagesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await ComposeMessageSheet.show(context: context);
              if (result != null && mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InboxThreadScreen(
                      contactName: result.contactName,
                      channel: result.channel,
                      contactId: result.contactId,
                    ),
                  ),
                );
              }
            },
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
        
        // Batch Action Bar
        if (_isBatchMode)
          FrostedContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: SwiftleadTokens.spaceM,
              vertical: SwiftleadTokens.spaceS,
            ),
            borderRadius: 0,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBatchActionButton(
                    icon: Icons.archive_outlined,
                    label: 'Archive',
                    onPressed: _handleBatchArchive,
                  ),
                  _buildBatchActionButton(
                    icon: Icons.mark_email_read_outlined,
                    label: 'Mark Read',
                    onPressed: _handleBatchMarkRead,
                  ),
                  _buildBatchActionButton(
                    icon: Icons.push_pin_outlined,
                    label: 'Pin',
                    onPressed: _handleBatchPin,
                  ),
                  _buildBatchActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    onPressed: _handleBatchDelete,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildBatchActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SwiftleadTokens.spaceS,
          vertical: SwiftleadTokens.spaceS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDestructive 
                  ? const Color(SwiftleadTokens.errorRed)
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDestructive 
                    ? const Color(SwiftleadTokens.errorRed)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleBatchArchive() {
    if (_selectedThreadIds.isEmpty) return;
    
    final count = _selectedThreadIds.length;
    final threadIdsCopy = Set<String>.from(_selectedThreadIds);
    
    for (final threadId in threadIdsCopy) {
      MockMessages.archiveThread(threadId);
    }
    
    setState(() {
      _isBatchMode = false;
      _selectedThreadIds.clear();
    });
    
    _loadMessages();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count conversations archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            for (final threadId in threadIdsCopy) {
              MockMessages.unarchiveThread(threadId);
            }
            _loadMessages();
          },
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _handleBatchMarkRead() {
    if (_selectedThreadIds.isEmpty) return;
    
    final count = _selectedThreadIds.length;
    final threadIdsCopy = Set<String>.from(_selectedThreadIds);
    
    for (final threadId in threadIdsCopy) {
      MockMessages.markThreadRead(threadId);
    }
    
    setState(() {
      _isBatchMode = false;
      _selectedThreadIds.clear();
    });
    
    _loadMessages();
    
    Toast.show(
      context,
      message: '$count conversations marked as read',
      type: ToastType.success,
    );
  }
  
  void _handleBatchPin() {
    if (_selectedThreadIds.isEmpty) return;
    
    final count = _selectedThreadIds.length;
    final threadIdsCopy = Set<String>.from(_selectedThreadIds);
    
    for (final threadId in threadIdsCopy) {
      MockMessages.pinThread(threadId);
    }
    
    setState(() {
      _isBatchMode = false;
      _selectedThreadIds.clear();
    });
    
    _loadMessages();
    
    Toast.show(
      context,
      message: '$count conversations pinned',
      type: ToastType.success,
    );
  }
  
  void _handleBatchDelete() {
    if (_selectedThreadIds.isEmpty) return;
    
    final count = _selectedThreadIds.length;
    final threadIdsCopy = Set<String>.from(_selectedThreadIds);
    
    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete $count conversations',
      description: 'Are you sure you want to delete these conversations? This action cannot be undone.',
      primaryActionLabel: 'Delete',
      isDestructive: true,
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        for (final threadId in threadIdsCopy) {
          MockMessages.deleteThread(threadId);
        }
        
        setState(() {
          _isBatchMode = false;
          _selectedThreadIds.clear();
        });
        
        _loadMessages();
        
        Toast.show(
          context,
          message: '$count conversations deleted',
          type: ToastType.success,
        );
      }
    });
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
        final isPinned = MockMessages.isThreadPinned(thread.id) || thread.isPinned; // Check both set and original value
        final isUnread = thread.unreadCount > 0;
        final isMuted = MockMessages.isThreadMuted(thread.id);
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
          onDismissed: (direction) async {
            HapticFeedback.mediumImpact();
            final threadId = thread.id;
            final threadName = thread.contactName;
            
            if (direction == DismissDirection.startToEnd) {
              // Archive
              final matchingThreads = _threads.where((t) => t.id == threadId);
              final archivedThread = matchingThreads.isNotEmpty ? matchingThreads.first : null;
              
              if (archivedThread != null) {
                if (kUseMockData) {
                  await MockMessages.archiveThread(threadId);
                } else {
                  // TODO: Call archive-thread edge function
                }
                
                // Remove from local list
                setState(() {
                  _threads.removeWhere((t) => t.id == threadId);
                  _filteredThreads.removeWhere((t) => t.id == threadId);
                });
                
                // Show undo snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Conversation archived'),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        // Restore thread
                        if (kUseMockData) {
                          MockMessages.unarchiveThread(threadId);
                        }
                        setState(() {
                          _threads.insert(0, archivedThread);
                          _filteredThreads.insert(0, archivedThread);
                        });
                      },
                    ),
                    duration: const Duration(seconds: 4),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } else {
              // Delete
              if (kUseMockData) {
                await MockMessages.deleteThread(threadId);
              } else {
                // TODO: Call delete thread API
              }
              
              // Remove from local list
              setState(() {
                _threads.removeWhere((t) => t.id == threadId);
                _filteredThreads.removeWhere((t) => t.id == threadId);
              });
              
              // Show undo snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Conversation deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      // TODO: Restore thread (would need to restore from deleted state)
                      // For now, just reload
                      _loadMessages();
                    },
                  ),
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: GestureDetector(
            onTap: () async {
              if (_isBatchMode) {
                // Toggle selection in batch mode
                setState(() {
                  if (_selectedThreadIds.contains(thread.id)) {
                    _selectedThreadIds.remove(thread.id);
                  } else {
                    _selectedThreadIds.add(thread.id);
                  }
                  if (_selectedThreadIds.isEmpty) {
                    _isBatchMode = false;
                  }
                });
              } else {
                // Normal tap - open thread
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InboxThreadScreen(
                      contactName: thread.contactName,
                      channel: channelName,
                      contactId: thread.contactId,
                      threadId: thread.id,
                    ),
                  ),
                );
                
                // If mute/archive state changed, refresh the list
                if (result == true && mounted) {
                  _loadMessages(); // Reload to update list (removes archived threads)
                }
              }
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              if (!_isBatchMode) {
                // Show conversation preview (v2.5.1 enhancement)
                ConversationPreviewSheet.show(
                  context: context,
                  thread: thread,
                ).then((action) {
                  if (action != null && mounted) {
                    switch (action) {
                      case 'open':
                        // Open full conversation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InboxThreadScreen(
                              contactName: thread.contactName,
                              channel: thread.channel.displayName,
                              contactId: thread.contactId,
                              threadId: thread.id,
                            ),
                          ),
                        );
                        break;
                      case 'view_contact':
                        // View contact detail
                        // TODO: Navigate to contact detail
                        break;
                      case 'archive':
                        if (kUseMockData) {
                          MockMessages.archiveThread(thread.id);
                        } else {
                          // TODO: Call archive-thread edge function
                        }
                        _loadMessages();
                        break;
                      case 'toggle_pin':
                        if (thread.isPinned) {
                          MockMessages.unpinThread(thread.id);
                        } else {
                          MockMessages.pinThread(thread.id);
                        }
                        _loadMessages();
                        break;
                    }
                  }
                });
              } else {
                // Toggle selection in batch mode
                setState(() {
                  if (_selectedThreadIds.contains(thread.id)) {
                    _selectedThreadIds.remove(thread.id);
                  } else {
                    _selectedThreadIds.add(thread.id);
                  }
                  if (_selectedThreadIds.isEmpty) {
                    _isBatchMode = false;
                  }
                });
              }
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
                  // Selection checkbox in batch mode
                  if (_isBatchMode) ...[
                    Checkbox(
                      value: _selectedThreadIds.contains(thread.id),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedThreadIds.add(thread.id);
                          } else {
                            _selectedThreadIds.remove(thread.id);
                            if (_selectedThreadIds.isEmpty) {
                              _isBatchMode = false;
                            }
                          }
                        });
                      },
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                  ],
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
                            if (thread.priority != null) ...[
                              const SizedBox(width: SwiftleadTokens.spaceXS),
                              PriorityBadge(
                                priority: thread.priority,
                                compact: true,
                              ),
                            ],
                            if (isMuted) ...[
                              const SizedBox(width: SwiftleadTokens.spaceXS),
                              const Icon(
                                Icons.notifications_off,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ],
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

  void _showContextMenu(BuildContext context, MessageThread thread) {
    final isUnread = thread.unreadCount > 0;
    
    final menuItems = [
      ContextMenuItem(
        icon: Icons.preview_outlined,
        label: 'Preview',
        onTap: () {
          Navigator.pop(context); // Close context menu first
          ConversationPreviewSheet.show(
            context: context,
            thread: thread,
          ).then((action) {
            if (action != null && mounted) {
              switch (action) {
                case 'open':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InboxThreadScreen(
                        contactName: thread.contactName,
                        channel: thread.channel.displayName,
                        contactId: thread.contactId,
                        threadId: thread.id,
                      ),
                    ),
                  );
                  break;
                case 'view_contact':
                  // TODO: Navigate to contact detail
                  break;
                case 'archive':
                  if (kUseMockData) {
                    MockMessages.archiveThread(thread.id);
                  } else {
                    // TODO: Call archive-thread edge function
                  }
                  _loadMessages();
                  break;
                case 'toggle_pin':
                  if (thread.isPinned) {
                    MockMessages.unpinThread(thread.id);
                  } else {
                    MockMessages.pinThread(thread.id);
                  }
                  _loadMessages();
                  break;
              }
            }
          });
        },
      ),
      ContextMenuItem(
        icon: isUnread ? Icons.mark_email_read : Icons.mark_email_unread,
        label: isUnread ? 'Mark as Read' : 'Mark as Unread',
        onTap: () async {
          if (isUnread) {
            if (kUseMockData) {
              await MockMessages.markThreadRead(thread.id);
            } else {
              // TODO: Call mark-read-status edge function
            }
            setState(() {
              final index = _threads.indexWhere((t) => t.id == thread.id);
              if (index != -1) {
                // Update unread count to 0
                _threads[index] = MessageThread(
                  id: _threads[index].id,
                  contactId: _threads[index].contactId,
                  contactName: _threads[index].contactName,
                  channel: _threads[index].channel,
                  lastMessage: _threads[index].lastMessage,
                  lastMessageTime: _threads[index].lastMessageTime,
                  unreadCount: 0,
                  isPinned: _threads[index].isPinned,
                  status: _threads[index].status,
                  messages: _threads[index].messages,
                );
              }
              _applyFilter();
            });
            Toast.show(
              context,
              message: 'Marked as read',
              type: ToastType.success,
            );
          } else {
            if (kUseMockData) {
              await MockMessages.markThreadUnread(thread.id);
            } else {
              // TODO: Call mark-read-status edge function
            }
            setState(() {
              final index = _threads.indexWhere((t) => t.id == thread.id);
              if (index != -1) {
                // Update unread count to 1
                _threads[index] = MessageThread(
                  id: _threads[index].id,
                  contactId: _threads[index].contactId,
                  contactName: _threads[index].contactName,
                  channel: _threads[index].channel,
                  lastMessage: _threads[index].lastMessage,
                  lastMessageTime: _threads[index].lastMessageTime,
                  unreadCount: 1,
                  isPinned: _threads[index].isPinned,
                  status: _threads[index].status,
                  messages: _threads[index].messages,
                );
              }
              _applyFilter();
            });
            Toast.show(
              context,
              message: 'Marked as unread',
              type: ToastType.success,
            );
          }
        },
      ),
      ContextMenuItem(
        icon: thread.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        label: thread.isPinned ? 'Unpin' : 'Pin',
        onTap: () async {
          if (thread.isPinned) {
            if (kUseMockData) {
              await MockMessages.unpinThread(thread.id);
            }
            setState(() {
              final index = _threads.indexWhere((t) => t.id == thread.id);
              if (index != -1) {
                _threads[index] = MessageThread(
                  id: _threads[index].id,
                  contactId: _threads[index].contactId,
                  contactName: _threads[index].contactName,
                  channel: _threads[index].channel,
                  lastMessage: _threads[index].lastMessage,
                  lastMessageTime: _threads[index].lastMessageTime,
                  unreadCount: _threads[index].unreadCount,
                  isPinned: false,
                  status: _threads[index].status,
                  messages: _threads[index].messages,
                );
              }
              _applyFilter();
            });
            Toast.show(
              context,
              message: 'Thread unpinned',
              type: ToastType.success,
            );
          } else {
            if (kUseMockData) {
              await MockMessages.pinThread(thread.id);
            }
            setState(() {
              final index = _threads.indexWhere((t) => t.id == thread.id);
              if (index != -1) {
                _threads[index] = MessageThread(
                  id: _threads[index].id,
                  contactId: _threads[index].contactId,
                  contactName: _threads[index].contactName,
                  channel: _threads[index].channel,
                  lastMessage: _threads[index].lastMessage,
                  lastMessageTime: _threads[index].lastMessageTime,
                  unreadCount: _threads[index].unreadCount,
                  isPinned: true,
                  status: _threads[index].status,
                  messages: _threads[index].messages,
                );
              }
              _applyFilter();
            });
            Toast.show(
              context,
              message: 'Thread pinned',
              type: ToastType.success,
            );
          }
        },
      ),
      ContextMenuItem(
        icon: Icons.person_add,
        label: 'Assign to Team Member',
        onTap: () {
          ThreadAssignmentSheet.show(
            context: context,
            threadId: thread.id,
            onAssigned: (memberId, memberName) {
              Toast.show(
                context,
                message: 'Assigned to $memberName',
                type: ToastType.success,
              );
            },
          );
        },
      ),
      ContextMenuItem(
        icon: Icons.note_add,
        label: 'Add Note',
        onTap: () {
          InternalNotesModal.show(
            context: context,
            threadId: thread.id,
            onNoteAdded: (note) {
              Toast.show(
                context,
                message: 'Note added',
                type: ToastType.success,
              );
            },
          );
        },
      ),
    ];

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) => _buildContextMenuDialog(dialogContext, menuItems),
    );
  }

  Widget _buildContextMenuDialog(BuildContext context, List<ContextMenuItem> items) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 140,
              top: MediaQuery.of(context).size.height * 0.4,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: SwiftleadTokens.blurModal,
                      sigmaY: SwiftleadTokens.blurModal,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white.withOpacity(0.96)
                            : const Color(0xFF191B1C).withOpacity(0.92),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.08)
                              : Colors.white.withOpacity(0.12),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              Theme.of(context).brightness == Brightness.light ? 0.2 : 0.4,
                            ),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Column(
                            children: [
                              ListTile(
                                leading: item.icon != null
                                    ? Icon(
                                        item.icon,
                                        size: 20,
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                      )
                                    : null,
                                title: Text(item.label),
                                onTap: () {
                                  Navigator.pop(context);
                                  item.onTap?.call();
                                },
                              ),
                              if (index < items.length - 1)
                                Divider(
                                  height: 1,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.08)
                                      : Colors.white.withOpacity(0.08),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
