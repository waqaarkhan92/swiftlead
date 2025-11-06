import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/progress_pill.dart';
import '../../widgets/components/date_chip.dart';
import '../../widgets/components/media_thumbnail.dart';
import '../../widgets/components/media_preview_modal.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/forms/job_assignment_sheet.dart';
import '../../widgets/forms/job_export_sheet.dart';
import '../../widgets/forms/media_upload_sheet.dart';
import '../../widgets/forms/custom_field_editor_sheet.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/components/chase_history_timeline.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/progress_bar.dart';
import '../../theme/tokens.dart';
import '../../models/job.dart';
import '../../models/job_timeline_event.dart';
import '../../mock/mock_repository.dart';
import '../../mock/mock_jobs.dart';
import '../../config/mock_config.dart';
import 'create_edit_job_screen.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../money/create_edit_invoice_screen.dart';
import '../inbox/inbox_thread_screen.dart';
import '../../utils/profession_config.dart';

/// JobDetailScreen - Comprehensive job view
/// Exact specification from Screen_Layouts_v2.5.1
class JobDetailScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  
  const JobDetailScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  int _selectedTabIndex = 0;
  final List<String> _primaryTabs = ['Timeline', 'Details', 'Notes'];
  final List<String> _moreOptions = ['Messages', 'Media', 'Chasers'];
  String? _selectedMoreOption;
  Job? _job;
  bool _isLoading = true;
  String? _error;
  // Custom fields state
  final Map<String, String> _customFields = {};

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  String _formatDaysUntil(DateTime? date) {
    if (date == null) return 'N/A';
    final now = DateTime.now();
    final difference = date.difference(now);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Tomorrow';
    if (difference.inDays > 0) return '${difference.inDays} days';
    return 'Overdue';
  }

  Future<void> _loadJob() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (kUseMockData) {
        final job = await MockJobs.fetchById(widget.jobId);
        if (mounted) {
          setState(() {
            _job = job;
            _isLoading = false;
            if (job == null) {
              _error = 'Job not found';
            }
          });
        }
      } else {
        // TODO: Load from live backend
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'Backend not implemented';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading job: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  void _handleCreateQuoteFromJob() {
    if (_job == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuoteScreen(
          initialData: {
            'clientName': _job!.contactName,
            'contactId': _job!.contactId,
            'notes': 'Quote for ${_job!.title}',
            'taxRate': 20.0,
          },
        ),
      ),
    ).then((_) {
      Toast.show(
        context,
        message: 'Quote created from job',
        type: ToastType.success,
      );
    });
  }

  void _handleMessageClient() {
    if (_job == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxThreadScreen(
          contactName: _job!.contactName,
          contactId: _job!.contactId,
          channel: 'SMS',
        ),
      ),
    );
  }

  void _handleSendInvoiceFromJob() {
    // Navigate to invoice creation with job context
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditInvoiceScreen(
          initialData: {
            'clientName': _job?.contactName ?? '',
            'jobId': widget.jobId,
            'jobTitle': widget.jobTitle,
            'attachJobPhotos': true, // Default to true when creating from job
            'notes': 'Invoice for ${widget.jobTitle}',
            'contactId': _job?.contactId,
          },
        ),
      ),
    );
  }

  Future<void> _handleMarkComplete() async {
    if (_job == null) return;
    
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Mark ${ProfessionState.config.getLabel('Job')} Complete',
      description: 'Are you sure you want to mark "${_job!.title}" as complete?',
      primaryActionLabel: 'Mark Complete',
      secondaryActionLabel: 'Cancel',
      icon: Icons.check_circle,
    );
    
    if (confirmed != true) return;
    
    final success = await MockJobs.markJobComplete(_job!.id);
    if (success && mounted) {
      // Show celebration
      _showCelebration();
      // Reload job to show updated status
      await _loadJob();
      Toast.show(
        context,
        message: 'Job marked as complete! 🎉',
        type: ToastType.success,
      );
    } else if (mounted) {
      Toast.show(
        context,
        message: 'Failed to mark job as complete',
        type: ToastType.error,
      );
    }
  }

  void _showCelebration() {
    // Simple celebration overlay with animated emojis
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      builder: (context) => const _CelebrationDialog(),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  void _handleCallClient() async {
    if (_job == null) return;
    // TODO: Get phone number from contact
    final uri = Uri.parse('tel:+442012345678');
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

  void _handleNavigateToAddress() async {
    if (_job == null || _job!.address.isEmpty) return;
    
    // Open Maps app with address
    final encodedAddress = Uri.encodeComponent(_job!.address);
    final uri = Uri.parse('https://maps.google.com/maps?q=$encodedAddress');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Cannot open maps',
          type: ToastType.error,
        );
      }
    }
  }

  void _handleSyncToCalendar() async {
    if (_job == null || _job!.scheduledDate == null) return;
    
    // Note: Would use calendar integration package (e.g., add_to_calendar) in production
    // For now, show a toast and note about backend verification
    Toast.show(
      context,
      message: 'Calendar sync requires calendar integration package',
      type: ToastType.info,
    );
    
    // Example implementation with add_to_calendar package:
    // final event = Event(
    //   title: _job!.title,
    //   description: _job!.description ?? '',
    //   location: _job!.address,
    //   startDate: _job!.scheduledDate!,
    //   endDate: _job!.scheduledDate!.add(Duration(hours: 2)),
    // );
    // await AddToCalendar.addEvent2Cal(event);
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FrostedAppBar(
          title: 'Loading...',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _job == null) {
      return Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: FrostedAppBar(
          title: 'Error',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: EmptyStateCard(
            title: _error ?? '${ProfessionState.config.getLabel('Job')} not found',
            description: 'Unable to load job details',
            icon: Icons.error_outline,
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: _job!.title,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditJobScreen(
                    jobId: widget.jobId,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'assign':
                  JobAssignmentSheet.show(
                    context: context,
                    jobId: widget.jobId,
                    currentAssigneeId: _job?.assignedTo,
                    allowMultiSelect: true,
                    onAssigned: (memberId, memberName) {
                      // Handle single assignment
                      setState(() {
                        // Update job with single assignee
                      });
                    },
                    onMultiAssigned: (memberIds, memberNames) {
                      // Handle multi-member assignment
                      setState(() {
                        // Update job with multiple assignees
                      });
                    },
                  );
                  break;
                case 'export':
                  JobExportSheet.show(
                    context: context,
                    onExportComplete: (format) {
                      Toast.show(
                        context,
                        message: 'Job exported as ${format.toUpperCase()}',
                        type: ToastType.success,
                      );
                    },
                  );
                  break;
                case 'delete':
                  SwiftleadConfirmationDialog.show(
                    context: context,
                    title: 'Delete ${ProfessionState.config.getLabel('Job')}',
                    description: 'Are you sure you want to delete this job? This action cannot be undone.',
                    primaryActionLabel: 'Delete',
                    isDestructive: true,
                    secondaryActionLabel: 'Cancel',
                    icon: Icons.warning_rounded,
                  ).then((confirmed) {
                    if (confirmed == true) {
                      Navigator.pop(context);
                      Toast.show(
                        context,
                        message: 'Job deleted',
                        type: ToastType.success,
                      );
                    }
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'assign',
                child: Text(
                  'Assign',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Text(
                  'Export',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(SwiftleadTokens.errorRed),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable content section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // JobSummaryCard - Key information at top
                  _buildJobSummaryCard(),
                ],
              ),
            ),
          ),
          
          // JobTabView - Horizontal tabs (fixed at bottom)
          _buildJobTabView(),
          
          // iOS-style bottom toolbar (sticky at bottom)
          _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildJobSummaryCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ClientInfo
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    _getInitials(_job!.contactName),
                    style: const TextStyle(
                      color: Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _job!.contactName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _job!.address,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: _handleCallClient,
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: _handleMessageClient,
              ),
              IconButton(
                icon: const Icon(Icons.directions),
                onPressed: _handleNavigateToAddress,
                tooltip: 'Navigate to address',
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // ServiceBadge
          Row(
            children: [
              ProgressPill(status: _job!.status.displayName),
              const SizedBox(width: SwiftleadTokens.spaceS),
              if (_job!.scheduledDate != null) ...[
                DateChip(
                  date: _job!.scheduledDate!,
                  isDue: _job!.scheduledDate!.isBefore(DateTime.now()),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // Calendar Sync Button
                IconButton(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  onPressed: _handleSyncToCalendar,
                  tooltip: 'Sync to calendar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Risk Alerts - Scheduling Conflicts
          if (_hasSchedulingConflict()) _buildConflictAlert(),
          
          // ProgressBar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _job!.status == JobStatus.completed ? 1.0 : (_job!.status == JobStatus.inProgress ? 0.75 : 0.25),
                  backgroundColor: Colors.black.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(SwiftleadTokens.primaryTeal),
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_job!.status == JobStatus.completed ? 100 : (_job!.status == JobStatus.inProgress ? 75 : 25)}% Complete',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // KeyMetrics
          Row(
            children: [
              Expanded(
                child: _KeyMetricItem(
                  label: 'Value',
                  value: '£${_job!.value.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _KeyMetricItem(
                  label: 'Created',
                  value: _formatDate(_job!.createdAt),
                ),
              ),
              Expanded(
                child: _KeyMetricItem(
                  label: 'Due',
                  value: _formatDaysUntil(_job!.scheduledDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    // iOS-style bottom toolbar: Secondary actions in toolbar, primary action below
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Secondary actions toolbar (iOS pattern: icon + label)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SwiftleadTokens.spaceM,
                vertical: SwiftleadTokens.spaceS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ToolbarAction(
                    icon: Icons.message,
                    label: 'Message',
                    onTap: _handleMessageClient,
                  ),
                  _ToolbarAction(
                    icon: Icons.request_quote,
                    label: 'Quote',
                    onTap: _handleCreateQuoteFromJob,
                  ),
                  _ToolbarAction(
                    icon: Icons.receipt,
                    label: 'Invoice',
                    onTap: _handleSendInvoiceFromJob,
                  ),
                ],
              ),
            ),
            // Primary action: Full-width button at bottom (iOS pattern)
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: PrimaryButton(
                label: 'Mark Complete',
                onPressed: _job != null && _job!.status != JobStatus.completed ? _handleMarkComplete : null,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper widget for toolbar actions (iOS pattern: icon + label)
  Widget _ToolbarAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SwiftleadTokens.spaceS,
            horizontal: SwiftleadTokens.spaceXS,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobTabView() {
    return Expanded(
      child: Column(
        children: [
          // Primary tabs + More dropdown
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              children: [
                // Primary tabs (Timeline, Details, Notes)
                Expanded(
                  child: SegmentedControl(
                    segments: _primaryTabs,
                    selectedIndex: _selectedTabIndex,
                    onSelectionChanged: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                        _selectedMoreOption = null; // Clear more option when selecting primary tab
                      });
                    },
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // More dropdown menu
                PopupMenuButton<String>(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'More',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _selectedMoreOption != null 
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _selectedMoreOption != null 
                          ? Icons.arrow_drop_up 
                          : Icons.arrow_drop_down,
                        size: 20,
                      ),
                    ],
                  ),
                  onSelected: (value) {
                    setState(() {
                      _selectedMoreOption = value;
                      // Map More options to indices for IndexedStack
                      if (value == 'Messages') {
                        _selectedTabIndex = 3;
                      } else if (value == 'Media') {
                        _selectedTabIndex = 4;
                      } else if (value == 'Chasers') {
                        _selectedTabIndex = 5;
                      }
                    });
                  },
                  itemBuilder: (context) => _moreOptions.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          if (_selectedMoreOption == option)
                            const Icon(
                              Icons.check,
                              size: 18,
                              color: Color(SwiftleadTokens.primaryTeal),
                            )
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            option,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Tab content - Use IndexedStack
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildTimelineTab(),
                _buildDetailsTab(),
                _buildNotesTab(),
                _buildMessagesTab(),
                _buildMediaTab(),
                _buildChasersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    // Show loading state if job not loaded yet
    if (_isLoading || _job == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Generate timeline events from job data
    final timelineEvents = _generateTimelineEvents();

    if (timelineEvents.isEmpty) {
      return EmptyStateCard(
        title: 'No activity yet',
        description: 'Activity timeline will show job updates and events.',
        icon: Icons.history,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ...timelineEvents.map((event) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _TimelineItem(
            icon: event.eventType.icon,
            title: event.summary,
            subtitle: event.eventId != null ? 'ID: ${event.eventId}' : event.eventType.displayName,
            timestamp: event.timestamp,
            user: event.userName ?? 'System',
          ),
        )),
      ],
    );
  }

  List<JobTimelineEvent> _generateTimelineEvents() {
    if (_job == null) return [];
    
    final events = <JobTimelineEvent>[];
    final now = DateTime.now();
    
    // Safe substring helper
    String safeSubstring(String str, int length) {
      return str.length >= length ? str.substring(0, length) : str;
    }
    
    // Add events based on job status and history
    if (_job!.status == JobStatus.completed && _job!.completedAt != null) {
      events.add(JobTimelineEvent(
        id: 'e1',
        jobId: _job!.id,
        eventType: JobTimelineEventType.statusChange,
        summary: 'Job marked as complete',
        timestamp: _job!.completedAt!,
        userName: 'Alex Johnson',
      ));
    }
    
    // Add invoice event if job has value
    if (_job!.value > 0) {
      events.add(JobTimelineEvent(
        id: 'e2',
        jobId: _job!.id,
        eventType: JobTimelineEventType.invoice,
        eventId: 'INV-${safeSubstring(_job!.id, 8)}',
        summary: 'Invoice created',
        timestamp: now.subtract(const Duration(days: 2)),
        userName: 'System',
      ));
    }
    
    // Add booking event if scheduled
    if (_job!.scheduledDate != null) {
      events.add(JobTimelineEvent(
        id: 'e3',
        jobId: _job!.id,
        eventType: JobTimelineEventType.booking,
        summary: 'Booking scheduled',
        timestamp: _job!.scheduledDate!,
        userName: 'System',
      ));
    }
    
    // Add message event
    events.add(JobTimelineEvent(
      id: 'e4',
      jobId: _job!.id,
      eventType: JobTimelineEventType.message,
      summary: 'Message sent to client',
      timestamp: now.subtract(const Duration(hours: 6)),
      userName: 'Alex Johnson',
    ));
    
    // Add quote event
    events.add(JobTimelineEvent(
      id: 'e5',
      jobId: _job!.id,
      eventType: JobTimelineEventType.quote,
      eventId: 'QUO-${safeSubstring(_job!.id, 8)}',
      summary: 'Quote sent to client',
      timestamp: now.subtract(const Duration(days: 5)),
      userName: 'System',
    ));
    
    // Sort by timestamp descending (most recent first)
    events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return events;
  }

  Widget _buildNotesTab() {
    final hasNotes = false; // Replace with actual data check

    if (!hasNotes) {
      return EmptyStateCard(
        title: 'No notes yet',
        description: 'Add notes to track important information about this job.',
        icon: Icons.note_outlined,
        actionLabel: 'Add Note',
        onAction: () {
          _showAddNoteSheet(context);
        },
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Job Notes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddNoteSheet(context),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // Notes list would go here
        FrostedContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'AJ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '2 hours ago',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    onPressed: () {
                      // Show options menu for timeline event
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.edit_outlined),
                                  title: const Text('Edit Note'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // TODO: Open edit note sheet
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete_outline),
                                  title: const Text('Delete Note'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // TODO: Delete note
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Client requested that we come in the morning. Will schedule for 9am.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    bool isClientVisible = false;
    final Set<String> mentionedUsers = <String>{};
    
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Add Note',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setSheetState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Visibility toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client-visible',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        isClientVisible 
                            ? 'Client can see this note'
                            : 'Internal team only',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isClientVisible,
                  onChanged: (value) {
                    setSheetState(() {
                      isClientVisible = value;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceS),
            // Rich text formatting toolbar (Note: Requires flutter_quill package)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.format_bold, size: 20),
                  onPressed: () {
                    Toast.show(
                      context,
                      message: 'Rich text formatting requires flutter_quill package',
                      type: ToastType.info,
                    );
                  },
                  tooltip: 'Bold (requires rich text editor)',
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic, size: 20),
                  onPressed: () {
                    Toast.show(
                      context,
                      message: 'Rich text formatting requires flutter_quill package',
                      type: ToastType.info,
                    );
                  },
                  tooltip: 'Italic (requires rich text editor)',
                ),
                IconButton(
                  icon: const Icon(Icons.link, size: 20),
                  onPressed: () {
                    Toast.show(
                      context,
                      message: 'Link insertion requires flutter_quill package',
                      type: ToastType.info,
                    );
                  },
                  tooltip: 'Add Link (requires rich text editor)',
                ),
                IconButton(
                  icon: const Icon(Icons.alternate_email, size: 20),
                  onPressed: () {
                    // @Mention functionality
                    _showMentionPicker(context, noteController, mentionedUsers, setSheetState);
                  },
                  tooltip: 'Mention',
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            // Show mentioned users
            if (mentionedUsers.isNotEmpty) ...[
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: mentionedUsers.map((user) {
                  return Chip(
                    label: Text('@$user'),
                    avatar: const Icon(Icons.person, size: 16),
                    onDeleted: () {
                      setSheetState(() {
                        mentionedUsers.remove(user);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
            ],
            TextField(
              controller: noteController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Enter your note... Use @ to mention team members.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              onChanged: (text) {
                // Detect @ mentions in text
                final mentionRegex = RegExp(r'@(\w+)');
                final matches = mentionRegex.allMatches(text);
                final newMentions = matches.map((m) => m.group(1)!).toSet();
                if (newMentions != mentionedUsers) {
                  setSheetState(() {
                    mentionedUsers.clear();
                    mentionedUsers.addAll(newMentions);
                  });
                }
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            PrimaryButton(
              label: 'Save Note',
              onPressed: () {
                // Save note with visibility and mentions
                Navigator.pop(context);
                setState(() {}); // Refresh to show new note
                Toast.show(
                  context,
                  message: 'Note saved${isClientVisible ? ' (client-visible)' : ' (internal)'}',
                  type: ToastType.success,
                );
              },
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  void _showMentionPicker(BuildContext context, TextEditingController controller, Set<String> mentionedUsers, StateSetter setSheetState) {
    final teamMembers = ['Alex Johnson', 'Sarah Williams', 'Mike Davis', 'Emma Wilson'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Text(
                  'Mention Team Member',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(),
              ...teamMembers.map((member) {
                final username = member.split(' ').first.toLowerCase();
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member[0]),
                  ),
                  title: Text(member),
                  subtitle: Text('@$username'),
                  onTap: () {
                    final mention = '@$username ';
                    final text = controller.text;
                    final selection = controller.selection;
                    
                    // Insert mention at cursor position
                    final newText = text.replaceRange(
                      selection.start,
                      selection.end,
                      mention,
                    );
                    controller.text = newText;
                    controller.selection = TextSelection.collapsed(
                      offset: selection.start + mention.length,
                    );
                    
                    mentionedUsers.add(username);
                    setSheetState(() {});
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Service Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _DetailRow(
                label: 'Service Type',
                value: 'Kitchen Sink Repair',
              ),
              const Divider(),
              _DetailRow(
                label: 'Priority',
                value: 'High',
              ),
              const Divider(),
              _DetailRow(
                label: 'Estimated Duration',
                value: '2 hours',
              ),
              const Divider(),
              _DetailRow(
                label: 'Estimated Cost',
                value: '£300',
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _DetailRow(
                      label: 'Location',
                      value: _job?.address ?? '123 Main Street, London',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: _handleNavigateToAddress,
                    tooltip: 'Open in maps',
                  ),
                ],
              ),
              // Map Preview (Inline)
              if (_job?.address.isNotEmpty ?? false) ...[
                const SizedBox(height: SwiftleadTokens.spaceS),
                GestureDetector(
                  onTap: _handleNavigateToAddress,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        // Static map preview (using placeholder - would use Google Maps Static API in production)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: SwiftleadTokens.spaceS),
                              Text(
                                'Map Preview',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Tap to open in Maps',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Note: In production, this would use Google Maps Static API
                        // Example: https://maps.googleapis.com/maps/api/staticmap?center=${address}&zoom=15&size=400x150&key=API_KEY
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Static Map',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // Rich Text Formatting Buttons (Note: Requires rich text editor package)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_bold, size: 18),
                        onPressed: () {
                          Toast.show(
                            context,
                            message: 'Rich text formatting requires flutter_quill package',
                            type: ToastType.info,
                          );
                        },
                        tooltip: 'Bold (requires rich text editor)',
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_italic, size: 18),
                        onPressed: () {
                          Toast.show(
                            context,
                            message: 'Rich text formatting requires flutter_quill package',
                            type: ToastType.info,
                          );
                        },
                        tooltip: 'Italic (requires rich text editor)',
                      ),
                      IconButton(
                        icon: const Icon(Icons.link, size: 18),
                        onPressed: () {
                          Toast.show(
                            context,
                            message: 'Rich text formatting requires flutter_quill package',
                            type: ToastType.info,
                          );
                        },
                        tooltip: 'Add Link (requires rich text editor)',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Kitchen sink is leaking from the base. Needs repair or replacement of faucet assembly.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        // Custom Fields Section
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Custom Fields',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () async {
                      final field = await CustomFieldEditorSheet.show(
                        context: context,
                      );
                      if (field != null && mounted) {
                        setState(() {
                          // Add custom field to job
                          _customFields[field['name'] ?? ''] = field['value'] ?? '';
                        });
                        Toast.show(
                          context,
                          message: 'Custom field added',
                          type: ToastType.success,
                        );
                      }
                    },
                    tooltip: 'Add custom field',
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Display custom fields
              if (_customFields.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
                  child: Text(
                    'No custom fields added yet. Tap + to add one.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                )
              else
                ...(_customFields.entries.map((entry) {
                  return Column(
                    children: [
                      _CustomFieldRow(
                        label: entry.key,
                        value: entry.value,
                      ),
                      if (entry.key != _customFields.keys.last) const Divider(),
                    ],
                  );
                }).toList()),
              // Show example fields if no custom fields exist (for demo)
              if (_customFields.isEmpty) ...[
                _CustomFieldRow(
                  label: 'Property Type',
                  value: 'Residential',
                ),
                const Divider(),
                _CustomFieldRow(
                  label: 'Warranty Period',
                  value: '12 months',
                ),
                const Divider(),
                _CustomFieldRow(
                  label: 'License Required',
                  value: 'Yes',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Team Assignment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'SW',
                      style: TextStyle(
                        color: Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                title: const Text('Sarah Williams'),
                subtitle: const Text('Plumber'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesTab() {
    final hasMessages = true; // Replace with actual data check

    if (!hasMessages) {
      return EmptyStateCard(
        title: 'No messages yet',
        description: 'Messages related to this job will appear here.',
        icon: Icons.message_outlined,
        actionLabel: 'Send Message',
        onAction: () {
          // Open message composer
        },
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Linked Messages',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _MessageCard(
            channel: ['WhatsApp', 'SMS', 'Email'][index],
            preview: _getMessagePreview(index),
            timestamp: DateTime.now().subtract(Duration(hours: index * 6)),
            direction: index % 2 == 0 ? 'inbound' : 'outbound',
            onTap: () {
              // Navigate to message thread
            },
          ),
        )),
      ],
    );
  }

  String _getMessagePreview(int index) {
    final previews = [
      'Hi, when can you schedule the repair?',
      'We can come tomorrow at 2pm. Does that work?',
      'Perfect! See you then.',
    ];
    return previews[index % previews.length];
  }

  Widget _buildMediaTab() {
    final hasMedia = true; // Replace with actual data check

    if (!hasMedia) {
      return EmptyStateCard(
        title: 'No media uploaded',
        description: 'Add photos and documents for this job.',
        icon: Icons.photo_library_outlined,
        actionLabel: 'Add Media',
        onAction: () => _showMediaUploadSheet(context),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Media Gallery',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showMediaUploadSheet(context),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Before Section
        Text(
          'Before',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: SwiftleadTokens.spaceS,
            mainAxisSpacing: SwiftleadTokens.spaceS,
          ),
          itemCount: 4, // Before photos
          itemBuilder: (context, index) => MediaThumbnail(
            label: 'Before ${index + 1}',
            onTap: () {
              // Show before/after comparison slider if both exist
              if (index < 4) {
                _showBeforeAfterSlider(context, index);
              } else {
                // Open full screen gallery
                MediaPreviewModal.show(
                  context: context,
                  mediaUrl: 'https://picsum.photos/800/600?random=before$index',
                  mediaType: 'image',
                );
              }
            },
          ),
        ),
        
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // After Section
        Text(
          'After',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: SwiftleadTokens.spaceS,
            mainAxisSpacing: SwiftleadTokens.spaceS,
          ),
          itemCount: 5, // After photos
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MediaThumbnail(
                label: 'After ${index + 1}',
                onTap: () {
                  // Show before/after comparison slider if both exist
                  if (index < 4) {
                    _showBeforeAfterSlider(context, index);
                  } else {
                    // Open full screen gallery
                    MediaPreviewModal.show(
                      context: context,
                      mediaUrl: 'https://picsum.photos/800/600?random=after$index',
                      mediaType: 'image',
                    );
                  }
                },
              ),
              // Show timestamp/GPS info
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 16)} • GPS: 51.5074, -0.1278',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMediaUploadSheet(BuildContext context) {
    MediaUploadSheet.show(
      context: context,
      jobId: widget.jobId,
      onUploadComplete: () {
        setState(() {
          // Refresh media list
        });
      },
    );
  }

  void _showBeforeAfterSlider(BuildContext context, int photoIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _BeforeAfterSliderModal(
        beforeImageUrl: 'https://picsum.photos/800/600?random=before$photoIndex',
        afterImageUrl: 'https://picsum.photos/800/600?random=after$photoIndex',
      ),
    );
  }

  // Check for scheduling conflicts
  bool _hasSchedulingConflict() {
    if (_job == null || _job!.scheduledDate == null) return false;
    
    // Check if this job's scheduled time conflicts with other jobs
    // In production, this would query the database for overlapping jobs
    // For now, simulate a conflict check - show alert for demo purposes
    final scheduledDate = _job!.scheduledDate!;
    final now = DateTime.now();
    
    // Example: Flag if scheduled in the past (overdue)
    if (scheduledDate.isBefore(now.subtract(const Duration(hours: 1)))) {
      return true;
    }
    
    // For demo: Show conflict if job is scheduled for today (to make it visible)
    if (scheduledDate.day == now.day && scheduledDate.month == now.month && scheduledDate.year == now.year) {
      return true; // Show conflict alert for demo
    }
    
    // Example: Flag if scheduled too close to another job (within 30 minutes)
    // In production: SELECT * FROM jobs WHERE assigned_to = ? AND scheduled_date BETWEEN ? AND ? AND id != ?
    return false;
  }

  Widget _buildConflictAlert() {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: InfoBanner(
        message: _job!.scheduledDate!.isBefore(DateTime.now())
            ? 'This job is overdue. Scheduled date has passed.'
            : 'Scheduling conflict detected. This job may overlap with another assignment.',
        type: InfoBannerType.warning,
        icon: Icons.warning_amber_rounded,
        actionLabel: 'View Conflicts',
        onTap: () {
          // Show conflict details
          _showConflictDetails();
        },
      ),
    );
  }

  void _showConflictDetails() {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Scheduling Conflicts',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          InfoBanner(
            message: 'This job may conflict with other scheduled work.',
            type: InfoBannerType.warning,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Example conflict entry
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Potential Conflict',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Another job scheduled nearby: ${_job!.scheduledDate!.subtract(const Duration(hours: 1)).toString().substring(0, 16)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Note: Conflict detection requires backend verification once backend is wired.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChasersTab() {
    // Mock quote chaser records - according to spec: quote_chasers WHERE job_id
    // Quote chasers are automated follow-ups sent at T+1, T+3, T+7 days after quote sent
    final chaseRecords = [
      ChaseRecord(
        message: 'Quote chaser sent via email (T+1 day)',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        status: ChaseStatus.sent,
        channel: ChaseChannel.email,
      ),
      ChaseRecord(
        message: 'Quote chaser sent via SMS (T+3 days)',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: ChaseStatus.delivered,
        channel: ChaseChannel.sms,
      ),
      ChaseRecord(
        message: 'Quote chaser scheduled (T+7 days)',
        timestamp: DateTime.now().add(const Duration(days: 4)),
        status: ChaseStatus.sent,
        channel: ChaseChannel.email,
      ),
    ];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Empty state check - according to spec: "No chasers scheduled" + InfoBanner
        if (chaseRecords.isEmpty)
          Column(
            children: [
              EmptyStateCard(
                title: 'No chasers scheduled',
                description: 'Auto-follow-ups help close deals',
                icon: Icons.schedule,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              InfoBanner(
                message: 'Auto-follow-ups help close deals',
                type: InfoBannerType.info,
              ),
            ],
          )
        else
          ChaseHistoryTimeline(chaseRecords: chaseRecords),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String user;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.user,
  });

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      user,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      '•',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      _formatTime(timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String channel;
  final String preview;
  final DateTime timestamp;
  final String direction;
  final VoidCallback onTap;

  const _MessageCard({
    required this.channel,
    required this.preview,
    required this.timestamp,
    required this.direction,
    required this.onTap,
  });

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                channel,
                style: const TextStyle(
                  color: Color(SwiftleadTokens.primaryTeal),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preview,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: direction == 'inbound'
                              ? const Color(SwiftleadTokens.infoBlue)
                              : const Color(SwiftleadTokens.successGreen),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceXS),
                      Text(
                        direction == 'inbound' ? 'Received' : 'Sent',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        _formatTime(timestamp),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildChasersTab() {
    // Mock quote chaser records - according to spec: quote_chasers WHERE job_id
    // Quote chasers are automated follow-ups sent at T+1, T+3, T+7 days after quote sent
    final chaseRecords = [
      ChaseRecord(
        message: 'Quote chaser sent via email (T+1 day)',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        status: ChaseStatus.sent,
        channel: ChaseChannel.email,
      ),
      ChaseRecord(
        message: 'Quote chaser sent via SMS (T+3 days)',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: ChaseStatus.delivered,
        channel: ChaseChannel.sms,
      ),
      ChaseRecord(
        message: 'Quote chaser scheduled (T+7 days)',
        timestamp: DateTime.now().add(const Duration(days: 4)),
        status: ChaseStatus.sent,
        channel: ChaseChannel.email,
      ),
    ];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Empty state check - according to spec: "No chasers scheduled" + InfoBanner
        if (chaseRecords.isEmpty)
          Column(
            children: [
              EmptyStateCard(
                title: 'No chasers scheduled',
                description: 'Auto-follow-ups help close deals',
                icon: Icons.schedule,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              InfoBanner(
                message: 'Auto-follow-ups help close deals',
                type: InfoBannerType.info,
              ),
            ],
          )
        else
          ChaseHistoryTimeline(chaseRecords: chaseRecords),
      ],
    );
  }
}

/// Celebration Dialog - Shows confetti-like celebration animation
class _CelebrationDialog extends StatefulWidget {
  const _CelebrationDialog();

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🎉',
                    style: TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Job Complete!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(SwiftleadTokens.primaryTeal),
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KeyMetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _KeyMetricItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CustomFieldRow extends StatelessWidget {
  final String label;
  final String value;

  const _CustomFieldRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _BeforeAfterSliderModal extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;

  const _BeforeAfterSliderModal({
    required this.beforeImageUrl,
    required this.afterImageUrl,
  });

  @override
  State<_BeforeAfterSliderModal> createState() => _BeforeAfterSliderModalState();
}

class _BeforeAfterSliderModalState extends State<_BeforeAfterSliderModal> {
  double _sliderPosition = 0.5; // 0.0 = before, 1.0 = after

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Before / After Comparison',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // After image (background)
            Image.network(
              widget.afterImageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
            // Before image (clipped based on slider)
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _sliderPosition,
                child: Image.network(
                  widget.beforeImageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            // Slider control
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SwiftleadTokens.spaceM,
                  vertical: SwiftleadTokens.spaceS,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Before',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'After',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _sliderPosition,
                      min: 0.0,
                      max: 1.0,
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                      onChanged: (value) {
                        setState(() {
                          _sliderPosition = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

