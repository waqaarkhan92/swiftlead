import '../config/mock_config.dart';

/// Job Status Enum - Matches backend `jobs.status` enum
enum JobStatus {
  proposed,    // Was: quoted
  booked,      // Was: scheduled
  onTheWay,
  inProgress,
  completed,
  cancelled,
}

extension JobStatusExtension on JobStatus {
  String get displayName {
    switch (this) {
      case JobStatus.proposed:
        return 'Proposed';
      case JobStatus.booked:
        return 'Booked';
      case JobStatus.onTheWay:
        return 'On The Way';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get backendValue {
    switch (this) {
      case JobStatus.proposed:
        return 'proposed';
      case JobStatus.booked:
        return 'booked';
      case JobStatus.onTheWay:
        return 'on_the_way';
      case JobStatus.inProgress:
        return 'in_progress';
      case JobStatus.completed:
        return 'completed';
      case JobStatus.cancelled:
        return 'cancelled';
    }
  }

  static JobStatus fromBackend(String value) {
    switch (value) {
      case 'proposed':
        return JobStatus.proposed;
      case 'booked':
        return JobStatus.booked;
      case 'on_the_way':
        return JobStatus.onTheWay;
      case 'in_progress':
        return JobStatus.inProgress;
      case 'completed':
        return JobStatus.completed;
      case 'cancelled':
        return JobStatus.cancelled;
      default:
        return JobStatus.proposed;
    }
  }
}

/// Job Priority Enum - Matches backend `jobs.priority` enum
enum JobPriority {
  low,
  medium,
  high,
  urgent, // Maps to 'high' in backend
}

extension JobPriorityExtension on JobPriority {
  String get displayName {
    switch (this) {
      case JobPriority.low:
        return 'Low';
      case JobPriority.medium:
        return 'Medium';
      case JobPriority.high:
        return 'High';
      case JobPriority.urgent:
        return 'Urgent';
    }
  }

  String get backendValue {
    switch (this) {
      case JobPriority.low:
        return 'low';
      case JobPriority.medium:
        return 'medium';
      case JobPriority.high:
        return 'high';
      case JobPriority.urgent:
        return 'high'; // Maps urgent to high for backend
    }
  }

  static JobPriority fromBackend(String value) {
    switch (value) {
      case 'low':
        return JobPriority.low;
      case 'medium':
        return JobPriority.medium;
      case 'high':
        return JobPriority.high;
      default:
        return JobPriority.medium;
    }
  }
}

/// Mock Jobs Repository
/// Provides realistic mock job data for Jobs screen preview
class MockJobs {
  static final List<Job> _jobs = [
    Job(
      id: '1',
      orgId: 'org_1',
      title: 'Boiler Repair',
      contactId: '1',
      contactName: 'John Smith',
      jobType: 'repair',
      serviceType: 'Plumbing', // Deprecated, kept for backward compatibility
      description: 'Annual boiler service and repair. Customer reports strange noises.',
      status: JobStatus.booked, // Was: scheduled
      priority: JobPriority.high,
      priceEstimate: 150.0,
      startTime: DateTime.now().add(const Duration(days: 1)),
      endTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      location: '123 High Street, London SW1A 1AA',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedTo: 'Alex',
    ),
    Job(
      id: '2',
      orgId: 'org_1',
      title: 'Bathroom Renovation',
      contactId: '2',
      contactName: 'Sarah Williams',
      jobType: 'service',
      serviceType: 'Renovation', // Deprecated
      description: 'Complete bathroom renovation including tiling, fixtures, and plumbing.',
      status: JobStatus.proposed, // Was: quoted
      priority: JobPriority.medium,
      priceEstimate: 3500.0,
      startTime: DateTime.now().add(const Duration(days: 14)),
      endTime: DateTime.now().add(const Duration(days: 14, hours: 8)),
      location: '456 Park Lane, London W1K 7AB',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      assignedTo: null,
    ),
    Job(
      id: '3',
      orgId: 'org_1',
      title: 'Emergency Leak Fix',
      contactId: '3',
      contactName: 'Mike Johnson',
      jobType: 'repair',
      serviceType: 'Emergency', // Deprecated
      description: 'Urgent: Kitchen sink leaking. Customer needs immediate assistance.',
      status: JobStatus.inProgress,
      priority: JobPriority.urgent, // Maps to 'high' in backend
      priceEstimate: 200.0,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      location: '789 Victoria Road, London SE1 9SG',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      assignedTo: 'Alex',
    ),
    Job(
      id: '4',
      orgId: 'org_1',
      title: 'Heating System Installation',
      contactId: '5',
      contactName: 'David Brown',
      jobType: 'installation',
      serviceType: 'Installation', // Deprecated
      description: 'New heating system installation for commercial property.',
      status: JobStatus.completed,
      priority: JobPriority.medium,
      priceEstimate: 8500.0,
      startTime: DateTime.now().subtract(const Duration(days: 5)),
      endTime: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      location: '321 Commercial Street, London E1 6LP',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedTo: 'Alex',
    ),
    Job(
      id: '5',
      orgId: 'org_1',
      title: 'Radiator Replacement',
      contactId: '1',
      contactName: 'John Smith',
      jobType: 'service',
      serviceType: 'Maintenance', // Deprecated
      description: 'Replace 3 radiators in bedrooms.',
      status: JobStatus.booked, // Was: scheduled
      priority: JobPriority.low,
      priceEstimate: 450.0,
      startTime: DateTime.now().add(const Duration(days: 7)),
      endTime: DateTime.now().add(const Duration(days: 7, hours: 4)),
      location: '123 High Street, London SW1A 1AA',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      assignedTo: 'Alex',
    ),
    Job(
      id: '6',
      orgId: 'org_1',
      title: 'Kitchen Sink Install',
      contactId: '4',
      contactName: 'Emily Chen',
      jobType: 'installation',
      serviceType: 'Installation', // Deprecated
      description: 'Install new kitchen sink and taps.',
      status: JobStatus.proposed, // Was: quoted
      priority: JobPriority.low,
      priceEstimate: 280.0,
      startTime: null,
      endTime: null,
      location: '654 Baker Street, London NW1 6XE',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      assignedTo: null,
    ),
  ];

  /// Fetch all jobs
  static Future<List<Job>> fetchAll() async {
    await simulateDelay();
    logMockOperation('Fetched ${_jobs.length} jobs');
    return List.from(_jobs);
  }

  /// Fetch job by ID
  static Future<Job?> fetchById(String id) async {
    await simulateDelay();
    final job = _jobs.where((j) => j.id == id).firstOrNull;
    logMockOperation('Fetched job: ${job?.title ?? "Not found"}');
    return job;
  }

  /// Filter jobs by status
  static Future<List<Job>> filterByStatus(JobStatus status) async {
    await simulateDelay();
    final results = _jobs.where((j) => j.status == status).toList();
    logMockOperation('Filtered jobs by status ${status.name}: ${results.length} results');
    return results;
  }

  /// Get job count by status
  static Future<Map<JobStatus, int>> getCountByStatus() async {
    await simulateDelay();
    final counts = <JobStatus, int>{};
    for (final status in JobStatus.values) {
      counts[status] = _jobs.where((j) => j.status == status).length;
    }
    logMockOperation('Job count by status: $counts');
    return counts;
  }

  /// Get active jobs (booked or in progress)
  static Future<List<Job>> getActiveJobs() async {
    await simulateDelay();
    final results = _jobs.where((j) =>
        j.status == JobStatus.booked ||
        j.status == JobStatus.inProgress).toList();
    logMockOperation('Fetched active jobs: ${results.length} results');
    return results;
  }

  /// Get total value of jobs
  static Future<double> getTotalValue() async {
    await simulateDelay();
    final total = _jobs.fold<double>(0, (sum, job) => sum + (job.priceEstimate ?? 0.0));
    logMockOperation('Total job value: £$total');
    return total;
  }

  /// Get total value by status
  static Future<Map<JobStatus, double>> getValueByStatus() async {
    await simulateDelay();
    final values = <JobStatus, double>{};
    for (final status in JobStatus.values) {
      values[status] = _jobs
          .where((j) => j.status == status)
          .fold<double>(0, (sum, job) => sum + (job.priceEstimate ?? 0.0));
    }
    logMockOperation('Job value by status: $values');
    return values;
  }

  /// Mark job as complete
  static Future<bool> markJobComplete(String jobId) async {
    await simulateDelay();
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) {
      logMockOperation('Job not found: $jobId');
      return false;
    }
    final job = _jobs[index];
    _jobs[index] = Job(
      id: job.id,
      orgId: job.orgId,
      title: job.title,
      contactId: job.contactId,
      contactName: job.contactName,
      jobType: job.jobType,
      serviceType: job.serviceType,
      description: job.description,
      status: JobStatus.completed,
      priority: job.priority,
      priceEstimate: job.priceEstimate,
      startTime: job.startTime,
      endTime: job.endTime,
      location: job.location,
      createdAt: job.createdAt,
      completedAt: DateTime.now(),
      assignedTo: job.assignedTo,
    );
    logMockOperation('Job marked complete: ${job.title}');
    return true;
  }
}

/// Job model - Matches backend `jobs` table schema
class Job {
  // Primary keys
  final String id;
  final String? orgId; // Required for backend RLS - nullable for backward compatibility
  
