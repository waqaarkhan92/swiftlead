import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';

/// AIConfigurationScreen - Configure AI receptionist settings
/// Exact specification from UI_Inventory_v2.5.1
class AIConfigurationScreen extends StatefulWidget {
  const AIConfigurationScreen({super.key});

  @override
  State<AIConfigurationScreen> createState() => _AIConfigurationScreenState();
}

class _AIConfigurationScreenState extends State<AIConfigurationScreen> {
  bool _aiEnabled = true;
  String _tone = 'Friendly';
  bool _afterHoursEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'AI Configuration',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Receptionist',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                SwitchListTile(
                  title: const Text('Enable AI Receptionist'),
                  subtitle: const Text('Automatically respond to messages'),
                  value: _aiEnabled,
                  onChanged: (value) {
                    setState(() {
                      _aiEnabled = value;
                    });
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('After Hours Responses'),
                  subtitle: const Text('Respond automatically outside business hours'),
                  value: _afterHoursEnabled,
                  onChanged: (value) {
                    setState(() {
                      _afterHoursEnabled = value;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Response Tone'),
                  subtitle: Text(_tone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open tone selector sheet
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

