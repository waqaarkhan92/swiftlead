import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/components/campaign_type_selector.dart';
import '../../widgets/components/audience_selector.dart';
import '../../theme/tokens.dart';

/// Campaign Builder Screen - Multi-step campaign creation wizard
/// Exact specification from UI_Inventory_v2.5.1
class CampaignBuilderScreen extends StatefulWidget {
  final String? campaignId; // If provided, editing mode

  const CampaignBuilderScreen({
    super.key,
    this.campaignId,
  });

  @override
  State<CampaignBuilderScreen> createState() => _CampaignBuilderScreenState();
}

class _CampaignBuilderScreenState extends State<CampaignBuilderScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  String? _selectedCampaignType;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.campaignId != null ? 'Edit Campaign' : 'Create Campaign',
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
      case 0: return 'Type';
      case 1: return 'Content';
      case 2: return 'Audience';
      case 3: return 'Schedule';
      default: return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildTypeStep();
      case 1:
        return _buildContentStep();
      case 2:
        return _buildAudienceStep();
      case 3:
        return _buildScheduleStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTypeStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Campaign Type',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          CampaignTypeSelector(
            selectedType: _selectedCampaignType,
            onTypeSelected: (type) {
              setState(() {
                _selectedCampaignType = type;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compose Message',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            maxLines: 10,
            decoration: InputDecoration(
              labelText: 'Email Content',
              hintText: 'Enter your campaign message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Email Composer with rich text editor, templates, and merge fields would go here',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Audience',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          AudienceSelector(
            segments: [
              AudienceSegment(
                id: 'segment_1',
                name: 'Hot Leads',
                contactCount: 45,
                description: 'High-scoring contacts',
              ),
              AudienceSegment(
                id: 'segment_2',
                name: 'Repeat Customers',
                contactCount: 120,
                description: 'Customers with 2+ jobs',
              ),
              AudienceSegment(
                id: 'segment_3',
                name: 'New Contacts',
                contactCount: 30,
                description: 'Added in last 30 days',
              ),
            ],
            onSelectionChanged: (selectedIds) {
              // Handle audience selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleStep() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Campaign',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Date picker
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Select Date'),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Time picker
                  },
                  icon: const Icon(Icons.access_time),
                  label: const Text('Select Time'),
                ),
              ),
            ],
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
          child: _isSaving
              ? const SwiftleadProgressBar()
              : PrimaryButton(
                  label: _currentStep == _totalSteps - 1
                      ? 'Create Campaign'
                      : 'Next',
                  onPressed: () {
                    if (_currentStep < _totalSteps - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      setState(() {
                        _isSaving = true;
                      });
                      // Simulate save
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          Navigator.of(context).pop();
                          // Show success toast
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

