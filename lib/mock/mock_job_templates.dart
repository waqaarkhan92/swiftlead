import '../config/mock_config.dart';
import '../models/job_template.dart';

/// Mock Job Templates Repository
class MockJobTemplates {
  static final List<JobTemplate> _templates = [
    JobTemplate(
      id: '1',
      name: 'Emergency Repair',
      description: 'Urgent repair service with priority response',
      jobType: 'Repair',
      defaultTitle: 'Emergency Repair',
      defaultDescription: 'Urgent repair service required',
      estimatedHours: 2.0,
      estimatedCost: 150.0,
      usageCount: 15,
    ),
    JobTemplate(
      id: '2',
      name: 'Maintenance',
      description: 'Regular maintenance service',
      jobType: 'Maintenance',
      defaultTitle: 'Maintenance Service',
      defaultDescription: 'Regular maintenance check',
      estimatedHours: 1.5,
      estimatedCost: 100.0,
      usageCount: 8,
    ),
    JobTemplate(
      id: '3',
      name: 'Installation',
      description: 'New installation service',
      jobType: 'Installation',
      defaultTitle: 'Installation',
      defaultDescription: 'New installation work',
      estimatedHours: 3.0,
      estimatedCost: 250.0,
      usageCount: 12,
    ),
    JobTemplate(
      id: '4',
      name: 'Consultation',
      description: 'Professional consultation service',
      jobType: 'Consultation',
      defaultTitle: 'Consultation',
      defaultDescription: 'Professional consultation',
      estimatedHours: 0.5,
      estimatedCost: 50.0,
      usageCount: 5,
    ),
  ];

  /// Fetch all active templates
  static Future<List<JobTemplate>> fetchAll() async {
    await simulateDelay();
    logMockOperation('Fetched ${_templates.length} job templates');
    return List.from(_templates.where((t) => t.isActive));
  }

  /// Fetch template by ID
  static Future<JobTemplate?> fetchById(String id) async {
    await simulateDelay();
    final template = _templates.where((t) => t.id == id).firstOrNull;
    logMockOperation('Fetched template: ${template?.name ?? "Not found"}');
    return template;
  }

  /// Increment usage count
  static Future<void> incrementUsage(String templateId) async {
    await simulateDelay();
    final index = _templates.indexWhere((t) => t.id == templateId);
    if (index != -1) {
      final existing = _templates[index];
      _templates[index] = JobTemplate(
        id: existing.id,
        name: existing.name,
        description: existing.description,
        jobType: existing.jobType,
        defaultTitle: existing.defaultTitle,
        defaultDescription: existing.defaultDescription,
        estimatedHours: existing.estimatedHours,
        estimatedCost: existing.estimatedCost,
        customFieldsSchema: existing.customFieldsSchema,
        usageCount: existing.usageCount + 1,
        isActive: existing.isActive,
      );
      logMockOperation('Incremented usage for template: $templateId');
    }
  }
}

