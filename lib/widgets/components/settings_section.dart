import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// SettingsSection - Grouped settings with header, dividers, and item rows
/// Exact specification from UI_Inventory_v2.5.1
class SettingsSection extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;
  final Widget? trailing;

  const SettingsSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

