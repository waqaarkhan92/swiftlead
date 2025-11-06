import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/forms/deposit_request_sheet.dart';
import '../../theme/tokens.dart';

/// DepositsScreen - Manage deposits
/// Exact specification from UI_Inventory_v2.5.1
class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  String _selectedFilter = 'All'; // All, Pending, Collected, Refunded

  final List<_Deposit> _deposits = [
    _Deposit(
      id: '1',
      jobTitle: 'Bathroom Renovation',
      clientName: 'Sarah Williams',
      amount: 500.0,
      status: DepositStatus.pending,
      requestedDate: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    _Deposit(
      id: '2',
      jobTitle: 'Kitchen Sink Install',
      clientName: 'Emily Chen',
      amount: 150.0,
      status: DepositStatus.collected,
      requestedDate: DateTime.now().subtract(const Duration(days: 10)),
      collectedDate: DateTime.now().subtract(const Duration(days: 8)),
    ),
    _Deposit(
      id: '3',
      jobTitle: 'Heating System Installation',
      clientName: 'David Brown',
      amount: 2000.0,
      status: DepositStatus.collected,
      requestedDate: DateTime.now().subtract(const Duration(days: 30)),
      collectedDate: DateTime.now().subtract(const Duration(days: 28)),
    ),
  ];

  List<_Deposit> get _filteredDeposits {
    if (_selectedFilter == 'All') return _deposits;
    return _deposits.where((d) {
      switch (_selectedFilter) {
        case 'Pending':
          return d.status == DepositStatus.pending;
        case 'Collected':
          return d.status == DepositStatus.collected;
        case 'Refunded':
          return d.status == DepositStatus.refunded;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Deposits',
        actions: [
          if (_selectedFilter == 'All')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                DepositRequestSheet.show(
                  context: context,
                  onSend: (amount, dueDate, message) {
                    // TODO: Save deposit request when backend is ready
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deposit request sent for £${amount.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                );
              },
              tooltip: 'Request Deposit',
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Collected', 'Refunded'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
                      checkmarkColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Deposits List
          Expanded(
            child: _filteredDeposits.isEmpty
                ? EmptyStateCard(
                    title: 'No deposits',
                    description: _selectedFilter == 'All'
                        ? 'Deposits will appear here when requested.'
                        : 'No ${_selectedFilter.toLowerCase()} deposits.',
                    icon: Icons.payments,
                    actionLabel: _selectedFilter == 'All' ? 'Request Deposit' : null,
                    onAction: _selectedFilter == 'All' ? () {
                      DepositRequestSheet.show(
                        context: context,
                        onSend: (amount, dueDate, message) {
                          // TODO: Save deposit request when backend is ready
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deposit request sent for £${amount.toStringAsFixed(2)}'),
                            ),
                          );
                        },
                      );
                    } : null,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    itemCount: _filteredDeposits.length,
                    itemBuilder: (context, index) {
                      final deposit = _filteredDeposits[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                        child: _DepositCard(deposit: deposit),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

enum DepositStatus { pending, collected, refunded }

class _Deposit {
  final String id;
  final String jobTitle;
  final String clientName;
  final double amount;
  final DepositStatus status;
  final DateTime requestedDate;
  final DateTime? dueDate;
  final DateTime? collectedDate;
  final DateTime? refundedDate;

  _Deposit({
    required this.id,
    required this.jobTitle,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.requestedDate,
    this.dueDate,
    this.collectedDate,
    this.refundedDate,
  });
}

class _DepositCard extends StatelessWidget {
  final _Deposit deposit;

  const _DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (deposit.status) {
      case DepositStatus.pending:
        statusColor = const Color(SwiftleadTokens.warningYellow);
        statusText = 'Pending';
        statusIcon = Icons.pending;
        break;
      case DepositStatus.collected:
        statusColor = const Color(SwiftleadTokens.successGreen);
        statusText = 'Collected';
        statusIcon = Icons.check_circle;
        break;
      case DepositStatus.refunded:
        statusColor = Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodyMedium?.color ?? const Color(SwiftleadTokens.textSecondaryLight);
        statusText = 'Refunded';
        statusIcon = Icons.undo;
        break;
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deposit.jobTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      deposit.clientName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '£${deposit.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceXS),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceXS),
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                deposit.status == DepositStatus.pending && deposit.dueDate != null
                    ? 'Due: ${_formatDate(deposit.dueDate!)}'
                    : deposit.collectedDate != null
                        ? 'Collected: ${_formatDate(deposit.collectedDate!)}'
                        : 'Requested: ${_formatDate(deposit.requestedDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

