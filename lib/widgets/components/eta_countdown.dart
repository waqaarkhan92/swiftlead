import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// ETACountdown - Live countdown timer showing estimated arrival
/// Exact specification from UI_Inventory_v2.5.1
class ETACountdown extends StatefulWidget {
  final DateTime arrivalTime;
  final Function()? onArrived;

  const ETACountdown({
    super.key,
    required this.arrivalTime,
    this.onArrived,
  });

  @override
  State<ETACountdown> createState() => _ETACountdownState();
}

class _ETACountdownState extends State<ETACountdown> {
  Timer? _timer;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final diff = widget.arrivalTime.difference(now);
    
    if (diff.isNegative) {
      setState(() {
        _remaining = Duration.zero;
      });
    } else {
      setState(() {
        _remaining = diff;
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == null) {
      return const SizedBox.shrink();
    }

    final isArrived = _remaining!.inSeconds <= 0;

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isArrived
                  ? const Color(SwiftleadTokens.successGreen).withOpacity(0.1)
                  : const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isArrived ? Icons.check_circle : Icons.access_time,
              color: isArrived
                  ? const Color(SwiftleadTokens.successGreen)
                  : const Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArrived ? 'Arrived' : 'ETA',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isArrived
                      ? 'You have arrived at the location'
                      : _formatDuration(_remaining!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (isArrived && widget.onArrived != null)
            PrimaryButton(
              label: 'Mark Arrived',
              onPressed: widget.onArrived,
              size: ButtonSize.small,
            ),
        ],
      ),
    );
  }
}