  // Foreign keys
  final String contactId;
  final String? assignedTo; // FK users
  final String? quoteId; // FK nullable
  final String? invoiceId; // FK nullable
  final String? templateId; // FK job_templates nullable
  
  // Core fields
  final String title;
  final String description;
  final String jobType; // Backend: job_type (enum: inspection/service/repair/installation/other)
  final JobStatus status;
  final JobPriority priority;
  
  // Scheduling
  final DateTime? startTime; // Backend: start_time (was scheduledDate)
  final DateTime? endTime; // Backend: end_time (required for scheduling)
  
  // Location
  final String? location; // Backend: location (was address)
  
  // Financial
  final double? priceEstimate; // Backend: price_estimate (was value)
  final bool depositRequired;
  final double? depositAmount;
  final double? estimatedHours;
  final double? actualHours;
  final double? estimatedCost;
  final double? actualCost;
  
  // Additional fields
  final String? notes;
  final bool reviewSent;
  final String? aiSummary;
  final Map<String, dynamic>? customFields; // Backend: custom_fields (jsonb)
  final String? duplicateOf; // FK jobs nullable
  final String? sharedLinkToken; // text unique nullable
  final List<String>? linkedJobs; // uuid[]
  
  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt; // Not in backend, but useful for UI
  
  // Denormalized fields (for UI convenience, not in backend)
  final String? contactName; // Can be joined from contacts table
  final String? serviceType; // Deprecated - use jobType instead
  
