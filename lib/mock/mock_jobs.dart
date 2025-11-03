import '../config/mock_config.dart';
import '../models/job.dart';
import '../models/job_timeline_event.dart';

/// Mock Jobs Repository
/// Provides realistic mock job data for Jobs screen preview
class MockJobs {
  static final List<Job> _jobs = [
    Job(
      id: '1',
      title: 'Boiler Repair',
      contactId: '1',
      contactName: 'John Smith',
      serviceType: 'Plumbing',
      description: 'Annual boiler service and repair. Customer reports strange noises.',
      status: JobStatus.scheduled,
      priority: JobPriority.high,
      value: 150.0,
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      address: '123 High Street, London SW1A 1AA',
      assignedTo: 'Alex',
    ),
    Job(
      id: '2',
      title: 'Bathroom Renovation',
      contactId: '2',
      contactName: 'Sarah Williams',
      serviceType: 'Renovation',
      description: 'Complete bathroom renovation including tiling, fixtures, and plumbing.',
      status: JobStatus.quoted,
      priority: JobPriority.medium,
      value: 3500.0,
      scheduledDate: DateTime.now().add(const Duration(days: 14)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      address: '456 Park Lane, London W1K 7AB',
      assignedTo: null,
    ),
    Job(
      id: '3',
      title: 'Emergency Leak Fix',
      contactId: '3',
      contactName: 'Mike Johnson',
      serviceType: 'Emergency',
      description: 'Urgent: Kitchen sink leaking. Customer needs immediate assistance.',
      status: JobStatus.inProgress,
      priority: JobPriority.urgent,
      value: 200.0,
      scheduledDate: DateTime.now(),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      address: '789 Victoria Road, London SE1 9SG',
      assignedTo: 'Alex',
    ),
    Job(
      id: '4',
      title: 'Heating System Installation',
      contactId: '5',
      contactName: 'David Brown',
      serviceType: 'Installation',
      description: 'New heating system installation for commercial property.',
      status: JobStatus.completed,
      priority: JobPriority.medium,
      value: 8500.0,
      scheduledDate: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      address: '321 Commercial Street, London E1 6LP',
      assignedTo: 'Alex',
    ),
    Job(
      id: '5',
      title: 'Radiator Replacement',
      contactId: '1',
      contactName: 'John Smith',
      serviceType: 'Maintenance',
      description: 'Replace 3 radiators in bedrooms.',
      status: JobStatus.scheduled,
      priority: JobPriority.low,
      value: 450.0,
      scheduledDate: DateTime.now().add(const Duration(days: 7)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      address: '123 High Street, London SW1A 1AA',
      assignedTo: 'Alex',
    ),
    Job(
      id: '6',
      title: 'Kitchen Sink Install',
      contactId: '4',
      contactName: 'Emily Chen',
      serviceType: 'Installation',
      description: 'Install new kitchen sink and taps.',
      status: JobStatus.quoted,
      priority: JobPriority.low,
      value: 280.0,
      scheduledDate: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      address: '654 Baker Street, London NW1 6XE',
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

  /// Get active jobs (scheduled or in progress)
  static Future<List<Job>> getActiveJobs() async {
    await simulateDelay();
    final results = _jobs.where((j) =>
        j.status == JobStatus.scheduled ||
        j.status == JobStatus.inProgress).toList();
    logMockOperation('Fetched active jobs: ${results.length} results');
    return results;
  }

  /// Get total value of jobs
  static Future<double> getTotalValue() async {
    await simulateDelay();
    final total = _jobs.fold<double>(0, (sum, job) => sum + job.value);
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
          .fold<double>(0, (sum, job) => sum + job.value);
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
      title: job.title,
      contactId: job.contactId,
      contactName: job.contactName,
      serviceType: job.serviceType,
      description: job.description,
      status: JobStatus.completed,
      priority: job.priority,
      value: job.value,
      scheduledDate: job.scheduledDate,
      createdAt: job.createdAt,
      completedAt: DateTime.now(),
      address: job.address,
      assignedTo: job.assignedTo,
    );
    logMockOperation('Job marked complete: ${job.title}');
    return true;
  }
}

/// Job model
class Job {
  final String id;
  final String title;
  final String contactId;
  final String contactName;
  final String serviceType;
  final String description;
  final JobStatus status;
  final JobPriority priority;
  final double value;
  final DateTime? scheduledDate;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String address;
  final String? assignedTo;

  Job({
    required this.id,
    required this.title,
    required this.contactId,
    required this.contactName,
    required this.serviceType,
    required this.description,
    required this.status,
    required this.priority,
    required this.value,
    this.scheduledDate,
    required this.createdAt,
    this.completedAt,
    required this.address,
    this.assignedTo,
  });
}

/// Job status
enum JobStatus {
  quoted,
  scheduled,
  inProgress,
  completed,
  cancelled,
}

extension JobStatusExtension on JobStatus {
  String get displayName {
    switch (this) {
      case JobStatus.quoted:
        return 'Quoted';
      case JobStatus.scheduled:
        return 'Scheduled';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Job priority
enum JobPriority {
  low,
  medium,
  high,
  urgent,
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
}
