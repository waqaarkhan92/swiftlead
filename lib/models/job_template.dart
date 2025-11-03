/// JobTemplate - Reusable job configuration
class JobTemplate {
  final String id;
  final String name;
  final String? description;
  final String? jobType;
  final String? defaultTitle;
  final String? defaultDescription;
  final double? estimatedHours;
  final double? estimatedCost;
  final Map<String, dynamic>? customFieldsSchema;
  final int usageCount;
  final bool isActive;

  JobTemplate({
    required this.id,
    required this.name,
    this.description,
    this.jobType,
    this.defaultTitle,
    this.defaultDescription,
    this.estimatedHours,
    this.estimatedCost,
    this.customFieldsSchema,
    this.usageCount = 0,
    this.isActive = true,
  });
}

