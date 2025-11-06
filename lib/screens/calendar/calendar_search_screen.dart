import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/components/booking_card.dart';
import '../../theme/tokens.dart';
import '../../mock/mock_bookings.dart';
import '../../models/booking.dart';
import '../../models/job.dart';
import '../../mock/mock_jobs.dart';
import 'booking_detail_screen.dart';

/// CalendarSearchScreen - Search bookings and events
/// Exact specification from UI_Inventory_v2.5.1
class CalendarSearchScreen extends StatefulWidget {
  const CalendarSearchScreen({super.key});

  @override
  State<CalendarSearchScreen> createState() => _CalendarSearchScreenState();
}

class _CalendarSearchScreenState extends State<CalendarSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  List<Booking> _searchResults = [];
  List<Job> _jobResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _jobResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    // Search bookings
    final allBookings = await MockBookings.fetchAll();
    final bookingResults = allBookings.where((booking) {
      final queryLower = query.toLowerCase();
      return (booking.contactName?.toLowerCase().contains(queryLower) ?? false) ||
          (booking.serviceType?.toLowerCase().contains(queryLower) ?? false) ||
          (booking.location?.toLowerCase().contains(queryLower) ?? false) ||
          (booking.notes?.toLowerCase().contains(queryLower) ?? false);
    }).toList();

    // Search jobs
    final allJobs = await MockJobs.fetchAll();
    final jobResults = allJobs.where((job) {
      final queryLower = query.toLowerCase();
      return job.title.toLowerCase().contains(queryLower) ||
          (job.contactName?.toLowerCase().contains(queryLower) ?? false) ||
          (job.serviceType?.toLowerCase().contains(queryLower) ?? false) ||
          job.description.toLowerCase().contains(queryLower);
    }).toList();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _searchResults = bookingResults;
        _jobResults = jobResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Search Calendar',
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
              hintText: 'Search bookings, clients, or service types...',
              onChanged: _performSearch,
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isSearching
                    ? (_searchResults.isEmpty && _jobResults.isEmpty
                        ? _buildEmptyState()
                        : _buildSearchResults())
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
          tip: 'Search by client name or booking title',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.calendar_today,
          tip: 'Search by date or service type',
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
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        if (_searchResults.isNotEmpty) ...[
          Text(
            'Bookings (${_searchResults.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          ..._searchResults.map((booking) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: BookingCard(
                bookingId: booking.id,
                      clientName: booking.contactName ?? '',
                      serviceName: booking.serviceType ?? '',
                startTime: booking.startTime,
                endTime: booking.endTime,
                status: booking.status.displayName,
                onTap: () {
                  Navigator.push(
                    context,
                    _createPageRoute(BookingDetailScreen(
                      bookingId: booking.id,
                      clientName: booking.contactName ?? '',
                    )),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],
        if (_jobResults.isNotEmpty) ...[
          Text(
            'Jobs (${_jobResults.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          ..._jobResults.map((job) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: ListTile(
                title: Text(job.title),
                subtitle: Text('${job.contactName} • ${job.serviceType}'),
                trailing: Text(job.status.displayName),
                onTap: () {
                  // Navigate to job detail
                  Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ],
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

