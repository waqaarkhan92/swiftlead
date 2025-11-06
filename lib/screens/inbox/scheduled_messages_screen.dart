import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/components/channel_icon_badge.dart';
import '../../widgets/forms/schedule_message_sheet.dart';
import '../../theme/tokens.dart';
import '../../models/scheduled_message.dart';
import '../../models/message.dart';
import '../../mock/mock_messages.dart';
import '../../config/mock_config.dart';

/// ScheduledMessagesScreen - List and manage scheduled messages
/// Exact specification from UI_Inventory_v2.5.1
class ScheduledMessagesScreen extends StatefulWidget {
  const ScheduledMessagesScreen({super.key});

  @override
  State<ScheduledMessagesScreen> createState() => _ScheduledMessagesScreenState();
}

class _ScheduledMessagesScreenState extends State<ScheduledMessagesScreen> {
  bool _isLoading = true;
  List<ScheduledMessage> _scheduledMessages = [];

  @override
  void initState() {
    super.initState();
    _loadScheduledMessages();
  }

  Future<void> _loadScheduledMessages() async {
    setState(() {
      _isLoading = true;
    });

    if (kUseMockData) {
      _scheduledMessages = await MockMessages.fetchAllScheduled();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Today';
    } else if (date == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr at $timeStr';
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return 'In ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'In ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'In ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Now';
    }
  }

  Future<void> _editScheduledMessage(ScheduledMessage message) async {
    final updated = await ScheduleMessageSheet.show(
      context: context,
      threadId: message.threadId,
      contactId: message.contactId,
      channel: message.channel,
      content: message.content,
      mediaUrls: message.mediaUrls,
    );

    if (updated != null) {
      await MockMessages.updateScheduledMessage(
        message.id,
        content: updated.content,
        scheduledFor: updated.scheduledFor,
      );
      _loadScheduledMessages();
      Toast.show(
        context,
        message: 'Scheduled message updated',
        type: ToastType.success,
      );
    }
  }

  Future<void> _deleteScheduledMessage(ScheduledMessage message) async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete Scheduled Message',
      description: 'Are you sure you want to delete this scheduled message? This action cannot be undone.',
      primaryActionLabel: 'Delete',
      isDestructive: true,
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
    );

    if (confirmed == true && mounted) {
      await MockMessages.deleteScheduledMessage(message.id);
      _loadScheduledMessages();
      Toast.show(
        context,
        message: 'Scheduled message deleted',
        type: ToastType.success,
      );
    }
  }

  Future<void> _cancelScheduledMessage(ScheduledMessage message) async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Cancel Scheduled Message',
      description: 'Are you sure you want to cancel this scheduled message?',
      primaryActionLabel: 'Cancel',
      secondaryActionLabel: 'Keep',
      icon: Icons.cancel_outlined,
    );

    if (confirmed == true && mounted) {
      await MockMessages.cancelScheduledMessage(message.id);
      _loadScheduledMessages();
      Toast.show(
        context,
        message: 'Scheduled message cancelled',
        type: ToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Scheduled Messages',
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: SkeletonLoader(
            width: double.infinity,
            height: 100,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_scheduledMessages.isEmpty) {
      return EmptyStateCard(
        title: 'No scheduled messages',
        description: 'Schedule messages to send later by tapping the schedule button in the message composer.',
        icon: Icons.schedule_outlined,
      );
    }

    // Filter to only show pending messages
    final pendingMessages = _scheduledMessages
        .where((m) => m.status == ScheduledMessageStatus.pending)
        .toList()
      ..sort((a, b) => a.scheduledFor.compareTo(b.scheduledFor));

    if (pendingMessages.isEmpty) {
      return EmptyStateCard(
        title: 'No pending scheduled messages',
        description: 'All scheduled messages have been sent or cancelled.',
        icon: Icons.check_circle_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadScheduledMessages,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          ...pendingMessages.map((message) => _buildScheduledMessageCard(message)),
        ],
      ),
    );
  }

  Widget _buildScheduledMessageCard(ScheduledMessage message) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ChannelIconBadge(
                channel: message.channel.displayName,
                size: 24,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDateTime(message.scheduledFor),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatRelativeTime(message.scheduledFor),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _editScheduledMessage(message);
                      break;
                    case 'cancel':
                      _cancelScheduledMessage(message);
                      break;
                    case 'delete':
                      _deleteScheduledMessage(message);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Builder(
                      builder: (context) => Row(
                      children: [
                          const Icon(Icons.edit, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ),
                  PopupMenuItem(
                    value: 'cancel',
                    child: Builder(
                      builder: (context) => Row(
                      children: [
                          const Icon(Icons.cancel_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'delete',
                    child: Builder(
                      builder: (context) => Row(
                      children: [
                          const Icon(Icons.delete_outline, size: 18, color: Color(SwiftleadTokens.errorRed)),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(SwiftleadTokens.errorRed),
                            ),
                          ),
                      ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            message.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

