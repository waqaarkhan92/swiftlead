import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';

/// Contact Export Builder - Configure and generate contact exports
/// Exact specification from UI_Inventory_v2.5.1
class ContactExportBuilderScreen extends StatefulWidget {
  const ContactExportBuilderScreen({super.key});

  @override
  State<ContactExportBuilderScreen> createState() => _ContactExportBuilderScreenState();
}

class _ContactExportBuilderScreenState extends State<ContactExportBuilderScreen> {
  String _selectedFormat = 'CSV';
  final List<String> _selectedFields = ['Name', 'Email', 'Phone'];
  bool _includeCustomFields = false;
  bool _isExporting = false;
  final List<String> _availableFields = [
    'Name',
    'Email',
    'Phone',
    'Address',
    'Company',
    'Tags',
    'Stage',
    'Score',
    'Created Date',
    'Last Contact',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Export Contacts',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isExporting
          ? _buildExportingState()
          : ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: [
                // Format Selector
                _buildFormatSelector(),
                const SizedBox(height: SwiftleadTokens.spaceL),
                
                // Field Selector
                _buildFieldSelector(),
                const SizedBox(height: SwiftleadTokens.spaceL),
                
                // Options
                _buildOptions(),
                const SizedBox(height: SwiftleadTokens.spaceL),
                
                // Export Button
                PrimaryButton(
                  label: 'Generate Export',
                  onPressed: () {
                    setState(() {
                      _isExporting = true;
                    });
                    // Simulate export
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        _showExportCompleteSheet(context);
                      }
                    });
                  },
                  icon: Icons.download,
                ),
              ],
            ),
    );
  }

  Widget _buildExportingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Preparing export...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'This may take a moment',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSelector() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Format',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            children: ['CSV', 'Excel', 'vCard'].map((format) {
              return SwiftleadChip(
                label: format,
                isSelected: _selectedFormat == format,
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
    );
  }

  Widget _buildFieldSelector() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Fields',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Choose which fields to include in the export',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceS,
            children: _availableFields.map((field) {
              final isSelected = _selectedFields.contains(field);
              return SwiftleadChip(
                label: field,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedFields.remove(field);
                    } else {
                      _selectedFields.add(field);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Options',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          SwitchListTile(
            title: const Text('Include Custom Fields'),
            value: _includeCustomFields,
            onChanged: (value) {
              setState(() {
                _includeCustomFields = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showExportCompleteSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Export Ready',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Color(SwiftleadTokens.successGreen),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Your export is ready!',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            '${_selectedFields.length} fields exported in $_selectedFormat format',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Download File',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Download file
            },
            icon: Icons.download,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              // Email export
            },
            child: const Text('Email Export'),
          ),
        ],
      ),
    );
  }
}

