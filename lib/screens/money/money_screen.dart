import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/segmented_control.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/haptic_feedback.dart' as app_haptics;
import '../../widgets/global/info_banner.dart';
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
import '../../widgets/components/celebration_banner.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/components/animated_counter.dart';
import '../../widgets/components/active_filter_chips.dart' show ActiveFilter, ActiveFilterChipsRow;
import '../../utils/keyboard_shortcuts.dart' show AppShortcuts, SearchIntent, CreateIntent, RefreshIntent, CloseIntent, CreateInvoiceIntent;
import '../../utils/responsive_layout.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/hoverable_widget.dart';
import 'package:flutter/foundation.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../main_navigation.dart' as main_nav;
import '../../utils/profession_config.dart';

/// MoneyScreen - Payments & Finance
/// Exact specification from Screen_Layouts_v2.5.1
class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  bool _isLoading = true;
  int _selectedTab = 0; // 0 = Dashboard, 1 = Quotes & Invoices, 2 = Payments
  String _quotesInvoicesSubTab = 'Quotes'; // 'Quotes' or 'Invoices' - sub-navigation within tab 1
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Paid', 'Pending', 'Overdue', 'Refunded'];
  String _selectedQuoteFilter = 'All';
  final List<String> _quoteFilters = ['All', 'Draft', 'Sent', 'Viewed', 'Accepted', 'Declined', 'Expired'];
  String _selectedPeriod = '30D'; // For dashboard chart (can be 'Custom')
  Map<String, dynamic>? _currentMoneyFilters; // Active filter state

  // Financial data from mock
  double _totalRevenue = 0;
  double _thisMonthRevenue = 0;
  double _lastMonthRevenue = 1740.0; // For comparison
  double _outstanding = 0;
  double _overdue = 0;
  double _depositsPending = 0.0;
  int _depositsCount = 0;
  List<Invoice> _allInvoices = [];
  List<Invoice> _filteredInvoices = [];
  List<Payment> _payments = [];
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Analytics Metrics (Features 21-28)
  double _averageInvoiceValue = 0.0;
  int _daysToPayment = 0;
  double _cashFlowProjection = 0.0;
  double _thisWeekRevenue = 0.0;
  double _lastWeekRevenue = 0.0;
  double _yearToDateRevenue = 0.0;
  double _averageJobValue = 0.0;
  int _pendingQuotesCount = 0;
  double _pendingQuotesValue = 0.0;
  int _activePaymentsCount = 0;
  double _activePaymentsValue = 0.0;

  // Feature 39: Batch Actions
  bool _isBatchMode = false;
  Set<String> _selectedInvoiceIds = {};
  
  // Chart type selection
  String _selectedChartType = 'line'; // 'line', 'bar', 'donut'
  
  // Smart prioritization tracking
  final Map<String, int> _invoiceTapCounts = {};
  final Map<String, DateTime> _invoiceLastOpened = {};
  
  // Celebration tracking
  final Set<String> _milestonesShown = {};
  String? _celebrationMessage;
  
  // Progressive disclosure states
  bool _overdueExpanded = true;
  bool _thisMonthExpanded = true;
  bool _olderExpanded = false;

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
      
      // Calculate deposits pending (mock data)
      _depositsPending = 1250.0;
      _depositsCount = 3;
      
      // Calculate Analytics Metrics (Features 21-28)
      // Average Invoice Value (Feature 21)
      _averageInvoiceValue = _allInvoices.isEmpty 
          ? 0.0 
          : _allInvoices.map((i) => i.amount).reduce((a, b) => a + b) / _allInvoices.length;
      
      // Days to Payment (Feature 22) - average days from invoice date to payment
      final paidInvoices = _allInvoices.where((i) => i.status == InvoiceStatus.paid).toList();
      if (paidInvoices.isNotEmpty) {
        final totalDays = paidInvoices.length * 7; // Mock: 7 days average
        _daysToPayment = (totalDays / paidInvoices.length).round();
      }
      
      // Cash Flow Projection (Feature 23) - next 30 days
      _cashFlowProjection = _thisMonthRevenue * 1.1; // Mock: 10% growth projection
      
      // Week vs Last Week (Feature 24)
      _thisWeekRevenue = 2450.0; // Mock data
      _lastWeekRevenue = 2100.0; // Mock data
      
      // Year-to-Date (Feature 25)
      _yearToDateRevenue = 28500.0; // Mock data
      
      // Average Job Value (Feature 26) - from invoices
      _averageJobValue = _averageInvoiceValue; // Assuming jobs = invoices for mock
      
      // Pending Quotes (Feature 27)
      _pendingQuotesCount = 8;
      _pendingQuotesValue = 3200.0; // Mock data
      
      // Active Payments (Feature 28)
      final activePayments = _payments.where((p) => 
        p.status == PaymentStatus.pending || p.status == PaymentStatus.processing
      ).toList();
      _activePaymentsCount = activePayments.length;
      _activePaymentsValue = activePayments.isEmpty 
          ? 0.0 
          : activePayments.map((p) => p.amount).reduce((a, b) => a + b);
    }

    _applyInvoiceFilter();
    _checkForMilestones();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
  
  // Track invoice interaction for smart prioritization
  void _trackInvoiceInteraction(String invoiceId) {
    setState(() {
      _invoiceTapCounts[invoiceId] = (_invoiceTapCounts[invoiceId] ?? 0) + 1;
      _invoiceLastOpened[invoiceId] = DateTime.now();
    });
  }
  
  // Phase 3: Expanded celebration milestones
  void _checkForMilestones() {
    // £10k total revenue milestone
    if (_totalRevenue >= 10000 && !_milestonesShown.contains('10k')) {
      _milestonesShown.add('10k');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎉 £10k revenue milestone! Incredible achievement!';
          });
        }
      });
    }
    
    // £5k this month milestone
    if (_thisMonthRevenue >= 5000 && !_milestonesShown.contains('5kmonth')) {
      _milestonesShown.add('5kmonth');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🚀 £5k this month! Great month!';
          });
        }
      });
    }
    
    // Phase 3: £1k this month milestone
    if (_thisMonthRevenue >= 1000 && _thisMonthRevenue < 5000 && !_milestonesShown.contains('1kmonth')) {
      _milestonesShown.add('1kmonth');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '💷 £1k this month! Great start!';
          });
        }
      });
    }
    
    // Phase 3: £500 total revenue milestone
    if (_totalRevenue >= 500 && _totalRevenue < 10000 && !_milestonesShown.contains('500total')) {
      _milestonesShown.add('500total');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '💰 £500 revenue! Keep it up!';
          });
        }
      });
    }
    
    // Phase 3: First invoice milestone
    if (_allInvoices.isNotEmpty && _allInvoices.length == 1 && !_milestonesShown.contains('firstinvoice')) {
      _milestonesShown.add('firstinvoice');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _celebrationMessage = '🎯 First invoice created! Welcome to Swiftlead!';
          });
        }
      });
    }
  }
  
  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _handleSendInvoiceFromDashboard() {
    Navigator.push(
      context,
      _createPageRoute(const CreateEditInvoiceScreen()),
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
    
    // Phase 2: Smart prioritization - sort using interaction tracking
    _filteredInvoices.sort((a, b) {
      // Overdue first
      final aIsOverdue = a.status == InvoiceStatus.overdue;
      final bIsOverdue = b.status == InvoiceStatus.overdue;
      if (aIsOverdue != bIsOverdue) {
        return aIsOverdue ? -1 : 1;
      }
      
      // Phase 2: Favor frequently accessed invoices
      final aTapCount = _invoiceTapCounts[a.id] ?? 0;
      final bTapCount = _invoiceTapCounts[b.id] ?? 0;
      if (aTapCount != bTapCount) {
        return bTapCount.compareTo(aTapCount);
      }
      
      // Phase 2: Favor recently opened invoices
      final aLastOpened = _invoiceLastOpened[a.id];
      final bLastOpened = _invoiceLastOpened[b.id];
      if (aLastOpened != null && bLastOpened != null) {
        return bLastOpened.compareTo(aLastOpened);
      }
      if (aLastOpened != null) return -1;
      if (bLastOpened != null) return 1;
      
      // Finally by due date or creation date
      return (a.dueDate ?? a.createdAt).compareTo(b.dueDate ?? b.createdAt);
    });
    
    // Phase 2: Contextual hiding - hide paid invoices >90 days old (unless recently opened)
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90));
    _filteredInvoices = _filteredInvoices.where((invoice) {
      if (invoice.status == InvoiceStatus.overdue || 
          invoice.status == InvoiceStatus.pending) return true;
      if (_invoiceLastOpened[invoice.id] != null && 
          _invoiceLastOpened[invoice.id]!.isAfter(ninetyDaysAgo)) return true;
      if (invoice.createdAt.isAfter(ninetyDaysAgo)) return true;
      return false; // Hide old paid invoices
    }).toList();
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
    // Phase 3: Keyboard shortcuts wrapper
    return Shortcuts(
      shortcuts: AppShortcuts.getMoneyShortcuts(() {
        // Create new invoice
        Navigator.push(
          context,
          _createPageRoute(const CreateEditInvoiceScreen()),
        );
      }),
      child: Actions(
        actions: {
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                _createPageRoute(const MoneySearchScreen()),
              );
            },
          ),
          CreateInvoiceIntent: CallbackAction<CreateInvoiceIntent>(
            onInvoke: (_) {
              Navigator.push(
                context,
                _createPageRoute(const CreateEditInvoiceScreen()),
              );
            },
          ),
          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) {
              _loadFinancialData();
            },
          ),
          CloseIntent: CallbackAction<CloseIntent>(
            onInvoke: (_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: FrostedAppBar(
              scaffoldKey: main_nav.MainNavigation.scaffoldKey,
              title: 'Money',
              actions: [
          // Primary action: Add menu (iOS-aligned: 1 icon max)
          Semantics(
            label: 'Add invoice, quote, or payment',
            button: true,
            child: PopupMenuButton<String>(
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
                      case 'invoice':
                        _handleAddInvoice();
                        break;
                      case 'quote':
                        _handleAddQuote();
                        break;
                      case 'payment':
                        _handleAddPayment();
                        break;
                      case 'recurring':
                        Navigator.push(
                          context,
                          _createPageRoute(const RecurringInvoicesScreen()),
                        );
                        break;
                      case 'payment_methods':
                        Navigator.push(
                          context,
                          _createPageRoute(const PaymentMethodsScreen()),
                        );
                        break;
                      case 'filter':
                        _showFilterSheet();
                        break;
                      case 'search':
                        Navigator.push(
                          context,
                          _createPageRoute(const MoneySearchScreen()),
                        );
                        break;
                    }
                  },
                        itemBuilder: (BuildContext context) => [
                    // Primary actions first
                    const PopupMenuItem<String>(
                      value: 'invoice',
                      child: Row(
                        children: [
                          Icon(Icons.receipt, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Create Invoice'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'quote',
                      child: Row(
                        children: [
                          Icon(Icons.description, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Create Quote'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    // Secondary actions
                    const PopupMenuItem<String>(
                      value: 'payment',
                      child: Row(
                        children: [
                          Icon(Icons.payment, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Add Payment'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'recurring',
                      child: Row(
                        children: [
                          Icon(Icons.repeat, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Recurring Invoices'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'payment_methods',
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Payment Methods'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    // Utility actions
                    const PopupMenuItem<String>(
                      value: 'filter',
                      child: Row(
                        children: [
                          Icon(Icons.filter_list_outlined, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Filter'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'search',
                      child: Row(
                        children: [
                          Icon(Icons.search_outlined, size: 20),
                          SizedBox(width: SwiftleadTokens.spaceS),
                          Text('Search'),
                        ],
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
            body: _isLoading
                ? _buildLoadingState()
                : _buildContent(),
          ),
        ),
      ),
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
      _createPageRoute(const CreateEditInvoiceScreen()),
    );
  }

  void _handleAddQuote() {
    Navigator.push(
      context,
      _createPageRoute(const CreateEditQuoteScreen()),
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _customStartDate ?? DateTime.now().subtract(const Duration(days: 30)),
        end: _customEndDate ?? DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedPeriod = 'Custom';
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _applyDateRangeFilter();
      });
    }
  }

  void _showCustomDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedPeriod = 'Custom';
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _applyDateRangeFilter();
      });
    }
  }

  void _applyDateRangeFilter() {
    if (_selectedPeriod == 'Custom' && _customStartDate != null && _customEndDate != null) {
      // Filter invoices and payments by custom date range
      _filteredInvoices = _allInvoices.where((invoice) {
        // Mock: Filter by invoice date if available
        // In real app, would check invoice.created_at or invoice.due_date
        return true;
      }).toList();
    } else {
      // Apply preset period filter
      _applyInvoiceFilter();
    }
  }

  Widget _buildActiveFilterChips() {
    if (_currentMoneyFilters == null) {
      return const SizedBox.shrink();
    }

    final activeFilters = <ActiveFilter>[];

    // Type filter
    if (_currentMoneyFilters!['type'] != null && _currentMoneyFilters!['type'] != 'All') {
      activeFilters.add(ActiveFilter(
        label: 'Type',
        value: _currentMoneyFilters!['type'],
        onRemove: () {
          setState(() {
            _currentMoneyFilters!['type'] = 'All';
            if (_currentMoneyFilters!['status'] == 'All' && 
                _currentMoneyFilters!['dateRange'] == 'All') {
              _currentMoneyFilters = null;
            }
            _applyMoneyFilters(_currentMoneyFilters ?? {});
          });
        },
      ));
    }

    // Status filter
    if (_currentMoneyFilters!['status'] != null && _currentMoneyFilters!['status'] != 'All') {
      activeFilters.add(ActiveFilter(
        label: 'Status',
        value: _currentMoneyFilters!['status'],
        onRemove: () {
          setState(() {
            _currentMoneyFilters!['status'] = 'All';
            _selectedFilter = 'All';
            if (_currentMoneyFilters!['type'] == 'All' && 
                _currentMoneyFilters!['dateRange'] == 'All') {
              _currentMoneyFilters = null;
            }
            _applyMoneyFilters(_currentMoneyFilters ?? {});
          });
        },
      ));
    }

    // Date range filter
    if (_currentMoneyFilters!['dateRange'] != null && _currentMoneyFilters!['dateRange'] != 'All') {
      activeFilters.add(ActiveFilter(
        label: 'Date',
        value: _currentMoneyFilters!['dateRange'],
        onRemove: () {
          setState(() {
            _currentMoneyFilters!['dateRange'] = 'All';
            if (_currentMoneyFilters!['type'] == 'All' && 
                _currentMoneyFilters!['status'] == 'All') {
              _currentMoneyFilters = null;
            }
            _applyMoneyFilters(_currentMoneyFilters ?? {});
          });
        },
      ));
    }

    return ActiveFilterChipsRow(
      filters: activeFilters,
      onClearAll: () {
        setState(() {
          _currentMoneyFilters = null;
          _selectedFilter = 'All';
          _applyMoneyFilters({});
        });
      },
    );
  }

  Future<void> _showFilterSheet() async {
    final filters = await MoneyFilterSheet.show(
      context: context,
      initialFilters: _currentMoneyFilters,
    );
    if (filters != null) {
      _applyMoneyFilters(filters);
    } else {
      // Clear filters if cancelled
      setState(() {
        _currentMoneyFilters = null;
        _selectedFilter = 'All';
        _applyMoneyFilters({});
      });
    }
  }

  void _applyMoneyFilters(Map<String, dynamic> filters) {
    setState(() {
      // Apply type filter
      if (filters['type'] != null && filters['type'] != 'All') {
        // Filter by transaction type
        // This would filter invoices, payments, quotes based on type
      }
      
      // Apply status filter
      if (filters['status'] != null && filters['status'] != 'All') {
        _selectedFilter = filters['status'];
        _applyInvoiceFilter();
      }
      
      // Apply date range filter
      if (filters['dateRange'] != null && filters['dateRange'] != 'All') {
        final now = DateTime.now();
        DateTime? startDate;
        
        switch (filters['dateRange']) {
          case 'Today':
            startDate = DateTime(now.year, now.month, now.day);
            break;
          case 'This Week':
            startDate = now.subtract(Duration(days: now.weekday - 1));
            break;
          case 'This Month':
            startDate = DateTime(now.year, now.month, 1);
            break;
          case 'This Year':
            startDate = DateTime(now.year, 1, 1);
            break;
        }
        
        if (startDate != null) {
          _customStartDate = startDate;
          _customEndDate = now;
          _selectedPeriod = 'Custom';
          _applyDateRangeFilter();
        }
      }
    });
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
            segments: const ['Dashboard', 'Quotes & Invoices', 'Payments'],
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
              _buildQuotesInvoicesTab(), // Combined Quotes & Invoices tab
              _buildPaymentsTab(), // Payments includes Deposits
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
          // Celebration banner (if milestone reached)
          if (_celebrationMessage != null) ...[
            CelebrationBanner(
              message: _celebrationMessage!,
              onDismiss: () {
                setState(() => _celebrationMessage = null);
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
          ],
          
          // Phase 2: AI Insight Banner - Predictive insights
          if (_overdue > 0) ...[
            AIInsightBanner(
              message: 'You have £${_overdue.toStringAsFixed(0)} in overdue invoices. Consider sending payment reminders.',
              onTap: () {
                setState(() => _selectedTab = 1);
                setState(() => _selectedFilter = 'Overdue');
                _applyInvoiceFilter();
              },
              onDismiss: () {},
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ] else if (_pendingQuotesCount > 5) ...[
            AIInsightBanner(
              message: 'You have $_pendingQuotesCount pending quotes worth £${_pendingQuotesValue.toStringAsFixed(0)}. Follow up to convert them.',
              onTap: () {
                setState(() {
                  _selectedTab = 1; // Quotes & Invoices tab
                  _quotesInvoicesSubTab = 'Quotes'; // Show Quotes by default
                });
              },
              onDismiss: () {},
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
          ],
          
          // BalanceHeader - Large numeric display
          _buildBalanceHeader(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // MetricsRow - 4 key financial metrics (responsive grid on desktop)
          _buildMetricsRow(),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Analytics Metrics Section (Features 21-28)
          _buildAnalyticsMetricsSection(),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Deposits Pending Stat
          if (_depositsCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
              child: FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deposits Pending',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_depositsCount deposits',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      '£${_depositsPending.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_depositsCount > 0)
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
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await _loadFinancialData();
          },
          child: ListView(
            padding: EdgeInsets.only(
              left: SwiftleadTokens.spaceM,
              right: SwiftleadTokens.spaceM,
              top: SwiftleadTokens.spaceM,
              bottom: _isBatchMode ? 96 : 96, // Extra space for batch action bar
            ),
            children: [
              // Quick Filter Chips (Status)
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
                            // Exit batch mode when filter changes
                            if (_isBatchMode) {
                              _isBatchMode = false;
                              _selectedInvoiceIds.clear();
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              // Active Filter Chips (from filter sheet)
              if (_currentMoneyFilters != null)
                _buildActiveFilterChips(),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Batch Mode Info Banner
              if (_isBatchMode)
                InfoBanner(
                  message: '${_selectedInvoiceIds.length} invoice${_selectedInvoiceIds.length == 1 ? '' : 's'} selected',
                  type: InfoBannerType.info,
                ),
              if (_isBatchMode) const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Invoice List
              _filteredInvoices.isEmpty
                  ? EmptyStateCard(
                      title: 'No ${_selectedFilter.toLowerCase()} ${ProfessionState.config.getLabel('invoices').toLowerCase()}',
                      description: 'Invoices will appear here when they match this filter.',
                      icon: Icons.receipt_outlined,
                    )
                  : ResponsiveLayout.isDesktop(context)
                      ? _buildDesktopInvoiceGrid()
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = _filteredInvoices[index];
                        final isSelected = _selectedInvoiceIds.contains(invoice.id);
                        // Phase 3: Staggered animation
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                          child: Semantics(
                            label: _isBatchMode 
                              ? 'Invoice ${invoice.invoiceNumber}. Tap to ${isSelected ? 'deselect' : 'select'}.'
                              : 'Invoice ${invoice.invoiceNumber}. Tap to view details.',
                            child: GestureDetector(
                              onTap: () {
                                if (_isBatchMode) {
                                  // Toggle selection in batch mode
                                setState(() {
                                  if (isSelected) {
                                    _selectedInvoiceIds.remove(invoice.id);
                                    if (_selectedInvoiceIds.isEmpty) {
                                      _isBatchMode = false;
                                    }
                                  } else {
                                    _selectedInvoiceIds.add(invoice.id);
                                  }
                                });
                              } else {
                                // Normal tap - open invoice with enhanced animation
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => InvoiceDetailScreen(
                                      invoiceId: invoice.id,
                                      invoiceNumber: invoice.id,
                                    ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        )),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 300),
                                  ),
                                );
                              }
                            },
                            onLongPress: () {
                              app_haptics.HapticFeedback.medium();
                              if (!_isBatchMode) {
                                setState(() {
                                  _isBatchMode = true;
                                  _selectedInvoiceIds.add(invoice.id);
                                });
                              } else {
                                // Toggle selection
                                setState(() {
                                  if (isSelected) {
                                    _selectedInvoiceIds.remove(invoice.id);
                                    if (_selectedInvoiceIds.isEmpty) {
                                      _isBatchMode = false;
                                    }
                                  } else {
                                    _selectedInvoiceIds.add(invoice.id);
                                  }
                                });
                              }
                            },
                            onSecondaryTap: kIsWeb ? () {
                              app_haptics.HapticFeedback.medium();
                              _showInvoiceContextMenu(context, invoice);
                            } : null,
                            child: _InvoiceCard(
                              invoiceNumber: invoice.id,
                              clientName: invoice.contactName ?? '',
                              amount: invoice.amount,
                              status: invoice.status.displayName,
                              isSelected: isSelected,
                              isBatchMode: _isBatchMode,
                              onTap: () {
                                // Handled by GestureDetector
                              },
                            ),
                          ),
                          ),
                        ),
                        );
                      },
                    ),
            ],
          ),
        ),
        
        // Feature 39: Batch Action Bar
        if (_isBatchMode)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FrostedContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: SwiftleadTokens.spaceM,
                vertical: SwiftleadTokens.spaceS,
              ),
              borderRadius: 0,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Primary actions (iOS pattern: 2-3 most common)
                    _buildBatchActionButton(
                      icon: Icons.email_outlined,
                      label: 'Send Reminder',
                      onPressed: _handleBatchSendReminder,
                    ),
                    _buildBatchActionButton(
                      icon: Icons.check_circle_outline,
                      label: 'Mark Paid',
                      onPressed: _handleBatchMarkPaid,
                    ),
                    // More menu for secondary actions (iOS pattern)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'More',
                      onSelected: (value) {
                        switch (value) {
                          case 'download':
                            _handleBatchDownload();
                            break;
                          case 'delete':
                            _handleBatchDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'download',
                          child: Builder(
                            builder: (context) => Row(
                              children: [
                                const Icon(Icons.download_outlined, size: 20),
                                const SizedBox(width: SwiftleadTokens.spaceS),
                                Text(
                                  'Download',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Builder(
                            builder: (context) => Row(
                              children: [
                                const Icon(Icons.delete_outline, size: 20, color: Color(SwiftleadTokens.errorRed)),
                                const SizedBox(width: SwiftleadTokens.spaceS),
                                Text(
                                  'Delete',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(SwiftleadTokens.errorRed),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDesktopInvoiceGrid() {
    return ResponsiveGrid(
      children: _filteredInvoices.map((invoice) {
        final isSelected = _selectedInvoiceIds.contains(invoice.id);
        return GestureDetector(
          onTap: () {
            if (_isBatchMode) {
              setState(() {
                if (isSelected) {
                  _selectedInvoiceIds.remove(invoice.id);
                  if (_selectedInvoiceIds.isEmpty) {
                    _isBatchMode = false;
                  }
                } else {
                  _selectedInvoiceIds.add(invoice.id);
                }
              });
            } else {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => InvoiceDetailScreen(
                    invoiceId: invoice.id,
                    invoiceNumber: invoice.id,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            }
          },
          onLongPress: () {
            app_haptics.HapticFeedback.medium();
            if (!_isBatchMode) {
              setState(() {
                _isBatchMode = true;
                _selectedInvoiceIds.add(invoice.id);
              });
            } else {
              setState(() {
                if (isSelected) {
                  _selectedInvoiceIds.remove(invoice.id);
                  if (_selectedInvoiceIds.isEmpty) {
                    _isBatchMode = false;
                  }
                } else {
                  _selectedInvoiceIds.add(invoice.id);
                }
              });
            }
          },
          onSecondaryTap: kIsWeb ? () {
            app_haptics.HapticFeedback.medium();
            _showInvoiceContextMenu(context, invoice);
          } : null,
          child: _InvoiceCard(
            invoiceNumber: invoice.id,
            clientName: invoice.contactName ?? '',
            amount: invoice.amount,
            status: invoice.status.displayName,
            onTap: () {},
            isSelected: isSelected || _isBatchMode,
            isBatchMode: _isBatchMode,
          ),
        );
      }).toList(),
      childAspectRatio: 1.1,
      crossAxisSpacing: ResponsiveLayout.getGutter(context),
      mainAxisSpacing: ResponsiveLayout.getGutter(context),
    );
  }

  Widget _buildBatchActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SwiftleadTokens.spaceS,
          vertical: SwiftleadTokens.spaceS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDestructive 
                  ? const Color(SwiftleadTokens.errorRed)
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDestructive 
                    ? const Color(SwiftleadTokens.errorRed)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Feature 39: Batch Actions - Send Reminder
  void _handleBatchSendReminder() {
    if (_selectedInvoiceIds.isEmpty) return;
    
    final count = _selectedInvoiceIds.length;
    final invoiceIdsCopy = Set<String>.from(_selectedInvoiceIds);
    
    // TODO: Call backend API to send reminders
    setState(() {
      _isBatchMode = false;
      _selectedInvoiceIds.clear();
    });
    
    Toast.show(
      context,
      message: 'Payment reminder sent to $count client${count == 1 ? '' : 's'}',
      type: ToastType.success,
    );
  }

  // Feature 39: Batch Actions - Mark Paid
  void _handleBatchMarkPaid() {
    if (_selectedInvoiceIds.isEmpty) return;
    
    final count = _selectedInvoiceIds.length;
    final invoiceIdsCopy = Set<String>.from(_selectedInvoiceIds);
    
    // Update invoice status to paid by replacing with new Invoice objects
    setState(() {
      _allInvoices = _allInvoices.map((invoice) {
        if (invoiceIdsCopy.contains(invoice.id) && invoice.status != InvoiceStatus.paid) {
          // Create new Invoice with paid status
          return Invoice(
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
            createdAt: invoice.createdAt,
          );
        }
        return invoice;
      }).toList();
      
      _isBatchMode = false;
      _selectedInvoiceIds.clear();
      _applyInvoiceFilter();
      _loadFinancialData(); // Refresh totals
    });
    
    Toast.show(
      context,
      message: '$count invoice${count == 1 ? '' : 's'} marked as paid',
      type: ToastType.success,
    );
  }

  // Feature 39: Batch Actions - Download
  void _showInvoiceContextMenu(BuildContext context, Invoice invoice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(SwiftleadTokens.radiusCard),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Invoice'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    _createPageRoute(CreateEditInvoiceScreen(invoiceId: invoice.id)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Send Reminder'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement send reminder
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Download PDF'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement download
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_copy),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement duplicate
                },
              ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(SwiftleadTokens.errorRed)),
                title: const Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
                onTap: () {
                  Navigator.pop(context);
                  // Delete confirmed via swipe or batch mode
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBatchDownload() {
    if (_selectedInvoiceIds.isEmpty) return;
    
    final count = _selectedInvoiceIds.length;
    final invoiceIdsCopy = Set<String>.from(_selectedInvoiceIds);
    
    // TODO: Call backend API to download invoices as PDF
    setState(() {
      _isBatchMode = false;
      _selectedInvoiceIds.clear();
    });
    
    Toast.show(
      context,
      message: 'Downloading $count invoice${count == 1 ? '' : 's'}...',
      type: ToastType.info,
    );
  }

  // Feature 39: Batch Actions - Delete
  void _handleBatchDelete() {
    if (_selectedInvoiceIds.isEmpty) return;
    
    final count = _selectedInvoiceIds.length;
    final invoiceIdsCopy = Set<String>.from(_selectedInvoiceIds);
    
    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete $count ${ProfessionState.config.getLabel('invoice').toLowerCase()}${count == 1 ? '' : 's'}?',
      description: 'Are you sure you want to delete these invoices? This action cannot be undone.',
      primaryActionLabel: 'Delete',
      isDestructive: true,
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        // Remove invoices from list
        setState(() {
          _allInvoices.removeWhere((invoice) => invoiceIdsCopy.contains(invoice.id));
          _isBatchMode = false;
          _selectedInvoiceIds.clear();
          _applyInvoiceFilter();
          _loadFinancialData(); // Refresh totals
        });
        
        Toast.show(
          context,
          message: '$count invoice${count == 1 ? '' : 's'} deleted',
          type: ToastType.success,
        );
      }
    });
  }

  Widget _buildPaymentsTab() {
    // Mock deposits data - in real app would come from backend
    final deposits = [
      {
        'jobTitle': 'Bathroom Renovation',
        'clientName': 'Sarah Williams',
        'amount': 500.0,
        'status': 'Pending',
        'dueDate': DateTime.now().add(const Duration(days: 5)),
      },
      {
        'jobTitle': 'Kitchen Sink Install',
        'clientName': 'Emily Chen',
        'amount': 150.0,
        'status': 'Collected',
        'collectedDate': DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        'jobTitle': 'Heating System Installation',
        'clientName': 'David Brown',
        'amount': 2000.0,
        'status': 'Collected',
        'collectedDate': DateTime.now().subtract(const Duration(days: 28)),
      },
    ];

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
          // Payment History Section
          Text(
            'Payment History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildPaymentList(),
          
          // Deposits Section
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'Deposits',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          if (deposits.isEmpty)
            EmptyStateCard(
              title: 'No deposits yet',
              description: 'Deposits will appear here when requested',
              icon: Icons.payment,
            )
          else
            ...deposits.map((deposit) {
              Color statusColor;
              IconData statusIcon;
              switch (deposit['status']) {
                case 'Pending':
                  statusColor = const Color(SwiftleadTokens.warningYellow);
                  statusIcon = Icons.pending;
                  break;
                case 'Collected':
                  statusColor = const Color(SwiftleadTokens.successGreen);
                  statusIcon = Icons.check_circle;
                  break;
                default:
                  statusColor = Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodyMedium?.color ?? const Color(SwiftleadTokens.textSecondaryLight);
                  statusIcon = Icons.undo;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: FrostedContainer(
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
                                  deposit['jobTitle'] as String,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  deposit['clientName'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '£${(deposit['amount'] as double).toStringAsFixed(2)}',
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
                                  const SizedBox(width: 4),
                                  Text(
                                    deposit['status'] as String,
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
                      if (deposit['status'] == 'Pending' && deposit['dueDate'] != null)
                        Text(
                          'Due: ${_formatDate(deposit['dueDate'] as DateTime)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        )
                      else if (deposit['status'] == 'Collected' && deposit['collectedDate'] != null)
                        Text(
                          'Collected: ${_formatDate(deposit['collectedDate'] as DateTime)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildDepositsTab() {
    // Mock deposits data - in real app would come from backend
    final deposits = [
      {
        'jobTitle': 'Bathroom Renovation',
        'clientName': 'Sarah Williams',
        'amount': 500.0,
        'status': 'Pending',
        'dueDate': DateTime.now().add(const Duration(days: 5)),
      },
      {
        'jobTitle': 'Kitchen Sink Install',
        'clientName': 'Emily Chen',
        'amount': 150.0,
        'status': 'Collected',
        'collectedDate': DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        'jobTitle': 'Heating System Installation',
        'clientName': 'David Brown',
        'amount': 2000.0,
        'status': 'Collected',
        'collectedDate': DateTime.now().subtract(const Duration(days: 28)),
      },
    ];

    return RefreshIndicator(
      onRefresh: () async {
        await _loadFinancialData();
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // Space for nav
        ),
        children: [
          Text(
            'Deposits',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          if (deposits.isEmpty)
            EmptyStateCard(
              title: 'No deposits yet',
              description: 'Deposits will appear here when requested',
              icon: Icons.payment,
            )
          else
            ...deposits.map((deposit) {
              Color statusColor;
              IconData statusIcon;
              switch (deposit['status']) {
                case 'Pending':
                  statusColor = const Color(SwiftleadTokens.warningYellow);
                  statusIcon = Icons.pending;
                  break;
                case 'Collected':
                  statusColor = const Color(SwiftleadTokens.successGreen);
                  statusIcon = Icons.check_circle;
                  break;
                default:
                  statusColor = Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodyMedium?.color ?? const Color(SwiftleadTokens.textSecondaryLight);
                  statusIcon = Icons.undo;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: FrostedContainer(
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
                                  deposit['jobTitle'] as String,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  deposit['clientName'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '£${(deposit['amount'] as double).toStringAsFixed(2)}',
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
                                  const SizedBox(width: 4),
                                  Text(
                                    deposit['status'] as String,
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
                            deposit['status'] == 'Pending' && deposit['dueDate'] != null
                                ? 'Due: ${_formatDate(deposit['dueDate'] as DateTime)}'
                                : deposit['collectedDate'] != null
                                    ? 'Collected: ${_formatDate(deposit['collectedDate'] as DateTime)}'
                                    : 'Requested: ${_formatDate(DateTime.now())}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildQuotesInvoicesTab() {
    return Column(
      children: [
        // Sub-navigation: Quotes vs Invoices
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceS,
          ),
          child: Row(
            children: [
              Expanded(
                child: SegmentedControl(
                  segments: const ['Quotes', 'Invoices'],
                  selectedIndex: _quotesInvoicesSubTab == 'Quotes' ? 0 : 1,
                  onSelectionChanged: (index) {
                    setState(() {
                      _quotesInvoicesSubTab = index == 0 ? 'Quotes' : 'Invoices';
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        // Content based on sub-tab
        Expanded(
          child: _quotesInvoicesSubTab == 'Quotes' 
              ? _buildQuotesTab() 
              : _buildInvoicesTab(),
        ),
      ],
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
                  title: 'No ${_selectedQuoteFilter.toLowerCase()} ${ProfessionState.config.getLabel('quotes').toLowerCase()}',
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
                            _createPageRoute(QuoteDetailScreen(
                              quoteId: 'quote_${quote['index']}',
                              quoteNumber: quote['number'] as String,
                            )),
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
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
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
              // Phase 2: AnimatedCounter for total revenue
              AnimatedCounter(
                value: _totalRevenue,
                prefix: '£',
                decimals: 2,
                textStyle: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // StripeConnectionStatus
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Color(SwiftleadTokens.successGreen),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceXXS),
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
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.4),
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
    // Phase 2: Calculate previous period comparisons
    final outstandingTrend = _lastMonthRevenue > 0 
        ? ((_outstanding - (_lastMonthRevenue * 0.2)) / (_lastMonthRevenue * 0.2) * 100)
        : 0.0;
    final thisMonthTrend = _lastMonthRevenue > 0
        ? ((_thisMonthRevenue - _lastMonthRevenue) / _lastMonthRevenue * 100)
        : 0.0;
    final overdueCount = _allInvoices.where((i) => i.status == InvoiceStatus.overdue).length;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TrendTile(
                label: 'Outstanding',
                value: '£${_outstanding.toStringAsFixed(0)}',
                trend: outstandingTrend != 0 
                    ? '${outstandingTrend > 0 ? '+' : ''}${outstandingTrend.toStringAsFixed(1)}% vs last month'
                    : null,
                isPositive: outstandingTrend <= 0,
                tooltip: 'Amount not yet paid. Phase 2: Previous period comparison calculated.',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: TrendTile(
                label: 'Paid This Month',
                value: '£${_thisMonthRevenue.toStringAsFixed(0)}',
                trend: thisMonthTrend != 0
                    ? '${thisMonthTrend > 0 ? '+' : ''}${thisMonthTrend.toStringAsFixed(1)}% vs last month'
                    : null,
                isPositive: thisMonthTrend >= 0,
                tooltip: 'Total received this month vs last month (${_lastMonthRevenue.toStringAsFixed(0)})',
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
                value: '£${(_outstanding - _overdue).toStringAsFixed(0)}',
                trend: 'In processing',
                isPositive: true,
                tooltip: 'Payments in processing',
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: TrendTile(
                label: 'Overdue',
                value: '£${_overdue.toStringAsFixed(0)}',
                trend: overdueCount > 0 ? '$overdueCount invoices' : null,
                isPositive: false,
                tooltip: 'Late payments',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsMetricsSection() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics & Insights',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Feature 21: Average Invoice Value
          _buildAnalyticsRow(
            label: 'Average Invoice Value',
            value: '£${_averageInvoiceValue.toStringAsFixed(2)}',
            icon: Icons.receipt,
          ),
          const Divider(),
          // Feature 22: Days to Payment
          _buildAnalyticsRow(
            label: 'Days to Payment',
            value: '$_daysToPayment days',
            icon: Icons.schedule,
          ),
          const Divider(),
          // Feature 23: Cash Flow Projection
          _buildAnalyticsRow(
            label: 'Cash Flow Projection (30d)',
            value: '£${_cashFlowProjection.toStringAsFixed(2)}',
            icon: Icons.trending_up,
          ),
          const Divider(),
          // Feature 24: Week vs Last Week
          _buildAnalyticsRow(
            label: 'This Week vs Last Week',
            value: '£${_thisWeekRevenue.toStringAsFixed(2)}',
            subtitle: 'Last week: £${_lastWeekRevenue.toStringAsFixed(2)}',
            icon: Icons.calendar_today,
            trend: _thisWeekRevenue >= _lastWeekRevenue ? '+' : '-',
            trendValue: ((_thisWeekRevenue - _lastWeekRevenue) / _lastWeekRevenue * 100).abs().toStringAsFixed(1),
          ),
          const Divider(),
          // Feature 25: Year-to-Date
          _buildAnalyticsRow(
            label: 'Year-to-Date Revenue',
            value: '£${_yearToDateRevenue.toStringAsFixed(2)}',
            icon: Icons.calendar_month,
          ),
          const Divider(),
          // Feature 26: Average Job Value
          _buildAnalyticsRow(
            label: 'Average Job Value',
            value: '£${_averageJobValue.toStringAsFixed(2)}',
            icon: Icons.work,
          ),
          const Divider(),
          // Feature 27: Pending Quotes
          _buildAnalyticsRow(
            label: 'Pending Quotes',
            value: '£${_pendingQuotesValue.toStringAsFixed(2)}',
            subtitle: '$_pendingQuotesCount ${ProfessionState.config.getLabel('quotes').toLowerCase()}',
            icon: Icons.description,
          ),
          const Divider(),
          // Feature 28: Active Payments
          _buildAnalyticsRow(
            label: 'Active Payments',
            value: '£${_activePaymentsValue.toStringAsFixed(2)}',
            subtitle: '$_activePaymentsCount payments',
            icon: Icons.payment,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsRow({
    required String label,
    required String value,
    String? subtitle,
    IconData? icon,
    String? trend,
    String? trendValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (trend != null && trendValue != null) ...[
                Icon(
                  trend == '+' ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: trend == '+' 
                      ? const Color(SwiftleadTokens.successGreen)
                      : const Color(SwiftleadTokens.errorRed),
                ),
                const SizedBox(width: 4),
                Text(
                  '$trend$trendValue%',
                  style: TextStyle(
                    color: trend == '+' 
                        ? const Color(SwiftleadTokens.successGreen)
                        : const Color(SwiftleadTokens.errorRed),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
              ],
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
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
                  _ChartTypeButton(
                    icon: Icons.show_chart,
                    isSelected: _selectedChartType == 'line',
                    onPressed: () {
                      setState(() {
                        _selectedChartType = 'line';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _ChartTypeButton(
                    icon: Icons.bar_chart,
                    isSelected: _selectedChartType == 'bar',
                    onPressed: () {
                      setState(() {
                        _selectedChartType = 'bar';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _ChartTypeButton(
                    icon: Icons.pie_chart,
                    isSelected: _selectedChartType == 'donut',
                    onPressed: () {
                      setState(() {
                        _selectedChartType = 'donut';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // TimePeriod Selector: 7D / 30D / 90D / 1Y / All / Custom
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...['7D', '30D', '90D', '1Y', 'All'].map((period) {
                  final isSelected = period == _selectedPeriod && period != 'Custom';
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
                }),
                Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: 'Custom',
                    isSelected: _selectedPeriod == 'Custom',
                    onTap: () {
                      _showCustomDateRangePicker();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Semantics(
            label: 'Revenue chart. Tap on data points to see details.',
            child: TrendLineChart(
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
        onAction: () {
          Navigator.push(
            context,
            _createPageRoute(const CreateEditInvoiceScreen()),
          );
        },
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
                _createPageRoute(PaymentDetailScreen(
                  paymentId: payment.id,
                  paymentNumber: 'PAY-${1000 + index}',
                )),
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
                  const SizedBox(height: SwiftleadTokens.spaceXS),
                  Text(
                    clientName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceXS),
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
                const SizedBox(height: SwiftleadTokens.spaceXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
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
  final VoidCallback onPressed;
  
  const _ChartTypeButton({
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      color: isSelected
          ? const Color(SwiftleadTokens.primaryTeal)
          : Theme.of(context).textTheme.bodySmall?.color,
      onPressed: onPressed,
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final String status;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isBatchMode;

  const _InvoiceCard({
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.status,
    required this.onTap,
    this.isSelected = false,
    this.isBatchMode = false,
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
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Selection checkbox in batch mode
          if (isBatchMode) ...[
            Checkbox(
              value: isSelected,
              onChanged: null, // Handled by GestureDetector parent
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
          ],
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
                const SizedBox(height: SwiftleadTokens.spaceXS),
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
              const SizedBox(height: SwiftleadTokens.spaceXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
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
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
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
                      const SizedBox(height: SwiftleadTokens.spaceXS),
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
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
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
