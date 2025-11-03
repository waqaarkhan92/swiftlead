import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/forms/ai_tone_selector_sheet.dart';
import '../../widgets/forms/business_hours_editor_sheet.dart';
import '../../widgets/forms/auto_reply_template_editor_sheet.dart';
import '../../widgets/forms/after_hours_response_editor_sheet.dart';
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
  String _selectedTone = 'Professional';
  String _businessHours = 'Mon-Fri, 9:00-17:00';

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
                        'Automatically respond to messages',
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
