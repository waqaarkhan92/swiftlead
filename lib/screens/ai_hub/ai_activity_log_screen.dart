import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/search_bar.dart';
import '../../theme/tokens.dart';

/// AI Activity Log Screen - View all AI interactions
/// Exact specification from UI_Inventory_v2.5.1
class AIActivityLogScreen extends StatefulWidget {
  const AIActivityLogScreen({super.key});

  @override
  State<AIActivityLogScreen> createState() => _AIActivityLogScreenState();
}

class _AIActivityLogScreenState extends State<AIActivityLogScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'AI Activity Log',
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    final hasActivity = true; // Replace with actual data check

    if (!hasActivity) {
      return EmptyStateCard(
        title: 'No AI activity yet',
        description: 'AI interactions will appear here once AI starts responding to messages.',
        icon: Icons.auto_awesome_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // SearchBar
          SwiftleadSearchBar(
            hintText: 'Search AI activity...',
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Activity List
          ...List.generate(10, (index) => Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: _ActivityCard(
              interactionType: _getInteractionType(index),
              summary: _getSummary(index),
              outcome: _getOutcome(index),
              timestamp: DateTime.now().subtract(Duration(hours: index)),
              confidence: 70 + (index * 3) % 30,
            ),
          )),
        ],
      ),
    );
  }

  String _getInteractionType(int index) {
    final types = ['Auto-Reply', 'Booking Offer', 'Quote Generation', 'Smart Reply'];
    return types[index % types.length];
  }

  String _getSummary(int index) {
    final summaries = [
      'Responded to inquiry about business hours',
      'Offered booking slot for tomorrow 2pm',
      'Generated quote for kitchen repair',
      'Suggested reply for pricing question',
    ];
    return summaries[index % summaries.length];
  }

  String _getOutcome(int index) {
    final outcomes = ['Successful', 'Booked', 'Quote Sent', 'Accepted'];
    return outcomes[index % outcomes.length];
  }
}

class _ActivityCard extends StatelessWidget {
  final String interactionType;
  final String summary;
  final String outcome;
  final DateTime timestamp;
  final int confidence;

  const _ActivityCard({
    required this.interactionType,
    required this.summary,
    required this.outcome,
    required this.timestamp,
    required this.confidence,
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

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return const Color(SwiftleadTokens.successGreen);
    if (confidence >= 60) return const Color(SwiftleadTokens.warningYellow);
    return const Color(SwiftleadTokens.errorRed);
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                        interactionType,
                        style: const TextStyle(
                          color: Color(SwiftleadTokens.primaryTeal),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(confidence),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatTime(timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  outcome,
                  style: const TextStyle(
                    color: Color(SwiftleadTokens.successGreen),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Confidence: $confidence%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

