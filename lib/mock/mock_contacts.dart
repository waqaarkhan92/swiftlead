import '../config/mock_config.dart';
import '../models/contact.dart';

/// Mock Contacts Repository
/// Provides realistic mock contact data for preview mode
class MockContacts {
  // Track blocked contact IDs
  static final Set<String> _blockedContactIds = {};
  
  static final List<Contact> _contacts = [
    Contact(
      id: '1',
      orgId: 'org_1',
      firstName: 'John',
      lastName: 'Smith',
      email: 'john.smith@example.com',
      phone: '+44 7700 900123',
      address: '123 High Street, London SW1A 1AA',
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
      orgId: 'org_1',
      firstName: 'Sarah',
      lastName: 'Williams',
      email: 'sarah.williams@example.com',
      phone: '+44 7700 900456',
      address: '456 Park Lane, London W1K 7AB',
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
      orgId: 'org_1',
      firstName: 'Mike',
      lastName: 'Johnson',
      email: 'mike.j@example.com',
      phone: '+44 7700 900789',
      address: '789 Victoria Road, London SE1 9SG',
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
      orgId: 'org_1',
      firstName: 'Emily',
      lastName: 'Chen',
      email: 'emily.chen@example.com',
      phone: '+44 7700 900321',
      address: '654 Baker Street, London NW1 6XE',
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
      orgId: 'org_1',
      firstName: 'David',
      lastName: 'Brown',
      email: 'david.brown@example.com',
      phone: '+44 7700 900654',
      address: '321 Commercial Street, London E1 6LP',
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
    final queryLower = query.toLowerCase();
    final results = _contacts.where((c) =>
        c.name.toLowerCase().contains(queryLower) ||
        c.firstName.toLowerCase().contains(queryLower) ||
        c.lastName.toLowerCase().contains(queryLower) ||
        (c.email?.toLowerCase().contains(queryLower) ?? false) ||
        (c.phone?.contains(query) ?? false) ||
        (c.company?.toLowerCase().contains(queryLower) ?? false)).toList();
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

  /// Block contact (prevent messages and hide threads)
  static Future<bool> blockContact(String contactId) async {
    await simulateDelay();
    final contact = _contacts.where((c) => c.id == contactId).firstOrNull;
    if (contact != null) {
      _blockedContactIds.add(contactId);
      logMockOperation('Blocked contact: ${contact.name}');
      // In real implementation, this would update the database
      return true;
    }
    return false;
  }

  /// Unblock contact
  static Future<bool> unblockContact(String contactId) async {
    await simulateDelay();
    final contact = _contacts.where((c) => c.id == contactId).firstOrNull;
    if (contact != null) {
      _blockedContactIds.remove(contactId);
      logMockOperation('Unblocked contact: ${contact.name}');
      return true;
    }
    return false;
  }

  /// Check if contact is blocked
  static bool isContactBlocked(String contactId) {
    return _blockedContactIds.contains(contactId);
  }

  /// Update contact stage
  static Future<bool> updateContactStage(String contactId, ContactStage newStage, {bool autoProgression = false, String? reason}) async {
    await simulateDelay();
    final contactIndex = _contacts.indexWhere((c) => c.id == contactId);
    if (contactIndex >= 0) {
      final contact = _contacts[contactIndex];
      final oldStage = contact.stage;
      _contacts[contactIndex] = Contact(
        id: contact.id,
        orgId: contact.orgId,
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        phone: contact.phone,
        address: contact.address,
        company: contact.company,
        avatarUrl: contact.avatarUrl,
        stage: newStage,
        score: contact.score,
        source: contact.source,
        tags: contact.tags,
        createdAt: contact.createdAt,
        lastContactedAt: contact.lastContactedAt,
      );
      logMockOperation('Updated contact stage: ${contact.name} -> ${newStage.displayName}${autoProgression ? " (auto-progression)" : ""}');
      
      // Notify about stage change (this would trigger real notifications in production)
      if (oldStage != newStage) {
        _onStageChanged(contactId, contact.name, oldStage, newStage, autoProgression, reason);
      }
      
      return true;
    }
    return false;
  }

  /// Auto-progression logic
  /// Lead → Prospect when quote sent
  static Future<bool> checkAndProceedQuoteSent(String contactId) async {
    final contact = await fetchById(contactId);
    if (contact == null) return false;
    
    if (contact.stage == ContactStage.lead) {
      return await updateContactStage(
        contactId,
        ContactStage.prospect,
        autoProgression: true,
        reason: 'Quote sent',
      );
    }
    return false;
  }

  /// Prospect → Customer when payment received
  static Future<bool> checkAndProceedPaymentReceived(String contactId) async {
    final contact = await fetchById(contactId);
    if (contact == null) return false;
    
    if (contact.stage == ContactStage.prospect) {
      return await updateContactStage(
        contactId,
        ContactStage.customer,
        autoProgression: true,
        reason: 'Payment received',
      );
    }
    return false;
  }

  /// Customer → Repeat Customer when 2nd job completed
  static Future<bool> checkAndProceedSecondJobCompleted(String contactId) async {
    final contact = await fetchById(contactId);
    if (contact == null) return false;
    
    if (contact.stage == ContactStage.customer) {
      // In real implementation, would check job count from database
      // For mock, we'll check if contact has completed jobs
      // This is a simplified check - in production, query completed jobs count
      return await updateContactStage(
        contactId,
        ContactStage.repeatCustomer,
        autoProgression: true,
        reason: 'Second job completed',
      );
    }
    return false;
  }

  /// Internal callback for stage changes (triggers notifications)
  static void _onStageChanged(
    String contactId,
    String contactName,
    ContactStage oldStage,
    ContactStage newStage,
    bool autoProgression,
    String? reason,
  ) {
    // This would trigger real notifications in production
    // For now, we'll just log it - the UI will show notifications via Toast
    final progressionType = autoProgression ? 'Automatic' : 'Manual';
    final reasonText = reason != null ? ' ($reason)' : '';
    logMockOperation('Stage change notification: $contactName $progressionType progression from ${oldStage.displayName} to ${newStage.displayName}$reasonText');
  }

  /// Get completion count for a contact (for auto-progression check)
  static Future<int> getCompletedJobCount(String contactId) async {
    await simulateDelay();
    // In real implementation, this would query the jobs table
    // For mock, return a count based on contact ID
    // Contact '1' (John Smith) has 1+ completed job, so qualifies for repeat customer
    if (contactId == '1') return 2;
    if (contactId == '4') return 1;
    return 0;
  }
}

/// Contact model - Matches backend `contacts` table schema
class Contact {
  // Primary keys
  final String id;
  final String? orgId; // Required for backend RLS - nullable for backward compatibility
  
  // Core fields
  final String firstName; // Backend: first_name
  final String lastName; // Backend: last_name
  final String? email;
  final String? phone;
  final String? address; // Backend: address
  final String? company;
  final ContactStage stage;
  final List<String> tags; // Backend: tags (text[])
  final Map<String, dynamic>? customFields; // Backend: custom_fields (jsonb nullable)
  
  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt; // Backend: updated_at
  
  // Denormalized/calculated fields (for UI convenience, not in backend)
  final String? avatarUrl; // May be in separate table or storage
  final int score; // Calculated field
  final String? source; // May be in message_threads.lead_source
  final DateTime? lastContactedAt; // Calculated field
  
  // Backward compatibility: computed property
  String get name => '$firstName $lastName'.trim();

  Contact({
    required this.id,
    this.orgId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.address,
    this.company,
    required this.stage,
    this.tags = const [],
    this.customFields,
    required this.createdAt,
    this.updatedAt,
    // Denormalized/backward compatibility
    this.avatarUrl,
    this.score = 0,
    this.source,
    this.lastContactedAt,
  });
  
  /// Create from backend JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      orgId: json['org_id'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      company: json['company'] as String?,
      stage: ContactStageExtension.fromBackend(json['stage'] as String),
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      customFields: json['custom_fields'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  
  /// Convert to backend JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_id': orgId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'company': company,
      'stage': stage.name,
      'tags': tags,
      'custom_fields': customFields,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
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
  
  /// Create from backend enum string
  static ContactStage fromBackend(String value) {
    switch (value) {
      case 'lead':
        return ContactStage.lead;
      case 'prospect':
        return ContactStage.prospect;
      case 'customer':
        return ContactStage.customer;
      case 'repeat_customer':
        return ContactStage.repeatCustomer;
      case 'advocate':
        return ContactStage.advocate;
      case 'inactive':
        return ContactStage.inactive;
      default:
        return ContactStage.lead;
    }
  }
}
