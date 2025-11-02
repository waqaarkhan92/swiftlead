import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// PreferenceGrid - Type × Channel grid of toggles
/// Exact specification from UI_Inventory_v2.5.1
class PreferenceGrid extends StatelessWidget {
  final Map<String, Map<String, bool>> preferences;
  final Function(String notificationType, String channel, bool value)? onToggle;

  const PreferenceGrid({
    super.key,
    required this.preferences,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Preferences',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Grid Header
          Row(
            children: [
              const SizedBox(width: 120), // Space for type labels
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Push', 'Email', 'SMS'].map((channel) {
                    return Text(
                      channel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const Divider(),
          
          // Preference Rows
          ...preferences.entries.map((entry) {
            final type = entry.key;
            final channels = entry.value;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      type,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Push', 'Email', 'SMS'].map((channel) {
                        final isEnabled = channels[channel] ?? false;
                        return Switch(
                          value: isEnabled,
                          onChanged: (value) {
                            onToggle?.call(type, channel, value);
                          },
                          activeColor: const Color(SwiftleadTokens.primaryTeal),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

