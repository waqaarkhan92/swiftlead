import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// BlockedTimeScreen - Manage blocked time and time off
/// Allows team members to block time slots for time off, breaks, etc.
class BlockedTimeScreen extends StatefulWidget {
  const BlockedTimeScreen({super.key});

  @override
  State<BlockedTimeScreen> createState() => _BlockedTimeScreenState();
}

class _BlockedTimeScreenState extends State<BlockedTimeScreen> {
  bool _isLoading = false;
  final List<_BlockedTimeEntry> _blockedTimes = [
    _BlockedTimeEntry(
      id: '1',
      title: 'Holiday',
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 12)),
      teamMember: 'Alex',
      reason: 'Annual leave',
    ),
    _BlockedTimeEntry(
      id: '2',
      title: 'Lunch Break',
      startDate: DateTime.now().add(const Duration(days: 1, hours: 12)),
      endDate: DateTime.now().add(const Duration(days: 1, hours: 13)),
      teamMember: 'Sam',
      reason: 'Daily lunch break',
      isRecurring: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Blocked Time',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBlockedTimeSheet(),
            tooltip: 'Block Time',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_blockedTimes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: const Color(SwiftleadTokens.textSecondaryLight).withOpacity(0.5),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'No blocked time',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              'Add time off or blocked slots',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(SwiftleadTokens.textSecondaryLight),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        InfoBanner(
          message: 'Blocked time prevents bookings during these periods',
          type: InfoBannerType.info,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ..._blockedTimes.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: _buildBlockedTimeCard(entry),
        )),
      ],
    );
  }

  Widget _buildBlockedTimeCard(_BlockedTimeEntry entry) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      entry.teamMember,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (entry.isRecurring)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.4),
                  ),
                  child: Text(
                    'Recurring',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: const Color(SwiftleadTokens.textSecondaryLight),
              ),
              const SizedBox(width: SwiftleadTokens.spaceXS),
              Text(
                '${_formatDate(entry.startDate)} - ${_formatDate(entry.endDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (entry.reason.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              entry.reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(SwiftleadTokens.textSecondaryLight),
              ),
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _showEditBlockedTimeSheet(entry),
                child: const Text('Edit'),
              ),
              const SizedBox(width: SwiftleadTokens.spaceXS),
              TextButton(
                onPressed: () => _handleDelete(entry.id),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(SwiftleadTokens.errorRed),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddBlockedTimeSheet() {
    _showBlockedTimeSheet();
  }

  void _showEditBlockedTimeSheet(_BlockedTimeEntry entry) {
    _showBlockedTimeSheet(entry: entry);
  }

  void _showBlockedTimeSheet({_BlockedTimeEntry? entry}) {
    // Simple bottom sheet for adding/editing blocked time
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry == null ? 'Add Blocked Time' : 'Edit Blocked Time',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Holiday, Lunch Break',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: entry?.title ?? ''),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: entry?.startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      // Handle date selection
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Start Date'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: entry?.endDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      // Handle date selection
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('End Date'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'e.g., Annual leave, Sick day',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: entry?.reason ?? ''),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            PrimaryButton(
              label: entry == null ? 'Add Blocked Time' : 'Save Changes',
              onPressed: () {
                Navigator.pop(context);
                Toast.show(
                  context,
                  message: entry == null ? 'Blocked time added' : 'Blocked time updated',
                  type: ToastType.success,
                );
              },
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }

  void _handleDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Blocked Time'),
        content: const Text('Are you sure you want to delete this blocked time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _blockedTimes.removeWhere((e) => e.id == id);
              });
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Blocked time deleted',
                type: ToastType.success,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(SwiftleadTokens.errorRed),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _BlockedTimeEntry {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String teamMember;
  final String reason;
  final bool isRecurring;

  _BlockedTimeEntry({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.teamMember,
    this.reason = '',
    this.isRecurring = false,
  });
}

