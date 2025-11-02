import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// CallTranscriptRow - Expandable row with call duration, transcription, and AI summary
/// Exact specification from UI_Inventory_v2.5.1
class CallTranscriptRow extends StatefulWidget {
  final String callId;
  final String phoneNumber;
  final Duration duration;
  final DateTime timestamp;
  final String? transcript;
  final String? aiSummary;
  final bool isTranscribing;
  final VoidCallback? onTap;

  const CallTranscriptRow({
    super.key,
    required this.callId,
    required this.phoneNumber,
    required this.duration,
    required this.timestamp,
    this.transcript,
    this.aiSummary,
    this.isTranscribing = false,
    this.onTap,
  });

  @override
  State<CallTranscriptRow> createState() => _CallTranscriptRowState();
}

class _CallTranscriptRowState extends State<CallTranscriptRow> {
  bool _isExpanded = false;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

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
    return GestureDetector(
      onTap: widget.onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Color(SwiftleadTokens.primaryTeal),
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            widget.phoneNumber,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _formatDuration(widget.duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            '•',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            _formatTime(widget.timestamp),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            
            // Expanded Content
            if (_isExpanded) ...[
              const Divider(),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              if (widget.isTranscribing)
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      'Transcribing...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              else ...[
                if (widget.transcript != null) ...[
                  Text(
                    'Transcript:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Text(
                    widget.transcript!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (widget.aiSummary != null) ...[
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Color(SwiftleadTokens.primaryTeal),
                            ),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Text(
                              'AI Summary',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(SwiftleadTokens.primaryTeal),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceS),
                        Text(
                          widget.aiSummary!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }
}

