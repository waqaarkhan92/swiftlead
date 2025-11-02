import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// SettingsRow - Individual setting with label, description, control (toggle, select, button)
/// Exact specification from UI_Inventory_v2.5.1
class SettingsRow extends StatelessWidget {
  final String label;
  final String? description;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsRow({
    super.key,
    required this.label,
    this.description,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leadingIcon != null
              ? Icon(
                  leadingIcon,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                )
              : null,
          title: Text(label),
          subtitle: description != null ? Text(description!) : null,
          trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

