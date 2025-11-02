import '../config/mock_config.dart';
import '../models/contact.dart';

/// Mock Contacts Repository
/// Provides realistic mock contact data for preview mode
class MockContacts {
  static final List<Contact> _contacts = [
    Contact(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@example.com',
      phone: '+44 7700 900123',
      company: 'Smith & Sons Ltd',
      avatarUrl: null,
      stage: ContactStage.customer,
      score: 85,
      source: 'Google Ads',
      tags: ['VIP', 'Repeat Customer'],
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastContactedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Contact(
      id: '2',
      name: 'Sarah Williams',
      email: 'sarah.williams@example.com',
      phone: '+44 7700 900456',
      company: null,
      avatarUrl: null,
      stage: ContactStage.prospect,
      score: 72,
      source: 'Facebook',
      tags: ['New Lead'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastContactedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Contact(
      id: '3',
      name: 'Mike Johnson',
      email: 'mike.j@example.com',
      phone: '+44 7700 900789',
      company: 'Johnson Properties',
      avatarUrl: null,
      stage: ContactStage.customer,
      score: 90,
      source: 'Referral',
      tags: ['VIP', 'Commercial'],
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastContactedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Contact(
      id: '4',
      name: 'Emily Chen',
      email: 'emily.chen@example.com',
      phone: '+44 7700 900321',
      company: null,
      avatarUrl: null,
      stage: ContactStage.lead,
      score: 45,
      source: 'Website',
      tags: ['New Lead'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastContactedAt: DateTime.now().subtract(const Duration(hours: 24)),
    ),
    Contact(
      id: '5',
      name: 'David Brown',
      email: 'david.brown@example.com',
      phone: '+44 7700 900654',
      company: 'Brown Construction',
      avatarUrl: null,
      stage: ContactStage.repeatCustomer,
      score: 95,
      source: 'Referral',
      tags: ['VIP', 'Repeat Customer', 'Commercial'],
      createdAt: DateTime.now().subtract(const Duration(days: 730)),
      lastContactedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  /// Fetch all contacts
  static Future<List<Contact>> fetchAll() async {
    await simulateDelay();
    logMockOperation('Fetched ${_contacts.length} contacts');
    return List.from(_contacts);
  }

  /// Fetch contact by ID
  static Future<Contact?> fetchById(String id) async {
    await simulateDelay();
    final contact = _contacts.where((c) => c.id == id).firstOrNull;
    logMockOperation('Fetched contact: ${contact?.name ?? "Not found"}');
    return contact;
  }

  /// Search contacts
  static Future<List<Contact>> search(String query) async {
    await simulateDelay();
    final results = _contacts.where((c) =>
        c.name.toLowerCase().contains(query.toLowerCase()) ||
        (c.email?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (c.phone?.contains(query) ?? false) ||
        (c.company?.toLowerCase().contains(query.toLowerCase()) ?? false)).toList();
    logMockOperation('Searched contacts for "$query": ${results.length} results');
    return results;
  }

  /// Filter contacts by stage
  static Future<List<Contact>> filterByStage(ContactStage stage) async {
    await simulateDelay();
    final results = _contacts.where((c) => c.stage == stage).toList();
    logMockOperation('Filtered contacts by stage ${stage.name}: ${results.length} results');
    return results;
  }

  /// Get contact count by stage
  static Future<Map<ContactStage, int>> getCountByStage() async {
    await simulateDelay();
    final counts = <ContactStage, int>{};
    for (final stage in ContactStage.values) {
      counts[stage] = _contacts.where((c) => c.stage == stage).length;
    }
    logMockOperation('Contact count by stage: $counts');
    return counts;
  }
}

/// Contact model
class Contact {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? company;
  final String? avatarUrl;
  final ContactStage stage;
  final int score;
  final String? source;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? lastContactedAt;

  Contact({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.company,
    this.avatarUrl,
    required this.stage,
    required this.score,
    this.source,
    this.tags = const [],
    required this.createdAt,
    this.lastContactedAt,
  });
}

/// Contact lifecycle stages
enum ContactStage {
  lead,
  prospect,
  customer,
  repeatCustomer,
  advocate,
  inactive,
}

extension ContactStageExtension on ContactStage {
  String get displayName {
    switch (this) {
      case ContactStage.lead:
        return 'Lead';
      case ContactStage.prospect:
        return 'Prospect';
      case ContactStage.customer:
        return 'Customer';
      case ContactStage.repeatCustomer:
        return 'Repeat Customer';
      case ContactStage.advocate:
        return 'Advocate';
      case ContactStage.inactive:
        return 'Inactive';
    }
  }
}
