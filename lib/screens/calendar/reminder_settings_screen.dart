import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../../widgets/global/chip.dart';

/// ReminderSettingsScreen - Configure booking reminders
/// Exact specification from UI_Inventory_v2.5.1
class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  bool _remindersEnabled = true;
  bool _clientRemindersEnabled = true;
  bool _teamRemindersEnabled = true;
  
  // Client reminder times
  List<int> _clientReminderTimes = [24, 2]; // 24h and 2h before
  // Team reminder times
  List<int> _teamReminderTimes = [24, 2, 15]; // 24h, 2h, and 15min before

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Reminder Settings',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Global Toggle
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable Reminders',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Send automatic reminders for bookings',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Switch(
                  value: _remindersEnabled,
                  onChanged: (value) {
                    setState(() {
                      _remindersEnabled = value;
                    });
                  },
                  activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          if (_remindersEnabled) ...[
            // Client Reminders
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Client Reminders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Switch(
                        value: _clientRemindersEnabled,
                        onChanged: (value) {
                          setState(() {
                            _clientRemindersEnabled = value;
                          });
                        },
                        activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ],
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  if (_clientRemindersEnabled) ...[
                    Text(
                      'Send reminders to clients',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Wrap(
                      spacing: SwiftleadTokens.spaceS,
                      runSpacing: SwiftleadTokens.spaceS,
                      children: [
                        _ReminderChip(
                          label: '24 hours',
                          isSelected: _clientReminderTimes.contains(24),
                          onTap: () {
                            setState(() {
                              if (_clientReminderTimes.contains(24)) {
                                _clientReminderTimes.remove(24);
                              } else {
                                _clientReminderTimes.add(24);
                              }
                            });
                          },
                        ),
                        _ReminderChip(
                          label: '2 hours',
                          isSelected: _clientReminderTimes.contains(2),
                          onTap: () {
                            setState(() {
                              if (_clientReminderTimes.contains(2)) {
                                _clientReminderTimes.remove(2);
                              } else {
                                _clientReminderTimes.add(2);
                              }
                            });
                          },
                        ),
                        _ReminderChip(
                          label: '30 minutes',
                          isSelected: _clientReminderTimes.contains(30),
                          onTap: () {
                            setState(() {
                              if (_clientReminderTimes.contains(30)) {
                                _clientReminderTimes.remove(30);
                              } else {
                                _clientReminderTimes.add(30);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Team Reminders
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Team Reminders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Switch(
                        value: _teamRemindersEnabled,
                        onChanged: (value) {
                          setState(() {
                            _teamRemindersEnabled = value;
                          });
                        },
                        activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ],
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  if (_teamRemindersEnabled) ...[
                    Text(
                      'Send reminders to team members',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Wrap(
                      spacing: SwiftleadTokens.spaceS,
                      runSpacing: SwiftleadTokens.spaceS,
                      children: [
                        _ReminderChip(
                          label: '24 hours',
                          isSelected: _teamReminderTimes.contains(24),
                          onTap: () {
                            setState(() {
                              if (_teamReminderTimes.contains(24)) {
                                _teamReminderTimes.remove(24);
                              } else {
                                _teamReminderTimes.add(24);
                              }
                            });
                          },
                        ),
                        _ReminderChip(
                          label: '2 hours',
                          isSelected: _teamReminderTimes.contains(2),
                          onTap: () {
                            setState(() {
                              if (_teamReminderTimes.contains(2)) {
                                _teamReminderTimes.remove(2);
                              } else {
                                _teamReminderTimes.add(2);
                              }
                            });
                          },
                        ),
                        _ReminderChip(
                          label: '15 minutes',
                          isSelected: _teamReminderTimes.contains(15),
                          onTap: () {
                            setState(() {
                              if (_teamReminderTimes.contains(15)) {
                                _teamReminderTimes.remove(15);
                              } else {
                                _teamReminderTimes.add(15);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            PrimaryButton(
              label: 'Save Settings',
              onPressed: () {
                // TODO: Save reminder settings
                Navigator.pop(context);
              },
              icon: Icons.check,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReminderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReminderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
      checkmarkColor: const Color(SwiftleadTokens.primaryTeal),
    );
  }
}

