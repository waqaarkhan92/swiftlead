import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/forms/ai_tone_selector_sheet.dart';
import '../../widgets/forms/business_hours_editor_sheet.dart';
import '../../widgets/forms/auto_reply_template_editor_sheet.dart';
import '../../widgets/forms/after_hours_response_editor_sheet.dart';
import '../../widgets/forms/booking_assistance_config_sheet.dart';
import '../../widgets/forms/lead_qualification_config_sheet.dart';
import '../../widgets/forms/smart_handover_config_sheet.dart';
import '../../widgets/forms/response_delay_config_sheet.dart';
import '../../widgets/forms/fallback_response_config_sheet.dart';
import '../../widgets/forms/multi_language_config_sheet.dart';
import '../../widgets/forms/confidence_threshold_config_sheet.dart';
import '../../widgets/forms/custom_response_override_sheet.dart';
import '../../widgets/forms/escalation_rules_config_sheet.dart';
import '../../widgets/components/ai_response_preview_sheet.dart';
import '../../theme/tokens.dart';

/// AIConfigurationScreen - Configure AI assistant settings
/// Exact specification from UI_Inventory_v2.5.1
class AIConfigurationScreen extends StatefulWidget {
  const AIConfigurationScreen({super.key});

  @override
  State<AIConfigurationScreen> createState() => _AIConfigurationScreenState();
}

class _AIConfigurationScreenState extends State<AIConfigurationScreen> {
  bool _aiEnabled = true;
  bool _autoReplyEnabled = false;
  bool _sentimentAnalysisEnabled = true;
  bool _smartSuggestionsEnabled = true;
  bool _bookingAssistanceEnabled = false;
  bool _leadQualificationEnabled = false;
  bool _smartHandoverEnabled = false;
  bool _contextRetentionEnabled = true;
  bool _twoWayConfirmationsEnabled = true;
  String _selectedTone = 'Professional';
  String _businessHours = 'Mon-Fri, 9:00-17:00';
  int _responseDelaySeconds = 0;
  double _confidenceThreshold = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'AI Configuration',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // AI Assistant Toggle
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Assistant',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Enable AI-powered features',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Switch(
                  value: _aiEnabled,
                  onChanged: (value) {
                    setState(() {
                      _aiEnabled = value;
                    });
                  },
                  activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          if (_aiEnabled) ...[
            // Auto-Reply
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-Reply',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Automatically respond to messages (Note: Backend verification needed once backend is wired)',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _autoReplyEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoReplyEnabled = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Smart Suggestions
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Suggestions',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'AI-powered reply suggestions',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _smartSuggestionsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _smartSuggestionsEnabled = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Sentiment Analysis
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sentiment Analysis',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Analyze customer sentiment',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _sentimentAnalysisEnabled,
                    onChanged: (value) {
                      setState(() {
                        _sentimentAnalysisEnabled = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Tone Selection
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communication Tone',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  InkWell(
                    onTap: () async {
                      final tone = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AIToneSelectorSheet(
                          selectedTone: _selectedTone,
                        ),
                      );
                      if (tone != null) {
                        setState(() {
                          _selectedTone = tone;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTone,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Business Hours
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Hours',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  InkWell(
                    onTap: () async {
                      final hours = await BusinessHoursEditorSheet.show(
                        context: context,
                        currentHours: _businessHours,
                      );
                      if (hours != null) {
                        setState(() {
                          _businessHours = hours;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _businessHours,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Auto-Reply Template Editor
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  final template = await AutoReplyTemplateEditorSheet.show(
                    context,
                  );
                  if (template != null) {
                    // Save template
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Auto-Reply Template',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Edit missed call text template',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // After-Hours Response Editor
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  final message = await AfterHoursResponseEditorSheet.show(
                    context,
                  );
                  if (message != null) {
                    // Save message
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'After-Hours Response',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Edit after-hours message',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Booking Assistance
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Assistance',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'AI offers available time slots automatically',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _bookingAssistanceEnabled,
                    onChanged: (value) {
                      setState(() {
                        _bookingAssistanceEnabled = value;
                      });
                      if (value) {
                        BookingAssistanceConfigSheet.show(
                          context: context,
                          initialEnabled: value,
                        );
                      }
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Lead Qualification
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead Qualification',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Collect info before handover',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _leadQualificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _leadQualificationEnabled = value;
                      });
                      LeadQualificationConfigSheet.show(
                        context: context,
                        initialEnabled: value,
                      );
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Smart Handover
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Handover',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Transfer with full context',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _smartHandoverEnabled,
                    onChanged: (value) {
                      setState(() {
                        _smartHandoverEnabled = value;
                      });
                      SmartHandoverConfigSheet.show(
                        context: context,
                        initialEnabled: value,
                      );
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Response Delay
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  final delay = await ResponseDelayConfigSheet.show(
                    context: context,
                    initialDelaySeconds: _responseDelaySeconds,
                  );
                  if (delay != null) {
                    setState(() {
                      _responseDelaySeconds = delay;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Response Delay',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _responseDelaySeconds == 0 
                              ? 'Instant'
                              : _responseDelaySeconds < 60
                                  ? '${_responseDelaySeconds}s'
                                  : '${_responseDelaySeconds ~/ 60}m',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Confidence Threshold
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  final threshold = await ConfidenceThresholdConfigSheet.show(
                    context: context,
                    initialThreshold: _confidenceThreshold,
                  );
                  if (threshold != null) {
                    setState(() {
                      _confidenceThreshold = threshold;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confidence Threshold',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(_confidenceThreshold * 100).toStringAsFixed(0)}% minimum',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Fallback Response
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  await FallbackResponseConfigSheet.show(context: context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fallback Response',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'When AI is uncertain',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Multi-Language Support
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  await MultiLanguageConfigSheet.show(context: context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supported Languages',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Detect and respond in client language',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Custom Response Override
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  await CustomResponseOverrideSheet.show(context: context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Custom Response Override',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Set responses for keywords',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Escalation Rules
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () async {
                  await EscalationRulesConfigSheet.show(context: context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escalation Rules',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Configure handover triggers',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Two-Way Confirmations
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Two-Way Confirmations',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Handle YES/NO responses automatically',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _twoWayConfirmationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _twoWayConfirmationsEnabled = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Context Retention
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Context Retention',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'AI remembers previous conversations',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _contextRetentionEnabled,
                    onChanged: (value) {
                      setState(() {
                        _contextRetentionEnabled = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // AI Response Preview
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: InkWell(
                onTap: () {
                  AIResponsePreviewSheet.show(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Response Preview',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Test AI responses',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            PrimaryButton(
              label: 'Save Configuration',
              onPressed: () {
                // TODO: Save AI configuration
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
