import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';
import '../../mock/mock_contacts.dart';
import '../../models/contact.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  ContactsFilters? _currentFilters;

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
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Contacts',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => _showFilterSheet(context),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'import':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactImportWizardScreen(),
                    ),
                  );
                  break;
                case 'export':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactExportBuilderScreen(),
                    ),
                  );
                  break;
                case 'duplicates':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuplicateDetectorScreen(),
                    ),
                  );
                  break;
                case 'segments':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SegmentsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload_file, size: 20),
                    SizedBox(width: SwiftleadTokens.spaceS),
                    Text('Import Contacts'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: SwiftleadTokens.spaceS),
                    Text('Export Contacts'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'duplicates',
                child: Row(
                  children: [
                    Icon(Icons.find_in_page, size: 20),
                    SizedBox(width: SwiftleadTokens.spaceS),
                    Text('Find Duplicates'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'segments',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 20),
                    SizedBox(width: SwiftleadTokens.spaceS),
                    Text('Segments'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContactSheet(context),
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
                return Padding(
                  padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                  child: _ContactCard(
                    contactName: contact.name,
                    contactEmail: contact.email ?? 'No email',
                    stage: contact.stage.displayName,
                    score: contact.score,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetailScreen(
                            contactId: contact.id,
                          ),
                        ),
                      ).then((result) {
                        if (result == true) {
                          _loadContacts(); // Refresh list if contact was updated
                        }
                      });
                    },
                  ),
                );
              },
            ),
        ],
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
      MaterialPageRoute(
        builder: (context) => const CreateEditContactScreen(),
      ),
    ).then((result) {
      if (result == true) {
        _loadContacts(); // Refresh list if contact was created
      }
    });
  }
  
  String _getStage(int index) {
    final stages = ['Lead', 'Prospect', 'Customer', 'Repeat Customer'];
    return stages[index % stages.length];
  }

  int _getScore(int index) {
    return 60 + (index * 7) % 40; // 60-100 range
  }
}

class _ContactCard extends StatelessWidget {
  final String contactName;
  final String contactEmail;
  final String stage;
  final int score;
  final VoidCallback onTap;

  const _ContactCard({
    required this.contactName,
    required this.contactEmail,
    required this.stage,
    required this.score,
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
    final classification = _getScoreClassification(score);
    final scoreColor = _getScoreColor(score);

    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                  contactName[0],
                  style: TextStyle(
                    color: const Color(SwiftleadTokens.primaryTeal),
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
                  Text(
                    contactName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contactEmail,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                  stage,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

