import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../models/job_template.dart';
import '../../mock/mock_job_templates.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../config/mock_config.dart';

/// JobTemplateSelectorSheet - Bottom sheet for selecting a job template
/// Exact specification from UI_Inventory_v2.5.1
class JobTemplateSelectorSheet {
  static Future<JobTemplate?> show({
    required BuildContext context,
  }) async {
    return await showModalBottomSheet<JobTemplate?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _JobTemplateSelectorSheetContent(),
    );
  }
}

class _JobTemplateSelectorSheetContent extends StatefulWidget {
  const _JobTemplateSelectorSheetContent();

  @override
  State<_JobTemplateSelectorSheetContent> createState() => _JobTemplateSelectorSheetContentState();
}

class _JobTemplateSelectorSheetContentState extends State<_JobTemplateSelectorSheetContent> {
  bool _isLoading = true;
  List<JobTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });

    if (kUseMockData) {
      _templates = await MockJobTemplates.fetchAll();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwiftleadBottomSheet(
      title: 'Select Job Template',
      height: SheetHeight.half,
      child: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: SkeletonLoader(
            width: double.infinity,
            height: 80,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_templates.isEmpty) {
      return EmptyStateCard(
        title: 'No templates available',
        description: 'Job templates will appear here when created.',
        icon: Icons.description_outlined,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ..._templates.map((template) => _buildTemplateCard(template)),
      ],
    );
  }

  Widget _buildTemplateCard(JobTemplate template) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: InkWell(
        onTap: () {
          MockJobTemplates.incrementUsage(template.id);
          Navigator.pop(context, template);
        },
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (template.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          template.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (template.usageCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${template.usageCount}×',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (template.estimatedHours != null || template.estimatedCost != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Row(
                children: [
                  if (template.estimatedHours != null) ...[
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${template.estimatedHours}h',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (template.estimatedHours != null && template.estimatedCost != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  if (template.estimatedCost != null) ...[
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '£${template.estimatedCost?.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

