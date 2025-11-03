import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/job_card.dart';
import '../../theme/tokens.dart';
import '../../models/job.dart';
import '../../mock/mock_repository.dart';
import '../../config/mock_config.dart';
import 'job_detail_screen.dart';

/// JobSearchScreen - Search jobs by title, client, service type
/// Exact specification from UI_Inventory_v2.5.1
class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Job> _searchResults = [];
  List<Job> _allJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    if (kUseMockData) {
      final jobs = await MockJobs.fetchAll();
      if (mounted) {
        setState(() {
          _allJobs = jobs;
        });
      }
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allJobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.contactName.toLowerCase().contains(query.toLowerCase()) ||
            job.serviceType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Search Jobs',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // SearchBar
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SwiftleadSearchBar(
              controller: _searchController,
              hintText: 'Search jobs by title, client, or service type...',
              onChanged: _performSearch,
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? _searchResults.isNotEmpty
                    ? _buildSearchResults()
                    : _buildEmptyState()
                : _buildSearchTips(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTips() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Search Tips',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        _TipItem(
          icon: Icons.search,
          tip: 'Search by job title or description',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.person,
          tip: 'Search by client name',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.work,
          tip: 'Search by service type',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateCard(
      title: 'No results found',
      description: 'Try different keywords or check your spelling.',
      icon: Icons.search_off,
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final job = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: JobCard(
            jobTitle: job.title,
            clientName: job.contactName,
            serviceType: job.serviceType,
            status: job.status.displayName,
            dueDate: job.scheduledDate,
            price: '£${job.value.toStringAsFixed(2)}',
            teamMemberName: job.assignedTo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                    jobId: job.id,
                    jobTitle: job.title,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String tip;

  const _TipItem({
    required this.icon,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: Text(
            tip,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

