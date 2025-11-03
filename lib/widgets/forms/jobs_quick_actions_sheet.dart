import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/primary_button.dart';

/// JobsQuickActionsSheet - Quick action menu for creating jobs, bookings, etc.
/// Exact specification from UI_Inventory_v2.5.1
class JobsQuickActionsSheet {
  static Future<String?> show({
    required BuildContext context,
  }) async {
    return await SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Quick Actions',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          _ActionTile(
            icon: Icons.work_outline,
            title: 'Create Job',
            description: 'Add a new job',
            onTap: () => Navigator.pop(context, 'create_job'),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Icon(
          icon,
          color: const Color(SwiftleadTokens.primaryTeal),
        ),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

