import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// Data Export Screen - GDPR-compliant full export
/// Exact specification from UI_Inventory_v2.5.1
class DataExportScreen extends StatefulWidget {
  const DataExportScreen({super.key});

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  final Set<String> _selectedDataTypes = {};
  String _selectedFormat = 'JSON';
  bool _isExporting = false;

  final List<String> _availableFormats = ['JSON', 'CSV', 'PDF'];
  
  final Map<String, String> _dataTypes = {
    'contacts': 'Contacts & CRM Data',
    'jobs': 'Jobs & Work Orders',
    'invoices': 'Invoices & Payments',
    'messages': 'Messages & Conversations',
    'bookings': 'Calendar & Bookings',
    'quotes': 'Quotes & Estimates',
    'reviews': 'Reviews & Feedback',
    'settings': 'Settings & Preferences',
    'analytics': 'Analytics & Reports',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Data Export',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Info Card
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(SwiftleadTokens.primaryTeal),
                      size: 24,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      'GDPR Data Export',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Request a complete export of all your data. This includes all information associated with your account in compliance with GDPR regulations.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Your export will be prepared and sent to your registered email address within 24 hours.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Data Type Selection
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Data to Export',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Select all data types you want to include in your export',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ..._dataTypes.entries.map((entry) {
                  final key = entry.key;
                  final label = entry.value;
                  final isSelected = _selectedDataTypes.contains(key);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: CheckboxListTile(
                      title: Text(label),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedDataTypes.add(key);
                          } else {
                            _selectedDataTypes.remove(key);
                          }
                        });
                      },
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  );
                }),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDataTypes.clear();
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDataTypes.addAll(_dataTypes.keys);
                        });
                      },
                      child: const Text('Select All'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Format Selection
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Format',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  runSpacing: SwiftleadTokens.spaceS,
                  children: _availableFormats.map((format) {
                    final isSelected = _selectedFormat == format;
                    return SwiftleadChip(
                      label: format,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFormat = format;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Export Button
          PrimaryButton(
            label: _isExporting ? 'Preparing Export...' : 'Request Data Export',
            onPressed: _selectedDataTypes.isEmpty || _isExporting ? null : _requestExport,
            icon: Icons.download,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Previous Exports
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Previous Exports',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'No previous exports',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestExport() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Request Data Export',
      description: 'Your export will be prepared and sent to your registered email address within 24 hours. Continue?',
      primaryActionLabel: 'Request Export',
      secondaryActionLabel: 'Cancel',
      icon: Icons.download,
    );

    if (confirmed != true) return;

    setState(() {
      _isExporting = true;
    });

    // Simulate export request
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isExporting = false;
      });
      
      Toast.show(
        context,
        message: 'Export request submitted. You will receive an email when it\'s ready.',
        type: ToastType.success,
      );
    }
  }
}

