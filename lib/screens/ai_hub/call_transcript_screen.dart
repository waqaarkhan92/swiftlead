import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

/// CallTranscriptScreen - View AI call transcripts
/// Exact specification from UI_Inventory_v2.5.1
class CallTranscriptScreen extends StatefulWidget {
  const CallTranscriptScreen({super.key});

  @override
  State<CallTranscriptScreen> createState() => _CallTranscriptScreenState();
}

class _CallTranscriptScreenState extends State<CallTranscriptScreen> {
  bool _isLoading = false;
  List<_CallTranscript> _transcripts = [];

  @override
  void initState() {
    super.initState();
    _loadTranscripts();
  }

  Future<void> _loadTranscripts() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _transcripts = [
        _CallTranscript(
          id: '1',
          contactName: 'John Smith',
          phoneNumber: '+44 20 1234 5678',
          duration: const Duration(minutes: 5, seconds: 32),
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          summary: 'Customer called about boiler repair. Scheduled for next week.',
          sentiment: 'Neutral',
          transcript: '''[AI]: Hello, this is Swiftlead Plumbing. How can I help you today?

[Customer]: Hi, my boiler is making strange noises and I'm worried it might break down.

[AI]: I understand that's concerning. Can you describe the type of noise you're hearing?

[Customer]: It's like a banging sound, especially in the morning when it starts up.

[AI]: That sounds like it could be a kettling issue. Would you like me to schedule a technician to come take a look?

[Customer]: Yes, please. When would be the earliest?

[AI]: I can schedule someone for next Tuesday at 2 PM. Would that work for you?

[Customer]: Perfect, thank you!''',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Call Transcripts',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transcripts.isEmpty
              ? const EmptyStateCard(
                  title: 'No Call Transcripts',
                  description: 'AI call transcripts will appear here when calls are processed.',
                  icon: Icons.phone_in_talk,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  itemCount: _transcripts.length,
                  itemBuilder: (context, index) {
                    final transcript = _transcripts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                      child: _TranscriptCard(transcript: transcript),
                    );
                  },
                ),
    );
  }
}

class _CallTranscript {
  final String id;
  final String contactName;
  final String phoneNumber;
  final Duration duration;
  final DateTime timestamp;
  final String summary;
  final String sentiment;
  final String transcript;

  _CallTranscript({
    required this.id,
    required this.contactName,
    required this.phoneNumber,
    required this.duration,
    required this.timestamp,
    required this.summary,
    required this.sentiment,
    required this.transcript,
  });
}

class _TranscriptCard extends StatelessWidget {
  final _CallTranscript transcript;

  const _TranscriptCard({required this.transcript});

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transcript.contactName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      transcript.phoneNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transcript.duration.inMinutes}m ${transcript.duration.inSeconds % 60}s',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _formatTimestamp(transcript.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            transcript.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Text(
              transcript.transcript,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

