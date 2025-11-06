import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import '../../utils/profession_config.dart';

/// Profession Configuration Screen
/// Decision Matrix: Module 3.13 - Batch 7: KEEP ALL
/// Allows users to configure profession-specific settings
class ProfessionConfigurationScreen extends StatefulWidget {
  const ProfessionConfigurationScreen({super.key});

  @override
  State<ProfessionConfigurationScreen> createState() => _ProfessionConfigurationScreenState();
}

class _ProfessionConfigurationScreenState extends State<ProfessionConfigurationScreen> {
  ProfessionType _selectedProfession = ProfessionState.currentProfession;
  
  @override
  Widget build(BuildContext context) {
    final config = ProfessionConfig.getProfessionConfig(_selectedProfession);
    
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Profession Configuration'),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Profession Selection
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Profession',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ...ProfessionType.values.map((profession) {
                  final isSelected = profession == _selectedProfession;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: RadioListTile<ProfessionType>(
                      title: Text(_getProfessionLabel(profession)),
                      value: profession,
                      groupValue: _selectedProfession,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedProfession = value;
                          });
                        }
                      },
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Adaptive Terminology
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adaptive Terminology',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Labels will be automatically adjusted based on your profession.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                if (config.labelOverrides.isNotEmpty) ...[
                  ...config.labelOverrides.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          Text(
                            entry.value,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(SwiftleadTokens.primaryTeal),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ] else ...[
                  Text(
                    'No label overrides for this profession',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Module Visibility
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visible Modules',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Modules that will be visible in navigation for this profession.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ...['home', 'inbox', 'jobs', 'calendar', 'money'].map((module) {
                  final isVisible = config.isModuleVisible(module);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          module.substring(0, 1).toUpperCase() + module.substring(1),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Switch(
                          value: isVisible,
                          onChanged: null, // Read-only for now
                          activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Workflow Defaults
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workflow Defaults',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Default settings for this profession.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ...ProfessionConfig.getWorkflowDefaults(_selectedProfession).entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.replaceAll(RegExp(r'([A-Z])'), r' $1').trim(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          entry.value.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(SwiftleadTokens.primaryTeal),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Save Button
          PrimaryButton(
            label: 'Apply Profession Settings',
            onPressed: () {
              ProfessionState.setProfession(_selectedProfession);
              Toast.show(
                context,
                message: 'Profession settings applied. Please restart the app for changes to take effect.',
                type: ToastType.success,
              );
              Navigator.pop(context);
            },
            icon: Icons.check,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Note about backend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceS),
            child: Text(
              'Note: Backend verification needed once backend is wired. Profession settings will be synced with backend.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getProfessionLabel(ProfessionType profession) {
    switch (profession) {
      case ProfessionType.trade:
        return 'Trade (Plumber, Electrician, HVAC, etc.)';
      case ProfessionType.homeServices:
        return 'Home Services (Cleaner, Pest Control, etc.)';
      case ProfessionType.professionalServices:
        return 'Professional Services (Salon, Clinic, Consultant)';
      case ProfessionType.autoServices:
        return 'Auto Services (Mobile Mechanic, Detailer, etc.)';
      case ProfessionType.custom:
        return 'Custom';
    }
  }
}

