import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/info_banner.dart';
import '../global/primary_button.dart';
import '../global/skeleton_loader.dart';
import '../global/error_state_card.dart';

/// AI Summary Card - AI-generated conversation summary
/// Exact specification from UI_Inventory_v2.5.1
class AISummaryCard extends StatefulWidget {
  final String threadId;
  final Function()? onGenerate;
  final Function()? onRefresh;

  const AISummaryCard({
    super.key,
    required this.threadId,
    this.onGenerate,
    this.onRefresh,
  });

  @override
  State<AISummaryCard> createState() => _AISummaryCardState();
}

enum SummaryState { idle, loading, loaded, error }

class _AISummaryCardState extends State<AISummaryCard> {
  SummaryState _state = SummaryState.idle;
  String? _summary;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateSummary();
  }

  Future<void> _generateSummary() async {
    setState(() {
      _state = SummaryState.loading;
      _error = null;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Replace with actual API call
      // final summary = await aiService.summarizeThread(widget.threadId);
      
      if (mounted) {
        setState(() {
          _state = SummaryState.loaded;
          _summary = '''
**Key Points:**
• Client inquired about kitchen sink repair availability
• Requested scheduling for afternoon
• Discussed pricing and service details
• Agreed on service date and time

**Next Actions:**
• Send confirmation message
• Prepare quote if needed
• Schedule appointment in calendar
          ''';
        });
        widget.onGenerate?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = SummaryState.error;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      margin: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  'AI Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_state == SummaryState.loaded)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: () {
                    _generateSummary();
                    widget.onRefresh?.call();
                  },
                  tooltip: 'Refresh summary',
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Content based on state
          switch (_state) {
            SummaryState.loading => _buildLoadingState(),
            SummaryState.loaded => _buildSummaryContent(),
            SummaryState.error => _buildErrorState(),
            SummaryState.idle => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Text(
              'Generating summary...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        SkeletonLoader(
          width: double.infinity,
          height: 60,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildSummaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_summary != null)
          Text(
            _summary!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        InfoBanner(
          message: 'This summary is generated by AI and may not be complete.',
          type: InfoBannerType.info,
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return ErrorStateCard(
      title: 'Summary failed',
      description: _error ?? 'Unable to generate summary. Please try again.',
      icon: Icons.error_outline,
      actionLabel: 'Retry',
      onAction: _generateSummary,
    );
  }
}

