import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart' as swiftlead_badge;

/// InternalNotesButton - Floating button for team notes
/// Exact specification from Screen_Layouts_v2.5.1
class InternalNotesButton extends StatelessWidget {
  final int? noteCount;
  final VoidCallback onTap;
  
  const InternalNotesButton({
    super.key,
    this.noteCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: const Color(SwiftleadTokens.primaryTeal),
      heroTag: 'internal_notes',
      child: noteCount != null && noteCount! > 0
          ? swiftlead_badge.Badge.count(
              count: noteCount!,
              child: const Icon(
                Icons.note_add,
                color: Colors.white,
              ),
            )
          : const Icon(
              Icons.note_add,
              color: Colors.white,
            ),
    );
  }
}

