import '../config/mock_config.dart';

/// Service model
class Service {
  final String id;
  final String name;
  final String category;
  final int duration; // in minutes
  final double? price;
  final String? description;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    this.price,
    this.description,
  });
}

/// Mock Services Repository
class MockServices {
  static final List<Service> _services = [
    Service(
      id: '1',
      name: 'Kitchen Sink Repair',
      category: 'Repairs',
      duration: 60,
      price: 150.0,
      description: 'Full repair service for kitchen sink issues',
    ),
    Service(
      id: '2',
      name: 'Bathroom Installation',
      category: 'Installation',
      duration: 240,
      price: 500.0,
      description: 'Complete bathroom installation service',
    ),
    Service(
      id: '3',
      name: 'Heating System Check',
      category: 'Maintenance',
      duration: 90,
      price: 100.0,
      description: 'Annual heating system maintenance check',
    ),
    Service(
      id: '4',
      name: 'Electrical Consultation',
      category: 'Consultation',
      duration: 30,
      price: 50.0,
      description: 'Professional electrical consultation',
    ),
    Service(
      id: '5',
      name: 'Boiler Repair',
      category: 'Repairs',
      duration: 120,
      price: 200.0,
      description: 'Boiler repair and maintenance',
    ),
    Service(
      id: '6',
      name: 'Plumbing Installation',
      category: 'Installation',
      duration: 180,
      price: 300.0,
      description: 'Complete plumbing installation',
    ),
  ];

  /// Fetch all services
  static Future<List<Service>> fetchAll() async {
    await simulateDelay();
    logMockOperation('Fetched ${_services.length} services');
    return List.from(_services);
  }

  /// Fetch services by category
  static Future<List<Service>> fetchByCategory(String category) async {
    await simulateDelay();
    final results = _services.where((s) => s.category == category).toList();
    logMockOperation('Fetched ${results.length} services for category: $category');
    return results;
  }

  /// Fetch service by ID
  static Future<Service?> fetchById(String id) async {
    await simulateDelay();
    final service = _services.where((s) => s.id == id).firstOrNull;
    logMockOperation('Fetched service: ${service?.name ?? "Not found"}');
    return service;
  }

  /// Get all categories
  static Future<List<String>> getCategories() async {
    await simulateDelay();
    final categories = _services.map((s) => s.category).toSet().toList();
    return categories;
  }
}

