import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';
import '../quotes/quotes_screen.dart';
import 'invoice_detail_screen.dart';
import 'create_edit_invoice_screen.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';

/// MoneyScreen - Payments & Finance
/// Exact specification from Screen_Layouts_v2.5.1
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  bool _isLoading = true;
  int _selectedTab = 0; // 0 = Dashboard, 1 = Invoices, 2 = Quotes, 3 = Payments
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Overdue', 'Refunded'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Money',
        actions: [
          // Date range filter
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () {
              // Date range picker opens
            },
          ),
          // Export button
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_selectedTab == 1) {
      // Invoices tab
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEditInvoiceScreen(),
            ),
          );
        },
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        icon: const Icon(Icons.receipt, color: Colors.white),
        label: const Text(
          'Invoice',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (_selectedTab == 2) {
      // Quotes tab
      return FloatingActionButton.extended(
        onPressed: () {
          // Create quote
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuotesScreen()),
          );
        },
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        icon: const Icon(Icons.description, color: Colors.white),
        label: const Text(
          'Quote',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    // Dashboard tab
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: const Color(SwiftleadTokens.primaryTeal),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Payment',
        style: TextStyle(color: Colors.white),
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
        Row(
          children: List.generate(4, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 3 ? 8.0 : 0.0),
              child: SkeletonLoader(
                width: double.infinity,
                height: 100,
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          )),
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
            segments: const ['Dashboard', 'Invoices', 'Quotes', 'Payments'],
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
              const QuotesScreen(), // Quotes tab
              _buildPaymentsTab(),
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

  String _getClientName(int index) {
    final names = ['John Smith', 'Sarah Williams', 'Mike Johnson'];
    return names[index % names.length];
  }

  Widget _buildBalanceHeader() {
    return FrostedContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '£${_totalRevenue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(width: 12),
                      // TrendIndicator: ↑ 12% vs last month
                      Container(
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
                    ],
                  ),
                ],
              ),
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
            ],
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
                onPressed: () {},
              ),
              _QuickActionButton(
                icon: Icons.request_quote,
                label: 'Request Payment',
                onPressed: () {},
              ),
              _QuickActionButton(
                icon: Icons.remove_circle_outline,
                label: 'Add Expense',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
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
        const SizedBox(width: SwiftleadTokens.spaceS),
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
                final isSelected = period == '30D';
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: period,
                    isSelected: isSelected,
                    onTap: () {},
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Chart will be implemented with fl_chart\n(Tap data points for drill-down, interactive legend)',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
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
    return EmptyStateCard(
      title: 'No transactions yet',
      description: 'Send your first invoice to get paid for your work.',
      icon: Icons.receipt_outlined,
      actionLabel: 'Send Invoice',
      onAction: () {},
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
