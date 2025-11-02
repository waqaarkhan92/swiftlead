import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/info_banner.dart';
import '../../theme/tokens.dart';

/// Contact Import Wizard - Multi-step import process
/// Exact specification from UI_Inventory_v2.5.1
class ContactImportWizardScreen extends StatefulWidget {
  const ContactImportWizardScreen({super.key});

  @override
  State<ContactImportWizardScreen> createState() => _ContactImportWizardScreenState();
}

class _ContactImportWizardScreenState extends State<ContactImportWizardScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Import Contacts',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Step Indicator
          _buildStepIndicator(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Step Content
          _buildStepContent(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : null,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStepLabel(index),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (index < _totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < _currentStep
                          ? const Color(SwiftleadTokens.primaryTeal)
                          : Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.1)
                              : Colors.white.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0: return 'Upload';
      case 1: return 'Map Fields';
      case 2: return 'Review';
      case 3: return 'Import';
      default: return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildUploadStep();
      case 1:
        return _buildMappingStep();
      case 2:
        return _buildReviewStep();
      case 3:
        return _buildImportStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUploadStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Contact File',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          InfoBanner(
            message: 'Supported formats: CSV, Excel, vCard. Maximum file size: 10MB.',
            type: InfoBannerType.info,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // File Upload Zone
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(SwiftleadTokens.primaryTeal),
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Drag and drop your file here',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'or',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                OutlinedButton.icon(
                  onPressed: () {
                    // File picker
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Browse Files'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMappingStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Map Fields',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          InfoBanner(
            message: 'Match your file columns to Swiftlead contact fields.',
            type: InfoBannerType.info,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Field Mapper would go here
          Text(
            'Source Column → Target Field\n\nName → Name\nEmail → Email\nPhone → Phone',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Import',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Contacts',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '125',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valid Contacts',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '120',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(SwiftleadTokens.successGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Errors',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '5',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(SwiftleadTokens.errorRed),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportStep() {
    if (_isProcessing) {
      return FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'Importing contacts...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import Complete',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          InfoBanner(
            message: '120 contacts imported successfully.',
            type: InfoBannerType.success,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: const Text('Previous'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: SwiftleadTokens.spaceS),
        Expanded(
          child: PrimaryButton(
            label: _currentStep == _totalSteps - 1
                ? (_isProcessing ? 'Importing...' : 'Complete')
                : 'Next',
            onPressed: _isProcessing
                ? null
                : () {
                    if (_currentStep < _totalSteps - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      setState(() {
                        _isProcessing = true;
                      });
                      // Simulate import
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  },
            icon: _currentStep == _totalSteps - 1 ? Icons.check : Icons.arrow_forward,
          ),
        ),
      ],
    );
  }
}