  // Backward compatibility: computed properties
  String get address => location ?? '';
  DateTime? get scheduledDate => startTime;
  double get value => priceEstimate ?? 0.0;

  Job({
    required this.id,
    this.orgId,
    required this.contactId,
    this.assignedTo,
    this.quoteId,
    this.invoiceId,
    this.templateId,
    required this.title,
    required this.description,
    required this.jobType,
    required this.status,
    required this.priority,
    this.startTime,
    this.endTime,
    this.location,
    this.priceEstimate,
    this.depositRequired = false,
    this.depositAmount,
    this.estimatedHours,
    this.actualHours,
    this.estimatedCost,
    this.actualCost,
    this.notes,
    this.reviewSent = false,
    this.aiSummary,
    this.customFields,
    this.duplicateOf,
    this.sharedLinkToken,
    this.linkedJobs,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    // Denormalized/backward compatibility
    this.contactName,
    this.serviceType,
  });
  
  /// Create from backend JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      orgId: json['org_id'] as String?,
      contactId: json['contact_id'] as String,
      assignedTo: json['assigned_to'] as String?,
      quoteId: json['quote_id'] as String?,
      invoiceId: json['invoice_id'] as String?,
      templateId: json['template_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      jobType: json['job_type'] as String,
      status: JobStatusExtension.fromBackend(json['status'] as String),
      priority: JobPriorityExtension.fromBackend(json['priority'] as String? ?? 'medium'),
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time'] as String) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
      location: json['location'] as String?,
      priceEstimate: (json['price_estimate'] as num?)?.toDouble(),
      depositRequired: json['deposit_required'] as bool? ?? false,
      depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
      estimatedHours: (json['estimated_hours'] as num?)?.toDouble(),
      actualHours: (json['actual_hours'] as num?)?.toDouble(),
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble(),
      actualCost: (json['actual_cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      reviewSent: json['review_sent'] as bool? ?? false,
      aiSummary: json['ai_summary'] as String?,
      customFields: json['custom_fields'] as Map<String, dynamic>?,
      duplicateOf: json['duplicate_of'] as String?,
      sharedLinkToken: json['shared_link_token'] as String?,
      linkedJobs: (json['linked_jobs'] as List?)?.cast<String>(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  
  /// Convert to backend JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'contact_id': contactId,
      'assigned_to': assignedTo,
      'quote_id': quoteId,
      'invoice_id': invoiceId,
      'template_id': templateId,
      'title': title,
      'description': description,
      'job_type': jobType,
      'status': status.backendValue,
      'priority': priority.backendValue,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'location': location,
      'price_estimate': priceEstimate,
      'deposit_required': depositRequired,
      'deposit_amount': depositAmount,
      'estimated_hours': estimatedHours,
      'actual_hours': actualHours,
      'estimated_cost': estimatedCost,
      'actual_cost': actualCost,
      'notes': notes,
      'review_sent': reviewSent,
      'ai_summary': aiSummary,
      'custom_fields': customFields,
      'duplicate_of': duplicateOf,
      'shared_link_token': sharedLinkToken,
      'linked_jobs': linkedJobs,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
