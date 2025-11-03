import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';

/// App Preferences Screen - Full preferences configuration
/// Exact specification from UI_Inventory_v2.5.1
class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'GBP';
  String _selectedDateFormat = 'DD/MM/YYYY';
  String _selectedTimeFormat = '24-hour';
  bool _darkModeEnabled = false;
  bool _animationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _soundEffectsEnabled = false;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Italian'];
  final List<String> _currencies = ['GBP', 'USD', 'EUR', 'CAD'];
  final List<String> _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
  final List<String> _timeFormats = ['24-hour', '12-hour'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'App Preferences',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Language & Region
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language & Region',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _PreferenceRow(
                  label: 'Language',
                  value: _selectedLanguage,
                  options: _languages,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  },
                ),
                const Divider(),
                _PreferenceRow(
                  label: 'Currency',
                  value: _getCurrencyDisplay(_selectedCurrency),
                  options: _currencies.map((c) => _getCurrencyDisplay(c)).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = _getCurrencyCode(value);
                    });
                  },
                ),
                const Divider(),
                _PreferenceRow(
                  label: 'Date Format',
                  value: _selectedDateFormat,
                  options: _dateFormats,
                  onChanged: (value) {
                    setState(() {
                      _selectedDateFormat = value;
                    });
                  },
                ),
                const Divider(),
                _PreferenceRow(
                  label: 'Time Format',
                  value: _selectedTimeFormat,
                  options: _timeFormats,
                  onChanged: (value) {
                    setState(() {
                      _selectedTimeFormat = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Appearance
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Interaction Preferences
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interaction',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Animations',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _animationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _animationsEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Haptic Feedback',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _hapticFeedbackEnabled,
                      onChanged: (value) {
                        setState(() {
                          _hapticFeedbackEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sound Effects',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _soundEffectsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEffectsEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencyDisplay(String code) {
    switch (code) {
      case 'GBP':
        return 'GBP (£)';
      case 'USD':
        return 'USD (\$)';
      case 'EUR':
        return 'EUR (€)';
      case 'CAD':
        return 'CAD (\$)';
      default:
        return code;
    }
  }

  String _getCurrencyCode(String display) {
    if (display.startsWith('GBP')) return 'GBP';
    if (display.startsWith('USD')) return 'USD';
    if (display.startsWith('EUR')) return 'EUR';
    if (display.startsWith('CAD')) return 'CAD';
    return display;
  }
}

class _PreferenceRow extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  const _PreferenceRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              value: value,
              items: options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

