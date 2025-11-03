import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/components/progress_pill.dart';
import '../../widgets/components/date_chip.dart';
import '../../widgets/components/media_thumbnail.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/forms/job_assignment_sheet.dart';
import '../../widgets/forms/job_export_sheet.dart';
import '../../widgets/forms/media_upload_sheet.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/progress_bar.dart';
import '../../theme/tokens.dart';
import '../../models/job.dart';
import '../../mock/mock_repository.dart';
import '../../config/mock_config.dart';
import 'create_edit_job_screen.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../money/create_edit_invoice_screen.dart';
import '../inbox/inbox_thread_screen.dart';

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
  final List<String> _tabs = ['Timeline', 'Details', 'Notes', 'Messages', 'Media'];
  Job? _job;
  bool _isLoading = true;
  String? _error;

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditInvoiceScreen(),
      ),
    );
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
            title: _error ?? 'Job not found',
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
                    onAssigned: (memberId, memberName) {
                      // Handle assignment
                    },
                  );
                  break;
                case 'export':
                  JobExportSheet.show(
                    context: context,
                    onExportComplete: (format) {
                      // Handle export completion
                    },
                  );
                  break;
                case 'delete':
                  SwiftleadConfirmationDialog.show(
                    context: context,
                    title: 'Delete Job',
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
              const PopupMenuItem(value: 'assign', child: Text('Assign')),
              const PopupMenuItem(value: 'export', child: Text('Export')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // JobSummaryCard - Key information at top
          _buildJobSummaryCard(),
          
          // ActionButtonsRow - Sticky on scroll
          _buildActionButtonsRow(),
          
          // JobTabView - Horizontal tabs
          _buildJobTabView(),
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
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // ServiceBadge
          Row(
            children: [
              ProgressPill(status: _job!.status.displayName),
              const SizedBox(width: SwiftleadTokens.spaceS),
              if (_job!.scheduledDate != null)
                DateChip(
                  date: _job!.scheduledDate!,
                  isDue: _job!.scheduledDate!.isBefore(DateTime.now()),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // ProgressBar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildActionButtonsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Wrap(
        spacing: SwiftleadTokens.spaceS,
        runSpacing: SwiftleadTokens.spaceS,
        children: [
          OutlinedButton.icon(
            onPressed: _handleMessageClient,
            icon: const Icon(Icons.message),
            label: const Text('Message Client'),
          ),
          OutlinedButton.icon(
            onPressed: _handleCreateQuoteFromJob,
            icon: const Icon(Icons.request_quote),
            label: const Text('Send Quote'),
          ),
          OutlinedButton.icon(
            onPressed: _handleSendInvoiceFromJob,
            icon: const Icon(Icons.receipt),
            label: const Text('Send Invoice'),
          ),
          PrimaryButton(
            label: 'Mark Complete',
            onPressed: () {},
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildJobTabView() {
    return Column(
      children: [
        // SegmentedControl for tabs
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: SegmentedControl(
            segments: _tabs,
            selectedIndex: _selectedTabIndex,
            onSelectionChanged: (index) {
              setState(() => _selectedTabIndex = index);
            },
          ),
        ),
        
        // Tab content
        IndexedStack(
          index: _selectedTabIndex,
          children: [
            _buildTimelineTab(),
            _buildDetailsTab(),
            _buildNotesTab(),
            _buildMessagesTab(),
            _buildMediaTab(),
          ],
        ),
        const SizedBox(height: 96), // Bottom padding for nav bar
      ],
    );
  }

  Widget _buildTimelineTab() {
    final hasActivity = true; // Replace with actual data check

    if (!hasActivity) {
      return EmptyStateCard(
        title: 'No activity yet',
        description: 'Activity timeline will show job updates and events.',
        icon: Icons.history,
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ...List.generate(5, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _TimelineItem(
            icon: _getTimelineIcon(index),
            title: _getTimelineTitle(index),
            subtitle: _getTimelineSubtitle(index),
            timestamp: DateTime.now().subtract(Duration(hours: index * 3)),
            user: _getTimelineUser(index),
          ),
        )),
      ],
    );
  }

  IconData _getTimelineIcon(int index) {
    final icons = [
      Icons.check_circle,
      Icons.assignment,
      Icons.camera_alt,
      Icons.message,
      Icons.person_add,
    ];
    return icons[index % icons.length];
  }

  String _getTimelineTitle(int index) {
    final titles = [
      'Job marked complete',
      'Invoice sent',
      'Photos uploaded',
      'Message sent to client',
      'Assigned to team member',
    ];
    return titles[index % titles.length];
  }

  String _getTimelineSubtitle(int index) {
    final subtitles = [
      'Job completed successfully',
      'Invoice #INV-1234',
      '3 photos added',
      'Check-in message sent',
      'Sarah Williams',
    ];
    return subtitles[index % subtitles.length];
  }

  String _getTimelineUser(int index) {
    final users = ['Alex Johnson', 'System', 'Alex Johnson', 'System', 'System'];
    return users[index % users.length];
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
                    onPressed: () {},
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
    
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Add Note',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          TextField(
            controller: noteController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Enter your note...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          PrimaryButton(
            label: 'Save Note',
            onPressed: () {
              // Save note
              Navigator.pop(context);
              setState(() {}); // Refresh to show new note
            },
            icon: Icons.save,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              _DetailRow(
                label: 'Location',
                value: '123 Main Street, London',
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.headlineSmall,
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
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: SwiftleadTokens.spaceS,
            mainAxisSpacing: SwiftleadTokens.spaceS,
          ),
          itemCount: 9, // Example
          itemBuilder: (context, index) => MediaThumbnail(
            label: 'Photo ${index + 1}',
            onTap: () {
              // Open full screen gallery
            },
          ),
        ),
      ],
    );
  }

  void _showMediaUploadSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Upload Media',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Select media to upload:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open gallery picker
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open camera
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: const Text('Choose Document'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Open file picker
            },
          ),
        ],
      ),
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

