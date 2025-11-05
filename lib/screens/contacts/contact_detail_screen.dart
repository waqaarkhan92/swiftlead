import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';
import '../../mock/mock_contacts.dart';
import '../../mock/mock_jobs.dart';
import '../../mock/mock_messages.dart';
import '../../mock/mock_payments.dart';
import '../../mock/mock_calls.dart';
import '../../mock/mock_reviews.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../inbox/inbox_thread_screen.dart';
import '../jobs/create_edit_job_screen.dart';
import '../jobs/job_detail_screen.dart';
import '../money/invoice_detail_screen.dart';
import 'create_edit_contact_screen.dart';
import '../../widgets/components/score_breakdown_card.dart';
import '../../widgets/forms/contact_stage_change_sheet.dart';
import '../../widgets/global/primary_button.dart';

/// Contact Detail Screen - Comprehensive contact view
/// Exact specification from UI_Inventory_v2.5.1
class ContactDetailScreen extends StatefulWidget {
  final String contactId;

  const ContactDetailScreen({
    super.key,
    required this.contactId,
  });

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  Contact? _contact;
  bool _isLoading = true;
  String? _error;
  List<ContactTimelineEvent> _timelineEvents = [];
  List<ContactNote> _notes = [];
  bool _isLoadingTimeline = false;
  bool _isLoadingNotes = false;
  final TextEditingController _notesSearchController = TextEditingController();
  String _notesSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContact();
    _loadNotes();
  }

  Future<void> _loadContact() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final contact = await MockContacts.fetchById(widget.contactId);
      if (mounted) {
        setState(() {
          _contact = contact;
          _isLoading = false;
          if (contact == null) {
            _error = 'Contact not found';
          }
        });
        // Load timeline after contact is loaded
        if (contact != null) {
          await _loadTimeline();
          // Check for auto-progression opportunities after timeline loads
          await _checkAutoProgression(contact);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading contact: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTimeline() async {
    final contact = _contact;
    if (contact == null) return;
    
    setState(() => _isLoadingTimeline = true);
    
    try {
      final events = <ContactTimelineEvent>[];
      
      // Load jobs for this contact
      final allJobs = await MockJobs.fetchAll();
      final contactJobs = allJobs.where((j) => j.contactId == contact.id).toList();
      for (final job in contactJobs) {
        events.add(ContactTimelineEvent(
          id: 'job_${job.id}',
          type: TimelineEventType.job,
          title: job.title,
          subtitle: '${job.serviceType} - ${job.status.name}',
          timestamp: job.createdAt,
          icon: Icons.work,
          metadata: {'jobId': job.id, 'status': job.status.name},
        ));
        if (job.completedAt != null) {
          events.add(ContactTimelineEvent(
            id: 'job_complete_${job.id}',
            type: TimelineEventType.job,
            title: 'Job completed',
            subtitle: job.title,
            timestamp: job.completedAt!,
            icon: Icons.check_circle,
            metadata: {'jobId': job.id},
          ));
        }
      }
      
      // Load messages for this contact
      final allThreads = await MockMessages.fetchAllThreads();
      final contactThreads = allThreads.where((t) => t.contactId == contact.id).toList();
      for (final thread in contactThreads) {
        final lastMessageTime = thread.lastMessageTime;
        if (lastMessageTime != null) {
          events.add(ContactTimelineEvent(
            id: 'message_${thread.id}',
            type: TimelineEventType.message,
            title: 'Message received',
            subtitle: '${thread.channel.displayName} - ${thread.lastMessage}',
            timestamp: lastMessageTime,
            icon: _getChannelIcon(thread.channel),
            metadata: {'threadId': thread.id, 'channel': thread.channel.displayName},
          ));
        }
      }
      
      // Load invoices for this contact
      final allInvoices = await MockPayments.fetchAllInvoices();
      final contactInvoices = allInvoices.where((i) => i.contactId == contact.id).toList();
      for (final invoice in contactInvoices) {
        events.add(ContactTimelineEvent(
          id: 'invoice_${invoice.id}',
          type: TimelineEventType.invoice,
          title: 'Invoice ${invoice.status.name}',
          subtitle: '£${invoice.amount.toStringAsFixed(2)} - ${invoice.serviceDescription}',
          timestamp: invoice.createdAt,
          icon: Icons.receipt,
          metadata: {'invoiceId': invoice.id, 'status': invoice.status.name},
        ));
        if (invoice.paidDate != null) {
          events.add(ContactTimelineEvent(
            id: 'payment_${invoice.id}',
            type: TimelineEventType.payment,
            title: 'Payment received',
            subtitle: '£${invoice.amount.toStringAsFixed(2)}',
            timestamp: invoice.paidDate!,
            icon: Icons.payment,
            metadata: {'invoiceId': invoice.id},
          ));
        }
      }
      
      // Load quotes (if available in mock data)
      // For now, add placeholder quote events based on contact stage
      if (contact.stage == ContactStage.prospect || contact.stage == ContactStage.customer) {
        events.add(ContactTimelineEvent(
          id: 'quote_1',
          type: TimelineEventType.quote,
          title: 'Quote sent',
          subtitle: 'Quote #QT-001',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          icon: Icons.description,
          metadata: {},
        ));
      }
      
      // Load call history for this contact
      final contactCalls = await MockCalls.fetchCallsForContact(contact.id);
      for (final call in contactCalls) {
        final directionLabel = call.direction == CallDirection.inbound ? 'Incoming' : 'Outgoing';
        final durationText = call.status == CallStatus.missed 
            ? 'Missed'
            : '${call.duration.inMinutes}m ${call.duration.inSeconds % 60}s';
        
        events.add(ContactTimelineEvent(
          id: 'call_${call.id}',
          type: TimelineEventType.call,
          title: '$directionLabel call',
          subtitle: '$durationText - ${call.phoneNumber}',
          timestamp: call.timestamp,
          icon: call.direction == CallDirection.inbound 
              ? Icons.call_received 
              : Icons.call_made,
          metadata: {
            'callId': call.id,
            'direction': call.direction.name,
            'status': call.status.name,
            'duration': call.duration.inSeconds,
            'recordingUrl': call.recordingUrl,
            'transcript': call.transcript,
            'aiSummary': call.aiSummary,
          },
        ));
      }
      
      // Load reviews for this contact
      final contactReviews = await MockReviews.fetchReviewsForContact(contact.id);
      for (final review in contactReviews) {
        final sourceLabel = review.source.name[0].toUpperCase() + review.source.name.substring(1);
        final stars = '⭐' * review.rating;
        
        events.add(ContactTimelineEvent(
          id: 'review_${review.id}',
          type: TimelineEventType.review,
          title: '$stars Review on $sourceLabel',
          subtitle: review.reviewText.length > 50 
              ? review.reviewText.substring(0, 50) + '...'
              : review.reviewText,
          timestamp: review.reviewDate,
          icon: Icons.star,
          metadata: {
            'reviewId': review.id,
            'source': review.source.name,
            'rating': review.rating,
            'reviewText': review.reviewText,
            'externalUrl': review.externalUrl,
          },
        ));
      }
      
      // Add email tracking events (email opens and link clicks)
      // Check for email messages and add tracking if available
      for (final thread in contactThreads) {
        if (thread.channel == MessageChannel.email) {
          // Simulate email tracking: 80% open rate, 30% click rate
          final messageTime = thread.lastMessageTime;
          if (messageTime != null) {
            // Email opened event (80% chance)
            final openTime = messageTime.add(const Duration(minutes: 5));
            events.add(ContactTimelineEvent(
              id: 'email_open_${thread.id}',
              type: TimelineEventType.emailTracking,
              title: 'Email opened',
              subtitle: 'Opened 5 minutes after sending',
              timestamp: openTime,
              icon: Icons.mark_email_read,
              metadata: {'threadId': thread.id, 'type': 'open'},
            ));
            
            // Link clicked event (30% chance if opened)
            events.add(ContactTimelineEvent(
              id: 'email_click_${thread.id}',
              type: TimelineEventType.emailTracking,
              title: 'Link clicked in email',
              subtitle: 'Clicked link: View Quote',
              timestamp: messageTime.add(const Duration(minutes: 12)),
              icon: Icons.link,
              metadata: {'threadId': thread.id, 'type': 'click', 'link': 'View Quote'},
            ));
          }
        }
      }
      
      // Sort by timestamp descending
      events.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      if (mounted) {
        setState(() {
          _timelineEvents = events;
          _isLoadingTimeline = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTimeline = false);
      }
    }
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoadingNotes = true);
    
    // Mock notes data
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _notes = [
          ContactNote(
            id: '1',
            content: 'Met at trade show. Interested in commercial plumbing services. Follow up next week. @alex',
            author: 'Sarah Johnson',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            mentions: ['alex'],
            pinned: true,
            attachments: [],
          ),
          ContactNote(
            id: '2',
            content: 'Preferred contact method: WhatsApp. Best time: Afternoon',
            author: 'Alex Johnson',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            mentions: [],
            pinned: false,
            attachments: ['show_photo.jpg'],
          ),
        ];
        // Sort: pinned first, then by timestamp
        _notes.sort((a, b) {
          if (a.pinned != b.pinned) return b.pinned ? 1 : -1;
          return b.timestamp.compareTo(a.timestamp);
        });
        _isLoadingNotes = false;
      });
    }
  }

  List<ContactNote> get _filteredNotes {
    if (_notesSearchQuery.isEmpty) return _notes;
    final query = _notesSearchQuery.toLowerCase();
    return _notes.where((note) {
      return note.content.toLowerCase().contains(query) ||
          note.author.toLowerCase().contains(query) ||
          note.mentions.any((m) => m.toLowerCase().contains(query));
    }).toList();
  }

  IconData _getChannelIcon(MessageChannel channel) {
    switch (channel) {
      case MessageChannel.sms:
        return Icons.sms;
      case MessageChannel.whatsapp:
        return Icons.chat;
      case MessageChannel.email:
        return Icons.email;
      case MessageChannel.facebook:
        return Icons.facebook;
      case MessageChannel.instagram:
        return Icons.photo_camera;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Check for auto-progression opportunities based on timeline events
  Future<void> _checkAutoProgression(Contact contact) async {
    if (contact.stage == ContactStage.lead) {
      // Check if quote was sent - Lead → Prospect
      final hasQuoteSent = _timelineEvents.any((e) => e.type == TimelineEventType.quote);
      if (hasQuoteSent) {
        final progressed = await MockContacts.checkAndProceedQuoteSent(contact.id);
        if (progressed && mounted) {
          await _loadContact(); // Reload to get updated stage
          Toast.show(
            context,
            message: 'Stage auto-progressed: Lead → Prospect (Quote sent)',
            type: ToastType.info,
          );
        }
      }
    } else if (contact.stage == ContactStage.prospect) {
      // Check if payment was received - Prospect → Customer
      final hasPayment = _timelineEvents.any((e) => e.type == TimelineEventType.payment);
      if (hasPayment) {
        final progressed = await MockContacts.checkAndProceedPaymentReceived(contact.id);
        if (progressed && mounted) {
          await _loadContact(); // Reload to get updated stage
          Toast.show(
            context,
            message: 'Stage auto-progressed: Prospect → Customer (Payment received)',
            type: ToastType.info,
          );
        }
      }
    } else if (contact.stage == ContactStage.customer) {
      // Check if 2nd job completed - Customer → Repeat Customer
      final completedJobs = _timelineEvents.where((e) => 
        e.type == TimelineEventType.job && 
        e.title == 'Job completed'
      ).length;
      if (completedJobs >= 2) {
        final completedJobCount = await MockContacts.getCompletedJobCount(contact.id);
        if (completedJobCount >= 2) {
          final progressed = await MockContacts.checkAndProceedSecondJobCompleted(contact.id);
          if (progressed && mounted) {
            await _loadContact(); // Reload to get updated stage
            Toast.show(
              context,
              message: 'Stage auto-progressed: Customer → Repeat Customer (2nd job completed)',
              type: ToastType.info,
            );
          }
        }
      }
    }
  }

  void _handleCreateQuoteFromContact() {
    if (_contact == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuoteScreen(
          initialData: {
            'clientName': _contact!.name,
            'taxRate': 20.0,
          },
        ),
      ),
    ).then((_) {
      Toast.show(
        context,
        message: 'Quote created for contact',
        type: ToastType.success,
      );
    });
  }

  void _handleMessageContact() {
    if (_contact == null) return;
    
    // Determine channel - use SMS as default, could be enhanced
    final channel = 'SMS';
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InboxThreadScreen(
          contactName: _contact!.name,
          channel: channel,
          contactId: _contact!.id,
        ),
      ),
    );
  }

  void _handleCreateJobFromContact() {
    if (_contact == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditJobScreen(
          initialData: {
            'clientName': _contact!.name,
          },
        ),
      ),
    );
  }

  void _handleCallContact() async {
    if (_contact == null || _contact!.phone == null) {
      Toast.show(
        context,
        message: 'Phone number not available',
        type: ToastType.error,
      );
      return;
    }
    
    final uri = Uri.parse('tel:${_contact!.phone}');
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

  void _handleEmailContact() async {
    if (_contact == null || _contact!.email == null) {
      Toast.show(
        context,
        message: 'Email address not available',
        type: ToastType.error,
      );
      return;
    }
    
    final uri = Uri.parse('mailto:${_contact!.email}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        Toast.show(
          context,
          message: 'Cannot open email',
          type: ToastType.error,
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${_contact?.name ?? 'this contact'}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Toast.show(
                context,
                message: 'Contact deleted',
                type: ToastType.success,
              );
              Navigator.of(context).pop(); // Go back to contacts list
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: _isLoading ? 'Loading...' : (_contact?.name ?? 'Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _contact != null ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditContactScreen(
                    contactId: _contact!.id,
                    initialContact: _contact,
                  ),
                ),
              ).then((result) {
                if (result == true) {
                  _loadContact();
                }
              });
            } : null,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _contact != null ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Delete Contact'),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.archive_outlined),
                        title: const Text('Archive Contact'),
                        onTap: () {
                          Navigator.pop(context);
                          Toast.show(
                            context,
                            message: 'Contact archived',
                            type: ToastType.success,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.copy_outlined),
                        title: const Text('Duplicate Contact'),
                        onTap: () {
                          Navigator.pop(context);
                          Toast.show(
                            context,
                            message: 'Contact duplication coming soon',
                            type: ToastType.info,
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  } : null,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          SkeletonLoader(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SkeletonLoader(
            width: double.infinity,
            height: 100,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ],
      );
    }

    if (_error != null || _contact == null) {
      return Center(
        child: EmptyStateCard(
          title: 'Contact not found',
          description: _error ?? 'Unable to load contact details',
          icon: Icons.person_off,
          actionLabel: 'Retry',
          onAction: _loadContact,
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // ContactProfileCard
          _buildProfileCard(),
          
          // TabBar
          const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Timeline'),
              Tab(text: 'Notes'),
              Tab(text: 'Related'),
            ],
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildTimelineTab(),
                _buildNotesTab(),
                _buildRelatedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_contact == null) return const SizedBox.shrink();
    
    return FrostedContainer(
      margin: const EdgeInsets.all(SwiftleadTokens.spaceM),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
              image: _contact!.avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_contact!.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _contact!.avatarUrl == null
                ? Center(
                    child: Text(
                      _getInitials(_contact!.name),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Name
          Text(
            _contact!.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          
          // Contact Info
          if (_contact!.email != null)
            Text(
              _contact!.email!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (_contact!.phone != null)
            Text(
              _contact!.phone!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (_contact!.company != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              _contact!.company!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Stage Progress Bar
          _buildStageProgressBar(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Score Indicator
          _buildScoreIndicator(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // VIP Badge
          if (_contact!.tags.contains('VIP'))
            Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SwiftleadTokens.spaceS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: const Color(SwiftleadTokens.warningYellow),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'VIP',
                      style: TextStyle(
                        color: const Color(SwiftleadTokens.warningYellow),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Tags
          if (_contact!.tags.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceXS,
              runSpacing: SwiftleadTokens.spaceXS,
              children: _contact!.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Color(SwiftleadTokens.primaryTeal),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.phone,
                label: 'Call',
                onTap: _handleCallContact,
              ),
              _QuickActionButton(
                icon: Icons.message,
                label: 'Message',
                onTap: _handleMessageContact,
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                onTap: _handleEmailContact,
              ),
              _QuickActionButton(
                icon: Icons.work_outline,
                label: 'Create Job',
                onTap: _handleCreateJobFromContact,
              ),
              _QuickActionButton(
                icon: Icons.description,
                label: 'Create Quote',
                onTap: _handleCreateQuoteFromContact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageProgressBar() {
    if (_contact == null) return const SizedBox.shrink();
    
    final stages = ['Lead', 'Prospect', 'Customer', 'Repeat Customer'];
    final currentStage = _contact!.stage.displayName;
    final currentIndex = stages.indexWhere((s) => s == currentStage);
    
    final displayIndex = currentIndex >= 0 ? currentIndex : 0;

    return GestureDetector(
      onTap: () async {
        final newStage = await ContactStageChangeSheet.show(
          context: context,
          currentStage: _contact!.stage,
        );
        if (newStage != null && newStage != _contact!.stage) {
          // Update contact stage
          final oldStage = _contact!.stage;
          await MockContacts.updateContactStage(_contact!.id, newStage);
          await _loadContact();
          
          // Show notification for stage change
          Toast.show(
            context,
            message: 'Stage updated: ${oldStage.displayName} → ${newStage.displayName}',
            type: ToastType.success,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lifecycle Stage',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.06)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: (displayIndex + 1) / stages.length,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            currentStage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator() {
    if (_contact == null) return const SizedBox.shrink();
    
    final score = _contact!.score;
    final classification = score >= 80 ? 'Hot' : (score >= 60 ? 'Warm' : 'Cold');
    final color = score >= 80 
        ? const Color(SwiftleadTokens.errorRed)
        : (score >= 60 ? const Color(SwiftleadTokens.warningYellow) : const Color(SwiftleadTokens.infoBlue));

    return GestureDetector(
      onTap: () {
        ScoreBreakdownCard.show(
          context: context,
          contactId: _contact!.id,
          contactName: _contact!.name,
          score: score,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead Score',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                classification,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              if (_contact!.email != null) ...[
                _InfoRow(label: 'Email', value: _contact!.email!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.phone != null) ...[
                _InfoRow(label: 'Phone', value: _contact!.phone!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.company != null) ...[
                _InfoRow(label: 'Company', value: _contact!.company!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              if (_contact!.source != null) ...[
                _InfoRow(label: 'Source', value: _contact!.source!),
                const SizedBox(height: SwiftleadTokens.spaceS),
              ],
              _InfoRow(label: 'Stage', value: _contact!.stage.displayName),
              const SizedBox(height: SwiftleadTokens.spaceS),
              _InfoRow(label: 'Tags', value: _contact!.tags.isEmpty ? 'None' : _contact!.tags.join(', ')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab() {
    TimelineEventType? selectedActivityFilter;
    final List<TimelineEventType?> activityTypes = [
      null, // All
      TimelineEventType.message,
      TimelineEventType.job,
      TimelineEventType.quote,
      TimelineEventType.invoice,
      TimelineEventType.payment,
      TimelineEventType.call,
      TimelineEventType.review,
    ];
    
    final filteredEvents = selectedActivityFilter == null
        ? _timelineEvents
        : _timelineEvents.where((e) => e.type == selectedActivityFilter).toList();
    
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: activityTypes.map((type) {
                  final label = type == null ? 'All' : type.name.toUpperCase();
                  final isSelected = selectedActivityFilter == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                    child: SwiftleadChip(
                      label: label,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedActivityFilter = type;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Timeline list
          Expanded(
            child: _isLoadingTimeline
                ? ListView(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    children: List.generate(3, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 80,
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    )),
                  )
                : filteredEvents.isEmpty
                    ? Center(
                        child: EmptyStateCard(
                          title: 'No activity yet',
                          description: 'Activity will appear here as you interact with this contact',
                          icon: Icons.timeline,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                            child: _TimelineItem(
                              icon: event.icon,
                              title: event.title,
                              subtitle: event.subtitle,
                              time: _formatTimeAgo(event.timestamp),
                              onTap: () => _handleTimelineEventTap(event),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _handleTimelineEventTap(ContactTimelineEvent event) {
    switch (event.type) {
      case TimelineEventType.job:
        if (event.metadata['jobId'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(
                jobId: event.metadata['jobId'] as String,
                jobTitle: event.title,
              ),
            ),
          );
        }
        break;
      case TimelineEventType.invoice:
      case TimelineEventType.payment:
        if (event.metadata['invoiceId'] != null) {
          final invoiceId = event.metadata['invoiceId'] as String;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceDetailScreen(
                invoiceId: invoiceId,
                invoiceNumber: invoiceId.startsWith('INV-') ? invoiceId : 'INV-$invoiceId',
              ),
            ),
          );
        }
        break;
      case TimelineEventType.message:
        if (event.metadata['threadId'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InboxThreadScreen(
                contactName: _contact?.name ?? 'Contact',
                contactId: _contact?.id ?? '',
                channel: event.metadata['channel'] ?? 'SMS',
              ),
            ),
          );
        }
        break;
      case TimelineEventType.call:
        // Could show call details modal with transcript/recording
        if (event.metadata['aiSummary'] != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(event.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.subtitle),
                  if (event.metadata['aiSummary'] != null) ...[
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Text(
                      'Summary:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(event.metadata['aiSummary'] as String),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
        break;
      case TimelineEventType.review:
        // Could show full review details
        if (event.metadata['reviewText'] != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(event.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.metadata['reviewText'] as String),
                  if (event.metadata['externalUrl'] != null) ...[
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    TextButton.icon(
                      onPressed: () {
                        // Could open external URL
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text('View on ${event.metadata['source']}'),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
        break;
      case TimelineEventType.emailTracking:
        // Email tracking events are informational only
        break;
      default:
        break;
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Add Note Button and Search
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  PrimaryButton(
                    label: 'Add Note',
                    onPressed: () => _showAddNoteSheet(context),
                    icon: Icons.add,
                    size: ButtonSize.small,
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Search Bar
              TextField(
                controller: _notesSearchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _notesSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _notesSearchController.clear();
                            setState(() => _notesSearchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
                onChanged: (value) {
                  setState(() => _notesSearchQuery = value);
                },
              ),
            ],
          ),
        ),
        // Notes List
        Expanded(
          child: _isLoadingNotes
              ? ListView(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  children: List.generate(2, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: 120,
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  )),
                )
              : _filteredNotes.isEmpty
                  ? Center(
                      child: EmptyStateCard(
                        title: _notesSearchQuery.isNotEmpty ? 'No notes found' : 'No notes yet',
                        description: _notesSearchQuery.isNotEmpty
                            ? 'Try a different search term'
                            : 'Add notes to track important information about this contact',
                        icon: Icons.note_add,
                        actionLabel: _notesSearchQuery.isNotEmpty ? null : 'Add First Note',
                        onAction: _notesSearchQuery.isNotEmpty ? null : () => _showAddNoteSheet(context),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = _filteredNotes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                          child: _NoteCard(
                            note: note,
                            onPinToggle: () {
                              setState(() {
                                final noteIndex = _notes.indexWhere((n) => n.id == note.id);
                                if (noteIndex != -1) {
                                  _notes[noteIndex] = ContactNote(
                                    id: note.id,
                                    content: note.content,
                                    author: note.author,
                                    timestamp: note.timestamp,
                                    mentions: note.mentions,
                                    pinned: !note.pinned,
                                    attachments: note.attachments,
                                  );
                                  _notes.sort((a, b) {
                                    if (a.pinned != b.pinned) return b.pinned ? 1 : -1;
                                    return b.timestamp.compareTo(a.timestamp);
                                  });
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    bool isBold = false;
    bool isItalic = false;
    final List<String> selectedAttachments = [];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SwiftleadTokens.radiusModal),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Note',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                // Rich text formatting toolbar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.format_bold, size: 20, color: isBold ? const Color(SwiftleadTokens.primaryTeal) : null),
                      onPressed: () {
                        setState(() => isBold = !isBold);
                      },
                      tooltip: 'Bold',
                    ),
                    IconButton(
                      icon: Icon(Icons.format_italic, size: 20, color: isItalic ? const Color(SwiftleadTokens.primaryTeal) : null),
                      onPressed: () {
                        setState(() => isItalic = !isItalic);
                      },
                      tooltip: 'Italic',
                    ),
                    IconButton(
                      icon: const Icon(Icons.alternate_email, size: 20),
                      onPressed: () {
                        final text = noteController.text;
                        final selection = noteController.selection;
                        noteController.text = text.substring(0, selection.start) + '@' + text.substring(selection.end);
                        noteController.selection = TextSelection.collapsed(offset: selection.start + 1);
                      },
                      tooltip: 'Mention (@username)',
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, size: 20),
                      onPressed: () async {
                        // Simulate file picker
                        setState(() {
                          selectedAttachments.add('attachment_${selectedAttachments.length + 1}.pdf');
                        });
                        Toast.show(
                          context,
                          message: 'File attached',
                          type: ToastType.success,
                        );
                      },
                      tooltip: 'Attach file',
                    ),
                  ],
                ),
                // Show attached files
                if (selectedAttachments.isNotEmpty) ...[
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceXS,
                    children: selectedAttachments.map((file) {
                      return Chip(
                        label: Text(file),
                        onDeleted: () {
                          setState(() {
                            selectedAttachments.remove(file);
                          });
                        },
                        deleteIcon: const Icon(Icons.close, size: 18),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: noteController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter your note... Use @ to mention team members.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                PrimaryButton(
                  label: 'Save Note',
                  onPressed: () async {
                    if (noteController.text.trim().isEmpty) {
                      Toast.show(
                        context,
                        message: 'Please enter a note',
                        type: ToastType.error,
                      );
                      return;
                    }
                    
                    // Extract mentions
                    final mentionRegex = RegExp(r'@(\w+)');
                    final mentions = mentionRegex.allMatches(noteController.text).map((m) => m.group(1)!).toList();
                    
                    // Create new note
                    final newNote = ContactNote(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      content: noteController.text.trim(),
                      author: 'You', // In real app, use current user
                      timestamp: DateTime.now(),
                      mentions: mentions,
                      pinned: false,
                      attachments: List.from(selectedAttachments),
                    );
                    
                    setState(() {
                      _notes.insert(0, newNote);
                      _notes.sort((a, b) {
                        if (a.pinned != b.pinned) return b.pinned ? 1 : -1;
                        return b.timestamp.compareTo(a.timestamp);
                      });
                    });
                    
                    Navigator.pop(context);
                    Toast.show(
                      context,
                      message: 'Note added successfully',
                      type: ToastType.success,
                    );
                  },
                  icon: Icons.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedTab() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Items',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Jobs, Quotes, Invoices related to this contact',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback? onTap;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final ContactNote note;
  final VoidCallback? onPinToggle;

  const _NoteCard({required this.note, this.onPinToggle});

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (note.pinned)
                    const Padding(
                      padding: EdgeInsets.only(right: SwiftleadTokens.spaceXS),
                      child: Icon(
                        Icons.push_pin,
                        size: 16,
                        color: Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  Text(
                    note.author,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    _formatTimeAgo(note.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (onPinToggle != null) ...[
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    IconButton(
                      icon: Icon(
                        note.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                        size: 18,
                        color: note.pinned ? const Color(SwiftleadTokens.primaryTeal) : null,
                      ),
                      onPressed: onPinToggle,
                      tooltip: note.pinned ? 'Unpin note' : 'Pin note',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _buildNoteContent(context, note.content, note.mentions),
          if (note.attachments.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceXS,
              runSpacing: SwiftleadTokens.spaceXS,
              children: note.attachments.map((file) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.attach_file, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        file,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          if (note.mentions.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceXS,
              children: note.mentions.map((mention) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceXS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '@$mention',
                    style: const TextStyle(
                      color: Color(SwiftleadTokens.primaryTeal),
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteContent(BuildContext context, String content, List<String> mentions) {
    // Simple text rendering with mention highlighting
    final mentionRegex = RegExp(r'@(\w+)');
    
    // Check if there are any mentions
    if (!mentionRegex.hasMatch(content)) {
      return Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    
    // Build rich text with mentions highlighted
    final spans = <TextSpan>[];
    int lastIndex = 0;
    
    for (final match in mentionRegex.allMatches(content)) {
      // Add text before mention
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: content.substring(lastIndex, match.start),
          style: Theme.of(context).textTheme.bodyMedium,
        ));
      }
      
      // Add highlighted mention
      spans.add(TextSpan(
        text: match.group(0),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(SwiftleadTokens.primaryTeal),
              fontWeight: FontWeight.w600,
            ),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastIndex),
        style: Theme.of(context).textTheme.bodyMedium,
      ));
    }
    
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// Timeline and Notes Data Models
enum TimelineEventType {
  message,
  job,
  booking,
  quote,
  invoice,
  payment,
  review,
  note,
  call,
  emailTracking,
}

class ContactTimelineEvent {
  final String id;
  final TimelineEventType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final Map<String, dynamic> metadata;

  ContactTimelineEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    this.metadata = const {},
  });
}

class ContactNote {
  final String id;
  final String content;
  final String author;
  final DateTime timestamp;
  final List<String> mentions;
  final bool pinned;
  final List<String> attachments; // File names/URLs

  ContactNote({
    required this.id,
    required this.content,
    required this.author,
    required this.timestamp,
    this.mentions = const [],
    this.pinned = false,
    this.attachments = const [],
  });
}

