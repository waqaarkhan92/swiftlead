import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// VoiceNotePlayer - Inline audio player with waveform visualization
/// Exact specification from UI_Inventory_v2.5.1
class VoiceNotePlayer extends StatefulWidget {
  final String url;
  final Duration? duration;
  final bool isOutbound;
  
  const VoiceNotePlayer({
    super.key,
    required this.url,
    this.duration,
    this.isOutbound = false,
  });

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  late AnimationController _waveformController;

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _waveformController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = widget.isOutbound
        ? Colors.white.withOpacity(0.2)
        : (brightness == Brightness.light
            ? Colors.black.withOpacity(0.08)
            : Colors.white.withOpacity(0.12));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.isOutbound
                    ? Colors.white.withOpacity(0.3)
                    : const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.isOutbound
                    ? Colors.white
                    : const Color(SwiftleadTokens.primaryTeal),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Waveform visualization
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform bars
                SizedBox(
                  height: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(20, (index) {
                      final height = (20 + (index % 5) * 4).toDouble();
                      return Expanded(
                        child: AnimatedBuilder(
                          animation: _waveformController,
                          builder: (context, child) {
                            final progress = (_waveformController.value * 2 + index / 20) % 1;
                            final barHeight = _isPlaying
                                ? height * (0.3 + (progress * 0.7))
                                : height * 0.3;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.5),
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: widget.isOutbound
                                    ? Colors.white.withOpacity(0.8)
                                    : const Color(SwiftleadTokens.primaryTeal),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 4),
                // Duration
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    color: widget.isOutbound
                        ? Colors.white.withOpacity(0.9)
                        : Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          
          // More options button
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 16,
              color: widget.isOutbound
                  ? Colors.white.withOpacity(0.7)
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.forward_outlined),
                          title: const Text('Forward'),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Implement forward functionality
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.save_outlined),
                          title: const Text('Save'),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Implement save functionality
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Implement delete functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

