import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/components/recurring_schedule_card.dart';
import '../../theme/tokens.dart';
import '../../utils/profession_config.dart';
import '../../config/mock_config.dart';

/// RecurringInvoicesScreen - Manage recurring invoices
/// Exact specification from UI_Inventory_v2.5.1
class RecurringInvoicesScreen extends StatefulWidget {
  const RecurringInvoicesScreen({super.key});

  @override
  State<RecurringInvoicesScreen> createState() => _RecurringInvoicesScreenState();
}

class _RecurringInvoicesScreenState extends State<RecurringInvoicesScreen> {
  bool _isLoading = true;
  List<RecurringInvoice> _recurringInvoices = [];

  @override
  void initState() {
    super.initState();
    _loadRecurringInvoices();
  }

  Future<void> _loadRecurringInvoices() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      // Mock data - in real app would fetch from backend
      _recurringInvoices = [
        RecurringInvoice(
          id: '1',
          invoiceNumber: 'INV-2024-001',
          clientName: 'John Smith',
          amount: 150.0,
          frequency: RecurrenceFrequency.monthly,
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          nextOccurrence: DateTime.now().add(const Duration(days: 5)),
          status: RecurringInvoiceStatus.active,
        ),
        RecurringInvoice(
          id: '2',
          invoiceNumber: 'INV-2024-002',
          clientName: 'Sarah Williams',
          amount: 250.0,
          frequency: RecurrenceFrequency.weekly,
          startDate: DateTime.now().subtract(const Duration(days: 7)),
          nextOccurrence: DateTime.now().add(const Duration(days: 2)),
          status: RecurringInvoiceStatus.active,
        ),
        RecurringInvoice(
          id: '3',
          invoiceNumber: 'INV-2024-003',
          clientName: 'Mike Johnson',
          amount: 500.0,
          frequency: RecurrenceFrequency.quarterly,
          startDate: DateTime.now().subtract(const Duration(days: 90)),
          nextOccurrence: DateTime.now().add(const Duration(days: 60)),
          status: RecurringInvoiceStatus.paused,
        ),
      ];
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Recurring ${ProfessionState.config.getLabel('Invoices')}',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create recurring invoice
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create recurring invoice coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: SkeletonLoader(
            width: double.infinity,
            height: 120,
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_recurringInvoices.isEmpty) {
      return EmptyStateCard(
          title: 'No recurring ${ProfessionState.config.getLabel('invoices').toLowerCase()}',
        description: 'Create recurring invoices to automatically send invoices on a schedule.',
        icon: Icons.repeat,
        actionLabel: 'Create Recurring Invoice',
        onAction: () {
          // TODO: Navigate to create
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecurringInvoices,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          ..._recurringInvoices.map((invoice) => Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: RecurringScheduleCard(
                  invoiceNumber: invoice.invoiceNumber,
                  clientName: invoice.clientName,
                  amount: invoice.amount,
                  frequency: invoice.frequency,
                  nextOccurrence: invoice.nextOccurrence,
                  startDate: invoice.startDate,
                  status: invoice.status,
                  onTap: () {
                    // TODO: Navigate to recurring invoice detail
                  },
                ),
              )),
        ],
      ),
    );
  }
}

/// RecurringInvoice model
class RecurringInvoice {
  final String id;
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final RecurrenceFrequency frequency;
  final DateTime startDate;
  final DateTime? nextOccurrence;
  final RecurringInvoiceStatus status;

  RecurringInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.nextOccurrence,
    required this.status,
  });
}

