import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';
import '../quotes/create_edit_quote_screen.dart';
import '../quotes/quote_detail_screen.dart';
import '../../widgets/forms/payment_request_modal.dart';
import 'invoice_detail_screen.dart';
import 'create_edit_invoice_screen.dart';
import 'payment_detail_screen.dart';
import 'money_search_screen.dart';
import 'recurring_invoices_screen.dart';
import 'payment_methods_screen.dart';
import 'deposits_screen.dart';
import '../../widgets/forms/job_export_sheet.dart';
import '../../widgets/forms/money_filter_sheet.dart';
import '../../widgets/components/trend_line_chart.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../main_navigation.dart' as main_nav;

/// MoneyScreen - Payments & Finance
/// Exact specification from Screen_Layouts_v2.5.1
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  bool _isLoading = true;
  int _selectedTab = 0; // 0 = Dashboard, 1 = Invoices, 2 = Quotes, 3 = Payments, 4 = Deposits
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Overdue', 'Refunded'];
  String _selectedQuoteFilter = 'All';
  final List<String> _quoteFilters = ['All', 'Draft', 'Sent', 'Viewed', 'Accepted', 'Declined', 'Expired'];
  String _selectedPeriod = '30D'; // For dashboard chart

  // Financial data from mock
  double _totalRevenue = 0;
  double _thisMonthRevenue = 0;
  double _outstanding = 0;
  double _overdue = 0;
  List<Invoice> _allInvoices = [];
  List<Invoice> _filteredInvoices = [];
  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      final revenueStats = await MockPayments.getRevenueStats();
      _totalRevenue = revenueStats.totalRevenue;
      _thisMonthRevenue = revenueStats.thisMonthRevenue;
      _outstanding = revenueStats.outstanding;
      _overdue = revenueStats.overdue;

      _allInvoices = await MockPayments.fetchAllInvoices();
      _payments = await MockPayments.fetchAllPayments();
    }

    _applyInvoiceFilter();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handleSendInvoiceFromDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditInvoiceScreen(),
      ),
    );
  }

  void _handleRequestPaymentFromDashboard() {
    PaymentRequestModal.show(
      context: context,
      onSendRequest: (amount, method) {
        // Handle payment request sent
      },
    );
  }

  void _applyInvoiceFilter() {
    if (_selectedFilter == 'All') {
      _filteredInvoices = List.from(_allInvoices);
    } else if (_selectedFilter == 'Paid') {
      _filteredInvoices = _allInvoices
          .where((i) => i.status == InvoiceStatus.paid)
          .toList();
    } else if (_selectedFilter == 'Pending') {
      _filteredInvoices = _allInvoices
          .where((i) =>
              i.status == InvoiceStatus.pending ||
              i.status == InvoiceStatus.sent)
          .toList();
    } else if (_selectedFilter == 'Overdue') {
      _filteredInvoices = _allInvoices
          .where((i) => i.status == InvoiceStatus.overdue)
          .toList();
    }
  }

  List<Map<String, dynamic>> _getFilteredQuotes() {
    List<Map<String, dynamic>> allQuotes = List.generate(8, (index) => {
      'number': 'QUO-${1000 + index}',
      'client': _getQuoteClientName(index),
      'service': _getQuoteService(index),
      'amount': _getQuoteAmount(index),
      'status': _getQuoteStatus(index),
      'validUntil': DateTime.now().add(Duration(days: 7 - index)),
      'index': index,
    });

    if (_selectedQuoteFilter == 'All') {
      return allQuotes;
    }
    return allQuotes.where((quote) => quote['status'] == _selectedQuoteFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Money',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () async {
              final filters = await MoneyFilterSheet.show(
                context: context,
              );
              if (filters != null) {
                // TODO: Apply filters
              }
            },
          ),
          // Date range filter
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () {
              _showDateRangePicker(context);
            },
          ),
          // Export button
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              // Use job export sheet as template - in real app would have money export sheet
              // For now, show a placeholder
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Export Data'),
                  content: const Text('Export functionality coming soon'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MoneySearchScreen(),
                ),
              );
            },
          ),
          // Add menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            onSelected: (value) {
              if (value == 'request_payment') {
                PaymentRequestModal.show(
                  context: context,
                  onSendRequest: (amount, method) {
                    // Handle payment request sent
                  },
                );
                return;
              }
              switch (value) {
                case 'payment':
                  _handleAddPayment();
                  break;
                case 'invoice':
                  _handleAddInvoice();
                  break;
                case 'quote':
                  _handleAddQuote();
                  break;
                case 'recurring':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecurringInvoicesScreen(),
                    ),
                  );
                  break;
                case 'payment_methods':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethodsScreen(),
                    ),
                  );
                  break;
                case 'deposits':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DepositsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'payment',
                child: Row(
                  children: [
                    Icon(Icons.payment, size: 20),
                    SizedBox(width: 12),
                    Text('Add Payment'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'invoice',
                child: Row(
                  children: [
                    Icon(Icons.receipt, size: 20),
                    SizedBox(width: 12),
                    Text('Create Invoice'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'quote',
                child: Row(
                  children: [
                    Icon(Icons.description, size: 20),
                    SizedBox(width: 12),
                    Text('Create Quote'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'recurring',
                child: Row(
                  children: [
                    Icon(Icons.repeat, size: 20),
                    SizedBox(width: 12),
                    Text('Recurring Invoices'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'payment_methods',
                child: Row(
                  children: [
                    Icon(Icons.credit_card, size: 20),
                    SizedBox(width: 12),
                    Text('Payment Methods'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'deposits',
                child: Row(
                  children: [
                    Icon(Icons.payments, size: 20),
                    SizedBox(width: 12),
                    Text('Deposits'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  void _handleAddPayment() {
    // Show payment request modal to record a payment
    PaymentRequestModal.show(
      context: context,
      onSendRequest: (amount, method) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment recorded'),
            backgroundColor: Color(SwiftleadTokens.primaryTeal),
          ),
        );
      },
    );
  }

  void _handleAddInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditInvoiceScreen(),
      ),
    );
  }

  void _handleAddQuote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEditQuoteScreen()),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Range Filter'),
        content: const Text('Date range picker coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        top: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
      children: [
        // Balance skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 140,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        // Metrics skeleton
        Column(
          children: [
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 1 ? 8.0 : 0.0),
                  child: SkeletonLoader(
                    width: double.infinity,
                    height: 100,
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              )),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: List.generate(2, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 1 ? 8.0 : 0.0),
                  child: SkeletonLoader(
                    width: double.infinity,
                    height: 100,
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              )),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        // Chart skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Tab Selector
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: SegmentedControl(
            segments: const ['Dashboard', 'Invoices', 'Quotes', 'Payments', 'Deposits'],
            selectedIndex: _selectedTab,
            onSelectionChanged: (index) {
              setState(() => _selectedTab = index);
            },
          ),
        ),
        
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildDashboardTab(),
              _buildInvoicesTab(),
              _buildQuotesTab(), // Quotes tab
              _buildPaymentsTab(),
              _buildDepositsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull-to-refresh syncs with Stripe
        await _loadFinancialData();
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
        ),
        children: [
          // BalanceHeader - Large numeric display
          _buildBalanceHeader(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // MetricsRow - 4 key financial metrics
          _buildMetricsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // RevenueBreakdownChart - Interactive visualization
          _buildRevenueChart(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // TransactionFilterChips - Quick filters
          _buildFilterChips(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // PaymentList - Transaction history
          _buildPaymentList(),
        ],
      ),
    );
  }

  Widget _buildInvoicesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadFinancialData();
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
        ),
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Paid', 'Pending', 'Overdue'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                        _applyInvoiceFilter();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Invoice List
          _filteredInvoices.isEmpty
              ? EmptyStateCard(
                  title: 'No ${_selectedFilter.toLowerCase()} invoices',
                  description: 'Invoices will appear here when they match this filter.',
                  icon: Icons.receipt_outlined,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = _filteredInvoices[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: _InvoiceCard(
                        invoiceNumber: invoice.id,
                        clientName: invoice.contactName,
                        amount: invoice.amount,
                        status: invoice.status.displayName,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoiceDetailScreen(
                                invoiceId: invoice.id,
                                invoiceNumber: invoice.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadFinancialData();
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
        ),
        children: [
          Text(
            'Payment History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildPaymentList(),
        ],
      ),
    );
  }

  Widget _buildDepositsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadFinancialData();
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deposits',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Manage deposit payments and requests',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceL),
                EmptyStateCard(
                  title: 'No deposits yet',
                  description: 'Deposits will appear here when requested',
                  icon: Icons.payment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
        ),
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quoteFilters.map((filter) {
                final isSelected = _selectedQuoteFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedQuoteFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Quotes List
          _getFilteredQuotes().isEmpty
              ? EmptyStateCard(
                  title: 'No ${_selectedQuoteFilter.toLowerCase()} quotes',
                  description: 'Quotes will appear here when they match this filter.',
                  icon: Icons.description_outlined,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _getFilteredQuotes().length,
                  itemBuilder: (context, index) {
                    final quote = _getFilteredQuotes()[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: _QuoteCard(
                        quoteNumber: quote['number'] as String,
                        clientName: quote['client'] as String,
                        service: quote['service'] as String,
                        amount: quote['amount'] as double,
                        status: quote['status'] as String,
                        validUntil: quote['validUntil'] as DateTime,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuoteDetailScreen(
                                quoteId: 'quote_${quote['index']}',
                                quoteNumber: quote['number'] as String,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  String _getClientName(int index) {
    final names = ['John Smith', 'Sarah Williams', 'Mike Johnson'];
    return names[index % names.length];
  }

  String _getQuoteClientName(int index) {
    final names = ['John Smith', 'Sarah Williams', 'Mike Johnson', 'Emily Davis'];
    return names[index % names.length];
  }

  String _getQuoteService(int index) {
    final services = ['Kitchen Sink Repair', 'Bathroom Installation', 'Heating Repair', 'Electrical Work'];
    return services[index % services.length];
  }

  double _getQuoteAmount(int index) {
    return 200.0 + (index * 100.0);
  }

  String _getQuoteStatus(int index) {
    final statuses = ['Draft', 'Sent', 'Viewed', 'Accepted', 'Declined'];
    return statuses[index % statuses.length];
  }

  Widget _buildBalanceHeader() {
    return FrostedContainer(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                '£${_totalRevenue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // StripeConnectionStatus
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Color(SwiftleadTokens.successGreen),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Connected to Stripe',
                      style: TextStyle(
                        color: const Color(SwiftleadTokens.successGreen),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // QuickActions: "Send Invoice", "Request Payment", "Add Expense"
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: [
                  _QuickActionButton(
                    icon: Icons.send,
                    label: 'Send Invoice',
                    onPressed: _handleSendInvoiceFromDashboard,
                  ),
                  _QuickActionButton(
                    icon: Icons.request_quote,
                    label: 'Request Payment',
                    onPressed: _handleRequestPaymentFromDashboard,
                  ),
                  _QuickActionButton(
                    icon: Icons.remove_circle_outline,
                    label: 'Add Expense',
                    onPressed: () {
                      // Show expense form - placeholder for now
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add Expense'),
                          content: const Text('Expense tracking coming soon. For now, you can add expenses when creating invoices.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // TrendIndicator: ↑ 12% vs last month - positioned top right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    size: 16,
                    color: Color(SwiftleadTokens.successGreen),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+12%',
                    style: const TextStyle(
                      color: Color(SwiftleadTokens.successGreen),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TrendTile(
                label: 'Outstanding',
                value: '£450',
                trend: '5 invoices',
                isPositive: false,
                tooltip: 'Amount not yet paid',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: TrendTile(
                label: 'Paid This Month',
                value: '£2,000',
                trend: '+15%',
                isPositive: true,
                tooltip: 'Total received this month',
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: TrendTile(
                label: 'Pending',
                value: '£120',
                trend: 'In processing',
                isPositive: true,
                tooltip: 'Payments in processing',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: TrendTile(
                label: 'Overdue',
                value: '£80',
                trend: '2 invoices',
                isPositive: false,
                tooltip: 'Late payments',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueChart() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Breakdown',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // ChartTypeSwitcher: Line / Bar / Donut toggle
              Row(
                children: [
                  _ChartTypeButton(icon: Icons.show_chart, isSelected: true),
                  const SizedBox(width: 8),
                  _ChartTypeButton(icon: Icons.bar_chart, isSelected: false),
                  const SizedBox(width: 8),
                  _ChartTypeButton(icon: Icons.pie_chart, isSelected: false),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // TimePeriod Selector: 7D / 30D / 90D / 1Y / All
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['7D', '30D', '90D', '1Y', 'All'].map((period) {
                final isSelected = period == _selectedPeriod;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: period,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedPeriod = period;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          TrendLineChart(
            title: '',
            dataPoints: [
              ChartDataPoint(label: 'Week 1', value: 5000),
              ChartDataPoint(label: 'Week 2', value: 6200),
              ChartDataPoint(label: 'Week 3', value: 5800),
              ChartDataPoint(label: 'Week 4', value: 7500),
            ],
            periodData: {
              '7D': [
                ChartDataPoint(label: 'D1', value: 800),
                ChartDataPoint(label: 'D2', value: 950),
                ChartDataPoint(label: 'D3', value: 720),
                ChartDataPoint(label: 'D4', value: 1050),
                ChartDataPoint(label: 'D5', value: 920),
                ChartDataPoint(label: 'D6', value: 1100),
                ChartDataPoint(label: 'D7', value: 1250),
              ],
              '30D': [
                ChartDataPoint(label: 'Week 1', value: 5000),
                ChartDataPoint(label: 'Week 2', value: 6200),
                ChartDataPoint(label: 'Week 3', value: 5800),
                ChartDataPoint(label: 'Week 4', value: 7500),
              ],
              '90D': [
                ChartDataPoint(label: 'Month 1', value: 22000),
                ChartDataPoint(label: 'Month 2', value: 24800),
                ChartDataPoint(label: 'Month 3', value: 28500),
              ],
            },
            lineColor: const Color(SwiftleadTokens.successGreen),
            yAxisLabel: '£',
            onDataPointTap: (point) {
              // Drill-down: Show detailed breakdown for this period
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Revenue: ${point.label}'),
                  content: Text('£${point.value.toStringAsFixed(2)}\n\nTap for detailed breakdown'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          final count = filter == 'All' ? null : (filter == 'Paid' ? 12 : filter == 'Pending' ? 3 : filter == 'Overdue' ? 2 : 0);
          return Padding(
            padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
            child: SwiftleadChip(
              label: count != null ? '$filter ($count)' : filter,
              isSelected: isSelected,
              onTap: () {
                setState(() => _selectedFilter = filter);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentList() {
    if (_payments.isEmpty) {
      return EmptyStateCard(
        title: 'No transactions yet',
        description: 'Send your first invoice to get paid for your work.',
        icon: Icons.receipt_outlined,
        actionLabel: 'Send Invoice',
        onAction: () {},
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _PaymentCard(
            paymentId: payment.id,
            paymentNumber: 'PAY-${1000 + index}',
            clientName: payment.contactName,
            amount: payment.amount,
            date: payment.timestamp,
            method: payment.method.displayName,
            status: payment.status.name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentDetailScreen(
                    paymentId: payment.id,
                    paymentNumber: 'PAY-${1000 + index}',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final String paymentId;
  final String paymentNumber;
  final String clientName;
  final double amount;
  final DateTime date;
  final String method;
  final String status;
  final VoidCallback onTap;

  const _PaymentCard({
    required this.paymentId,
    required this.paymentNumber,
    required this.clientName,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(SwiftleadTokens.successGreen);
      case 'pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'failed':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentNumber,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clientName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(date)} • $method',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '£${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _ChartTypeButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  
  const _ChartTypeButton({
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: isSelected
          ? const Color(SwiftleadTokens.primaryTeal)
          : Theme.of(context).textTheme.bodySmall?.color,
      onPressed: () {},
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final String status;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(SwiftleadTokens.successGreen);
      case 'Pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'Overdue':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoiceNumber,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clientName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '£${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String quoteNumber;
  final String clientName;
  final String service;
  final double amount;
  final String status;
  final DateTime validUntil;
  final VoidCallback onTap;

  const _QuoteCard({
    required this.quoteNumber,
    required this.clientName,
    required this.service,
    required this.amount,
    required this.status,
    required this.validUntil,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return const Color(SwiftleadTokens.successGreen);
      case 'Viewed':
        return const Color(SwiftleadTokens.primaryTeal);
      case 'Sent':
        return const Color(SwiftleadTokens.infoBlue);
      case 'Declined':
        return const Color(SwiftleadTokens.errorRed);
      case 'Draft':
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysRemaining = validUntil.difference(DateTime.now()).inDays;
    
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quoteNumber,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clientName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              service,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '£${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (daysRemaining > 0)
                  Text(
                    '$daysRemaining days left',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: daysRemaining <= 3
                          ? const Color(SwiftleadTokens.errorRed)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
