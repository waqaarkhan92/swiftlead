import '../config/mock_config.dart';
import '../models/payment.dart';

/// Mock Payments & Invoices Repository
/// Provides realistic mock financial data for Money screen preview
class MockPayments {
  static final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-001',
      orgId: 'org_1',
      contactId: '3',
      contactName: 'Mike Johnson',
      invoiceNumber: 'INV-001',
      amount: 200.0,
      taxRate: 20.0,
      status: InvoiceStatus.paid,
      dueDate: DateTime.now().subtract(const Duration(days: 5)),
      paidDate: DateTime.now().subtract(const Duration(days: 3)),
      serviceDescription: 'Emergency Leak Repair',
      items: [
        InvoiceItem(
          description: 'Emergency call-out',
          quantity: 1,
          unitPrice: 80.0,
        ),
        InvoiceItem(
          description: 'Leak repair (2 hours)',
          quantity: 2,
          unitPrice: 60.0,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Invoice(
      id: 'INV-002',
      orgId: 'org_1',
      contactId: '5',
      contactName: 'David Brown',
      invoiceNumber: 'INV-002',
      amount: 8500.0,
      taxRate: 20.0,
      status: InvoiceStatus.paid,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      paidDate: DateTime.now().subtract(const Duration(hours: 5)),
      serviceDescription: 'Heating System Installation',
      items: [
        InvoiceItem(
          description: 'New heating system',
          quantity: 1,
          unitPrice: 6500.0,
        ),
        InvoiceItem(
          description: 'Installation labor (10 hours)',
          quantity: 10,
          unitPrice: 150.0,
        ),
        InvoiceItem(
          description: 'Materials',
          quantity: 1,
          unitPrice: 500.0,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Invoice(
      id: 'INV-003',
      orgId: 'org_1',
      contactId: '1',
      contactName: 'John Smith',
      invoiceNumber: 'INV-003',
      amount: 150.0,
      taxRate: 20.0,
      status: InvoiceStatus.sent,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      serviceDescription: 'Boiler Service',
      items: [
        InvoiceItem(
          description: 'Annual boiler service',
          quantity: 1,
          unitPrice: 120.0,
        ),
        InvoiceItem(
          description: 'Minor repairs',
          quantity: 1,
          unitPrice: 30.0,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Invoice(
      id: 'INV-004',
      orgId: 'org_1',
      contactId: '2',
      contactName: 'Sarah Williams',
      invoiceNumber: 'INV-004',
      amount: 450.0,
      taxRate: 20.0,
      status: InvoiceStatus.overdue,
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      serviceDescription: 'Initial Consultation & Quote',
      items: [
        InvoiceItem(
          description: 'Consultation fee',
          quantity: 1,
          unitPrice: 150.0,
        ),
        InvoiceItem(
          description: 'Detailed quote preparation',
          quantity: 1,
          unitPrice: 300.0,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Invoice(
      id: 'INV-005',
      orgId: 'org_1',
      contactId: '1',
      contactName: 'John Smith',
      invoiceNumber: 'INV-005',
      amount: 450.0,
      taxRate: 20.0,
      status: InvoiceStatus.pending,
      dueDate: DateTime.now().add(const Duration(days: 14)),
      serviceDescription: 'Radiator Replacement',
      items: [
        InvoiceItem(
          description: 'Radiators (3x)',
          quantity: 3,
          unitPrice: 120.0,
        ),
        InvoiceItem(
          description: 'Installation',
          quantity: 1,
          unitPrice: 90.0,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<Payment> _payments = [
    Payment(
      id: 'PAY-001',
      invoiceId: 'INV-001',
      amount: 200.0,
      method: PaymentMethod.card,
      status: PaymentStatus.completed,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      contactName: 'Mike Johnson',
    ),
    Payment(
      id: 'PAY-002',
      invoiceId: 'INV-002',
      amount: 8500.0,
      method: PaymentMethod.bankTransfer,
      status: PaymentStatus.completed,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      contactName: 'David Brown',
    ),
  ];

  /// Fetch all invoices
  static Future<List<Invoice>> fetchAllInvoices() async {
    await simulateDelay();
    logMockOperation('Fetched ${_invoices.length} invoices');
    return List.from(_invoices);
  }

  /// Fetch invoice by ID
  static Future<Invoice?> fetchInvoiceById(String id) async {
    await simulateDelay();
    final invoice = _invoices.where((i) => i.id == id).firstOrNull;
    logMockOperation('Fetched invoice: ${invoice?.id ?? "Not found"}');
    return invoice;
  }

  /// Filter invoices by status
  static Future<List<Invoice>> filterInvoicesByStatus(InvoiceStatus status) async {
    await simulateDelay();
    final results = _invoices.where((i) => i.status == status).toList();
    logMockOperation('Filtered invoices by status ${status.name}: ${results.length} results');
    return results;
  }

  /// Get invoice count by status
  static Future<Map<InvoiceStatus, int>> getInvoiceCountByStatus() async {
    await simulateDelay();
    final counts = <InvoiceStatus, int>{};
    for (final status in InvoiceStatus.values) {
      counts[status] = _invoices.where((i) => i.status == status).length;
    }
    logMockOperation('Invoice count by status: $counts');
    return counts;
  }

  /// Get total amounts by status
  static Future<Map<InvoiceStatus, double>> getAmountByStatus() async {
    await simulateDelay();
    final amounts = <InvoiceStatus, double>{};
    for (final status in InvoiceStatus.values) {
      amounts[status] = _invoices
          .where((i) => i.status == status)
          .fold<double>(0, (sum, invoice) => sum + invoice.amount);
    }
    logMockOperation('Invoice amounts by status: $amounts');
    return amounts;
  }

  /// Fetch all payments
  static Future<List<Payment>> fetchAllPayments() async {
    await simulateDelay();
    logMockOperation('Fetched ${_payments.length} payments');
    return List.from(_payments);
  }

  /// Get revenue stats
  static Future<RevenueStats> getRevenueStats() async {
    await simulateDelay();

    final totalRevenue = _payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    final thisMonthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final thisMonthRevenue = _payments
        .where((p) => p.timestamp.isAfter(thisMonthStart))
        .fold<double>(0, (sum, payment) => sum + payment.amount);

    final outstanding = _invoices
        .where((i) => i.status == InvoiceStatus.pending || i.status == InvoiceStatus.sent)
        .fold<double>(0, (sum, invoice) => sum + invoice.amount);

    final overdue = _invoices
        .where((i) => i.status == InvoiceStatus.overdue)
        .fold<double>(0, (sum, invoice) => sum + invoice.amount);

    final stats = RevenueStats(
      totalRevenue: totalRevenue,
      thisMonthRevenue: thisMonthRevenue,
      outstanding: outstanding,
      overdue: overdue,
    );

    logMockOperation('Revenue stats: Total £${stats.totalRevenue}, This month £${stats.thisMonthRevenue}');
    return stats;
  }

  /// Mark invoice as paid
  static Future<bool> markInvoicePaid(String invoiceId) async {
    await simulateDelay();
    final index = _invoices.indexWhere((i) => i.id == invoiceId);
    if (index == -1) {
      logMockOperation('Invoice not found: $invoiceId');
      return false;
    }
    final invoice = _invoices[index];
    _invoices[index] = Invoice(
      id: invoice.id,
      orgId: invoice.orgId,
      contactId: invoice.contactId,
      contactName: invoice.contactName,
      invoiceNumber: invoice.invoiceNumber,
      amount: invoice.amount,
      taxRate: invoice.taxRate,
      status: InvoiceStatus.paid,
      dueDate: invoice.dueDate,
      paidDate: DateTime.now(),
      serviceDescription: invoice.serviceDescription,
      items: invoice.items,
      notes: invoice.notes,
      createdAt: invoice.createdAt,
    );
    logMockOperation('Invoice marked paid: ${invoice.id}');
    return true;
  }

  /// Delete invoice
  static Future<bool> deleteInvoice(String invoiceId) async {
    await simulateDelay();
    final index = _invoices.indexWhere((i) => i.id == invoiceId);
    if (index == -1) {
      logMockOperation('Invoice not found: $invoiceId');
      return false;
    }
    _invoices.removeAt(index);
    logMockOperation('Invoice deleted: $invoiceId');
    return true;
  }
}

/// Invoice model - Matches backend `invoices` table schema
class Invoice {
  // Primary keys
  final String id;
  final String? orgId; // Required for backend RLS - nullable for backward compatibility
  
  // Foreign keys
  final String contactId;
  final String? jobId; // FK nullable
  final String? quoteId; // FK nullable
  
  // Core fields
  final String invoiceNumber; // Backend: invoice_number
  final double amount;
  final double taxRate; // Backend: tax_rate
  final InvoiceStatus status;
  final DateTime dueDate; // Backend: due_date (date)
  final DateTime? paidDate; // Backend: paid_date (date nullable)
  final List<InvoiceItem> items; // Backend: items (jsonb - line_items)
  final String? notes; // Backend: notes (text nullable)
  
  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt; // Backend: updated_at
  
  // Denormalized fields (for UI convenience, not in backend)
  final String? contactName; // Can be joined from contacts table
  final String? serviceDescription; // May be in items or description
  
  // Backward compatibility: computed property
  double get totalAmount => items.fold<double>(
        0,
        (sum, item) => sum + (item.quantity * item.unitPrice),
      );

  Invoice({
    required this.id,
    this.orgId,
    required this.contactId,
    this.jobId,
    this.quoteId,
    required this.invoiceNumber,
    required this.amount,
    required this.taxRate,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.items,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    // Denormalized/backward compatibility
    this.contactName,
    this.serviceDescription,
  });
  
  /// Create from backend JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      orgId: json['org_id'] as String?,
      contactId: json['contact_id'] as String,
      jobId: json['job_id'] as String?,
      quoteId: json['quote_id'] as String?,
      invoiceNumber: json['invoice_number'] as String,
      amount: (json['amount'] as num).toDouble(),
      taxRate: (json['tax_rate'] as num).toDouble(),
      status: InvoiceStatusExtension.fromBackend(json['status'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      paidDate: json['paid_date'] != null ? DateTime.parse(json['paid_date'] as String) : null,
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
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
      'job_id': jobId,
      'quote_id': quoteId,
      'invoice_number': invoiceNumber,
      'amount': amount,
      'tax_rate': taxRate,
      'status': status.backendValue,
      'due_date': dueDate.toIso8601String().split('T')[0], // date only
      'paid_date': paidDate?.toIso8601String().split('T')[0],
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Invoice item model - Matches backend `line_items` table schema
class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
  
  /// Create from backend JSON
  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
    );
  }
  
  /// Convert to backend JSON
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}

/// Invoice status
enum InvoiceStatus {
  draft,
  pending,
  sent,
  paid,
  overdue,
  cancelled,
}

extension InvoiceStatusExtension on InvoiceStatus {
  String get displayName {
    switch (this) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.sent:
        return 'Sent';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  String get backendValue {
    switch (this) {
      case InvoiceStatus.draft:
        return 'draft';
      case InvoiceStatus.pending:
        return 'pending';
      case InvoiceStatus.sent:
        return 'sent';
      case InvoiceStatus.paid:
        return 'paid';
      case InvoiceStatus.overdue:
        return 'overdue';
      case InvoiceStatus.cancelled:
        return 'cancelled';
    }
  }
  
  static InvoiceStatus fromBackend(String value) {
    switch (value) {
      case 'draft':
        return InvoiceStatus.draft;
      case 'pending':
        return InvoiceStatus.pending;
      case 'sent':
        return InvoiceStatus.sent;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        return InvoiceStatus.draft;
    }
  }
}

/// Payment model
class Payment {
  final String id;
  final String invoiceId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime timestamp;
  final String contactName;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    required this.status,
    required this.timestamp,
    required this.contactName,
  });
}

/// Payment method
enum PaymentMethod {
  card,
  cash,
  bankTransfer,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

/// Payment status
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

/// Revenue statistics
class RevenueStats {
  final double totalRevenue;
  final double thisMonthRevenue;
  final double outstanding;
  final double overdue;

  RevenueStats({
    required this.totalRevenue,
    required this.thisMonthRevenue,
    required this.outstanding,
    required this.overdue,
  });
}
