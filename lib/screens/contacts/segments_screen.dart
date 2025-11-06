import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import 'segment_builder_screen.dart';

/// Segments List Screen - List of saved contact segments
/// Exact specification from UI_Inventory_v2.5.1
class SegmentsScreen extends StatefulWidget {
  const SegmentsScreen({super.key});

  @override
  State<SegmentsScreen> createState() => _SegmentsScreenState();
}

class _SegmentsScreenState extends State<SegmentsScreen> {
  bool _isLoading = true;
  final List<ContactSegment> _segments = [];

  // Smooth page route transitions
  PageRoute<T> _createPageRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
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

  @override
  void initState() {
    super.initState();
    _loadSegments();
  }

  Future<void> _loadSegments() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _segments.addAll([
        ContactSegment(
          id: '1',
          name: 'Hot Prospects',
          count: 42,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        ContactSegment(
          id: '2',
          name: 'VIP Customers',
          count: 18,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        ContactSegment(
          id: '3',
          name: 'New Leads (7 days)',
          count: 25,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        ContactSegment(
          id: '4',
          name: 'At-Risk (60 days inactive)',
          count: 8,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Segments',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createSegment(),
            tooltip: 'Create Segment',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _segments.isEmpty
              ? _buildEmptyState()
              : _buildSegmentsList(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 20),
                const SizedBox(height: SwiftleadTokens.spaceS),
                SkeletonLoader(width: 150, height: 16),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: EmptyStateCard(
        icon: Icons.category_outlined,
        title: 'No Segments Yet',
        description: 'Create your first segment to organize contacts.',
        actionLabel: 'Create Segment',
        onAction: _createSegment,
      ),
    );
  }

  Widget _buildSegmentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _segments.length,
      itemBuilder: (context, index) {
        final segment = _segments[index];
        return _buildSegmentCard(segment, index);
      },
    );
  }

  Widget _buildSegmentCard(ContactSegment segment, int index) {
    return Dismissible(
      key: Key('segment_${segment.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.errorRed).withOpacity(0.2),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(Icons.delete_outline, color: Color(SwiftleadTokens.errorRed)),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Segment?'),
            content: Text('Are you sure you want to delete "${segment.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: const Color(SwiftleadTokens.errorRed)),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) {
        setState(() {
          _segments.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${segment.name} deleted')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: InkWell(
            onTap: () => _editSegment(segment),
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        segment.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created ${_formatDate(segment.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.6),
                  ),
                  child: Text(
                    '${segment.count}',
                    style: TextStyle(
                      color: const Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editSegment(segment),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  Future<void> _createSegment() async {
    final created = await Navigator.push<bool>(
      context,
      _createPageRoute(const SegmentBuilderScreen()),
    );
    
    if (created == true) {
      _loadSegments();
    }
  }

  Future<void> _editSegment(ContactSegment segment) async {
    final updated = await Navigator.push<bool>(
      context,
      _createPageRoute(SegmentBuilderScreen(segmentId: segment.id)),
    );
    
    if (updated == true) {
      _loadSegments();
    }
  }
}

class ContactSegment {
  final String id;
  final String name;
  final int count;
  final DateTime createdAt;

  ContactSegment({
    required this.id,
    required this.name,
    required this.count,
    required this.createdAt,
  });
}
