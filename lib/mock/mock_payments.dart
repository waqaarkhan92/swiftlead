import '../config/mock_config.dart';
import '../models/payment.dart';

/// Mock Payments & Invoices Repository
/// Provides realistic mock financial data for Money screen preview
class MockPayments {
  static final List<Invoice> _invoices = [
    Invoice(
      id: 'INV-001',
      contactId: '3',
      contactName: 'Mike Johnson',
      amount: 200.0,
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
      contactId: '5',
      contactName: 'David Brown',
      amount: 8500.0,
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
      contactId: '1',
      contactName: 'John Smith',
      amount: 150.0,
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
      contactId: '2',
      contactName: 'Sarah Williams',
      amount: 450.0,
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
      contactId: '1',
      contactName: 'John Smith',
      amount: 450.0,
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
}

/// Invoice model
class Invoice {
  final String id;
  final String contactId;
  final String contactName;
  final double amount;
  final InvoiceStatus status;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String serviceDescription;
  final List<InvoiceItem> items;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.contactId,
    required this.contactName,
    required this.amount,
    required this.status,
    required this.dueDate,
    this.paidDate,
    required this.serviceDescription,
    required this.items,
    required this.createdAt,
  });

  double get totalAmount => items.fold<double>(
        0,
        (sum, item) => sum + (item.quantity * item.unitPrice),
      );
}

/// Invoice item model
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
