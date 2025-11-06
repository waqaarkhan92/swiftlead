import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/components/animated_counter.dart';
import '../../widgets/components/smart_collapsible_section.dart';
import '../../widgets/components/celebration_banner.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/components/trend_tile.dart';
import '../../utils/keyboard_shortcuts.dart' show AppShortcuts, SearchIntent, CreateIntent, RefreshIntent, CloseIntent;
import '../../theme/tokens.dart';
import '../../mock/mock_contacts.dart';
import 'contact_detail_screen.dart';
import 'contact_import_wizard_screen.dart';
import 'contact_export_builder_screen.dart';
import 'create_edit_contact_screen.dart';
import 'duplicate_detector_screen.dart';
import 'segments_screen.dart';
import '../main_navigation.dart' as main_nav;
import '../../widgets/forms/contacts_filter_sheet.dart';

/// Contacts Screen - Contact list view with search and filters
/// Exact specification from UI_Inventory_v2.5.1
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  ContactsFilters? _currentFilters;
  
  // Smart prioritization tracking
  final Map<String, int> _contactTapCounts = {};
  final Map<String, DateTime> _contactLastOpened = {};
  
  // Celebration tracking
  final Set<String> _milestonesShown = {};
  String? _celebrationMessage;
  
  // Progressive disclosure states
  bool _vipExpanded = true;
  bool _recentExpanded = true;
  bool _allExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await MockContacts.fetchAll();
    if (mounted) {
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
        _applySmartPrioritization();
        _isLoading = false;
      });
    }
    
    _checkForMilestones();
  }
  
  // Phase 2: Smart prioritization and contextual hiding
  void _applySmartPrioritization() {
    // Phase 2: Smart prioritization - sort using interaction tracking
    _filteredContacts.sort((a, b) {
      // VIP first (check tags or score for VIP)
      final aIsVIP = a.tags.contains('VIP') || a.score >= 90;
      final bIsVIP = b.tags.contains('VIP') || b.score >= 90;
      if (aIsVIP != bIsVIP) {
        return aIsVIP ? -1 : 1;
      }
      
      // Phase 2: Favor frequently accessed contacts
      final aTapCount = _contactTapCounts[a.id] ?? 0;
      final bTapCount = _contactTapCounts[b.id] ?? 0;
      if (aTapCount != bTapCount) {
        return bTapCount.compareTo(aTapCount);
      }
      
      // Phase 2: Favor recently opened contacts
      final aLastOpened = _contactLastOpened[a.id];
      final bLastOpened = _contactLastOpened[b.id];
      if (aLastOpened != null && bLastOpened != null) {
        return bLastOpened.compareTo(aLastOpened);
      }
      if (aLastOpened != null) return -1;
      if (bLastOpened != null) return 1;
      
      // Finally by score (higher score first)
      return b.score.compareTo(a.score);
    });
    
    // Phase 2: Contextual hiding - hide contacts with score <30 and not accessed in >90 days
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90));
    _filteredContacts = _filteredContacts.where((contact) {
      final isVIP = contact.tags.contains('VIP') || contact.score >= 90;
      if (isVIP || contact.score >= 30) return true;
      if (_contactLastOpened[contact.id] != null && 
          _contactLastOpened[contact.id]!.isAfter(ninetyDaysAgo)) return true;
      return false; // Hide low-scoring inactive contacts
    }).toList();
  }
  
  // Track contact interaction for smart prioritization
  void _trackContactInteraction(String contactId) {
    setState(() {
      _contactTapCounts[contactId] = (_contactTapCounts[contactId] ?? 0) + 1;
      _contactLastOpened[contactId] = DateTime.now();
    });
  }
  
  // Phase 3: Expanded celebration milestones
  void _checkForMilestones() {
    // 100 contacts milestone
    if (_contacts.length >= 100 && !_milestonesShown.contains('100contacts')) {
      _milestonesShown.add('100contacts');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎉 100 contacts! Growing network!';
          });
        }
      });
    }
    // 50 contacts milestone
    else if (_contacts.length >= 50 && _contacts.length < 100 && !_milestonesShown.contains('50contacts')) {
      _milestonesShown.add('50contacts');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🌟 50 contacts! Building your network!';
          });
        }
      });
    }
    // Phase 3: 25 contacts milestone
    else if (_contacts.length >= 25 && _contacts.length < 50 && !_milestonesShown.contains('25contacts')) {
      _milestonesShown.add('25contacts');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '👥 25 contacts! Great start!';
          });
        }
      });
    }
    // Phase 3: 10 contacts milestone
    else if (_contacts.length >= 10 && _contacts.length < 25 && !_milestonesShown.contains('10contacts')) {
      _milestonesShown.add('10contacts');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '💼 10 contacts! Building momentum!';
          });
        }
      });
    }
    // Phase 3: First contact milestone
    else if (_contacts.length == 1 && !_milestonesShown.contains('firstcontact')) {
      _milestonesShown.add('firstcontact');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎯 First contact added! Welcome to Swiftlead!';
          });
        }
      });
    }
  }
  
  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Phase 3: Keyboard shortcuts wrapper
    return Shortcuts(
      shortcuts: AppShortcuts.globalShortcuts,
      child: Actions(
        actions: {
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              // Focus search bar (could navigate to search screen)
            },
          ),
          CreateIntent: CallbackAction<CreateIntent>(
            onInvoke: (_) {
              _showAddContactSheet(context);
            },
          ),
          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) {
              _loadContacts();
            },
          ),
          CloseIntent: CallbackAction<CloseIntent>(
            onInvoke: (_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: FrostedAppBar(
              scaffoldKey: main_nav.MainNavigation.scaffoldKey,
              title: 'Contacts',
              actions: [
                // Primary action: Add Contact (iOS-aligned: max 2 icons)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddContactSheet(context),
                ),
                // More menu for secondary actions (iOS-aligned: max 2 icons)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'filter':
                        _showFilterSheet(context);
                        break;
                      case 'duplicates':
                        Navigator.push(
                          context,
                          _createPageRoute(const DuplicateDetectorScreen()),
                        );
                        break;
                      case 'segments':
                        Navigator.push(
                          context,
                          _createPageRoute(const SegmentsScreen()),
                        );
                        break;
                      case 'import':
                        Navigator.push(
                          context,
                          _createPageRoute(const ContactImportWizardScreen()),
                        );
                        break;
                      case 'export':
                        Navigator.push(
                          context,
                          _createPageRoute(const ContactExportBuilderScreen()),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'filter',
                      child: Builder(
                        builder: (context) => Row(
                          children: [
                            const Icon(Icons.filter_list_outlined, size: 20),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'Filter',
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
                      value: 'duplicates',
                      child: Builder(
                        builder: (context) => Row(
                          children: [
                            const Icon(Icons.find_in_page, size: 20),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'Find Duplicates',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'segments',
                      child: Builder(
                        builder: (context) => Row(
                          children: [
                            const Icon(Icons.category, size: 20),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'Segments',
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
                      value: 'import',
                      child: Builder(
                        builder: (context) => Row(
                          children: [
                            const Icon(Icons.upload_file, size: 20),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'Import Contacts',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Builder(
                        builder: (context) => Row(
                          children: [
                            const Icon(Icons.download, size: 20),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'Export Contacts',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
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
            body: _isLoading
                ? _buildLoadingState()
                : _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(8, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 88,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull-to-refresh
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Celebration banner (if milestone reached)
          if (_celebrationMessage != null) ...[
            CelebrationBanner(
              message: _celebrationMessage!,
              onDismiss: () {
                setState(() => _celebrationMessage = null);
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
          ],
          
          // Phase 2: AI Insight Banner - Predictive insights
          if (_filteredContacts.isNotEmpty) ...[
            Builder(
              builder: (context) {
                final coldContacts = _filteredContacts.where((c) => c.score < 60).length;
                final vipContacts = _filteredContacts.where((c) => c.tags.contains('VIP') || c.score >= 90).length;
                
                String? insight;
                if (coldContacts > 10) {
                  insight = 'You have $coldContacts cold contacts. Consider re-engaging with follow-up campaigns.';
                } else if (vipContacts == 0 && _filteredContacts.length > 20) {
                  insight = 'Consider tagging your top contacts as VIP to prioritize important relationships.';
                }
                
                if (insight != null) {
                  return AIInsightBanner(
                    message: insight,
                    onDismiss: () {},
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],
          
          // SearchBar
          SwiftleadSearchBar(
            hintText: 'Search contacts...',
            recentSearches: ['John Smith', 'Sarah Williams'],
            suggestions: ['Mike Johnson', 'Emily Davis'],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Hot', 'Warm', 'Cold', 'VIP'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Contact List
          if (_filteredContacts.isEmpty)
            EmptyStateCard(
              title: 'No contacts found',
              description: _currentFilters != null 
                  ? 'No contacts match the selected filters'
                  : 'Add your first contact to get started',
              icon: Icons.people_outline,
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                // Phase 3: Staggered animation
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Dismissible(
                  key: Key(contact.id),
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: SwiftleadTokens.spaceM),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.errorRed),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: SwiftleadTokens.spaceM),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      // Delete contact
                      // TODO: Implement delete
                    }
                    setState(() {
                      _filteredContacts.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Contact'),
                          content: const Text('Are you sure you want to delete this contact?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(SwiftleadTokens.errorRed),
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      return confirmed ?? false;
                    }
                    return false;
                  },
                  child: GestureDetector(
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      _showContactContextMenu(context, contact);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: _ContactCard(
                        contact: contact,
                        onTap: () {
                          _trackContactInteraction(contact.id);
                          Navigator.push(
                            context,
                            _createPageRoute(ContactDetailScreen(
                              contactId: contact.id,
                            )),
                          ).then((result) {
                            if (result == true) {
                              _loadContacts(); // Refresh list if contact was updated
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showContactContextMenu(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Call'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement call
                },
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Message'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement message
                },
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement email
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    _createPageRoute(CreateEditContactScreen(contactId: contact.id)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement duplicate
                },
              ),
              Divider(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.08)
                    : Colors.white.withOpacity(0.08),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(SwiftleadTokens.errorRed)),
                title: const Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
                onTap: () {
                  Navigator.pop(context);
                  // Delete confirmed via swipe
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) async {
    final filters = await ContactsFilterSheet.show(
      context: context,
    );
    if (filters != null) {
      // Apply filters to contact list
      _applyFilters(filters);
    }
  }

  void _applyFilters(ContactsFilters filters) {
    setState(() {
      _currentFilters = filters;
      _filteredContacts = _contacts.where((contact) {
        // Stage filter
        if (filters.stageFilters.isNotEmpty) {
          if (!filters.stageFilters.contains(contact.stage)) {
            return false;
          }
        }
        
        // Score filter
        if (filters.scoreFilters.isNotEmpty) {
          bool matchesScore = false;
          for (final scoreFilter in filters.scoreFilters) {
            if (scoreFilter == 'Hot (80+)' && contact.score >= 80) {
              matchesScore = true;
              break;
            } else if (scoreFilter == 'Warm (60-79)' && contact.score >= 60 && contact.score < 80) {
              matchesScore = true;
              break;
            } else if (scoreFilter == 'Cold (<60)' && contact.score < 60) {
              matchesScore = true;
              break;
            }
          }
          if (!matchesScore) return false;
        }
        
        // Source filter
        if (filters.sourceFilters.isNotEmpty) {
          if (contact.source == null || !filters.sourceFilters.contains(contact.source)) {
            return false;
          }
        }
        
        // Tag filter
        if (filters.tagFilters.isNotEmpty) {
          bool hasTag = false;
          for (final tag in filters.tagFilters) {
            if (contact.tags.contains(tag)) {
              hasTag = true;
              break;
            }
          }
          if (!hasTag) return false;
        }
        
        return true;
      }).toList();
      _applySmartPrioritization();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_filteredContacts.length} contact(s) match filters'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddContactSheet(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const CreateEditContactScreen()),
    ).then((result) {
      if (result == true) {
        _loadContacts(); // Refresh list if contact was created
      }
    });
  }
}

class _ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const _ContactCard({
    required this.contact,
    required this.onTap,
  });

  String _getScoreClassification(int score) {
    if (score >= 80) return 'Hot';
    if (score >= 60) return 'Warm';
    return 'Cold';
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(SwiftleadTokens.errorRed);
    if (score >= 60) return const Color(SwiftleadTokens.warningYellow);
    return const Color(SwiftleadTokens.infoBlue);
  }

  @override
  Widget build(BuildContext context) {
    final classification = _getScoreClassification(contact.score);
    final scoreColor = _getScoreColor(contact.score);
    final isVIP = contact.tags.contains('VIP');

    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                
                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              contact.name,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVIP) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Color(SwiftleadTokens.warningYellow),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'VIP',
                                    style: TextStyle(
                                      color: Color(SwiftleadTokens.warningYellow),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contact.email ?? contact.phone ?? 'No contact info',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (contact.tags.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: contact.tags.where((tag) => tag != 'VIP').take(2).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Color(SwiftleadTokens.primaryTeal),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Badges
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        classification,
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.stage.displayName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

