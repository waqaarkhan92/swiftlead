import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/chip.dart';
import '../global/haptic_feedback.dart' as app_haptics;

/// ActiveFilterChip - Displays a single active filter with remove option
class ActiveFilterChip extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onRemove;
  
  const ActiveFilterChip({
    super.key,
    required this.label,
    this.value,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(SwiftleadTokens.primaryTeal),
            Color(SwiftleadTokens.accentAqua),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value != null ? '$label: $value' : label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Semantics(
            label: 'Remove $label filter',
            button: true,
            child: GestureDetector(
              onTap: () {
                app_haptics.HapticFeedback.light();
                onRemove();
              },
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ActiveFilterChipsRow - Displays all active filters as removable chips
class ActiveFilterChipsRow extends StatelessWidget {
  final List<ActiveFilter> filters;
  final VoidCallback? onClearAll;
  
  const ActiveFilterChipsRow({
    super.key,
    required this.filters,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...filters.map((filter) => Padding(
                    padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                    child: ActiveFilterChip(
                      label: filter.label,
                      value: filter.value,
                      onRemove: filter.onRemove,
                    ),
                  )),
                ],
              ),
            ),
          ),
          if (onClearAll != null && filters.length > 1)
            Padding(
              padding: const EdgeInsets.only(left: SwiftleadTokens.spaceS),
              child: TextButton(
                onPressed: () {
                  app_haptics.HapticFeedback.light();
                  onClearAll?.call();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear all',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(SwiftleadTokens.primaryTeal),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ActiveFilter - Model for an active filter
class ActiveFilter {
  final String label;
  final String? value;
  final VoidCallback onRemove;

  ActiveFilter({
    required this.label,
    this.value,
    required this.onRemove,
  });
}

