import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../../models/message.dart';

/// MessageActionsSheet - Actions menu for individual messages
/// Exact specification from UI_Inventory_v2.5.1
class MessageActionsSheet {
  static Future<String?> show({
    required BuildContext context,
    required String messageId,
    required MessageChannel channel,
    bool canEdit = false,
    bool canDelete = false,
  }) async {
    return await SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Message Actions',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          _ActionTile(
            icon: Icons.copy_outlined,
            title: 'Copy Text',
            onTap: () => Navigator.pop(context, 'copy'),
          ),
          _ActionTile(
            icon: Icons.share_outlined,
            title: 'Share',
            onTap: () => Navigator.pop(context, 'share'),
          ),
          _ActionTile(
            icon: Icons.forward_outlined,
            title: 'Forward',
            onTap: () => Navigator.pop(context, 'forward'),
          ),
          if (canEdit) ...[
            const Divider(),
            _ActionTile(
              icon: Icons.edit_outlined,
              title: 'Edit',
              onTap: () => Navigator.pop(context, 'edit'),
            ),
          ],
          const Divider(),
          _ActionTile(
            icon: Icons.info_outline,
            title: 'View Details',
            onTap: () => Navigator.pop(context, 'details'),
          ),
          _ActionTile(
            icon: Icons.star_outline,
            title: 'Star',
            onTap: () => Navigator.pop(context, 'star'),
          ),
          if (canDelete) ...[
            const Divider(),
            _ActionTile(
              icon: Icons.delete_outline,
              title: 'Delete',
              onTap: () => Navigator.pop(context, 'delete'),
              color: const Color(SwiftleadTokens.errorRed),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}

