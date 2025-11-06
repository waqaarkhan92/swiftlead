import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/search_bar.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';
import '../../models/payment.dart';
import '../../mock/mock_repository.dart';
import '../../mock/mock_payments.dart';
import '../../config/mock_config.dart';
import 'invoice_detail_screen.dart';
import 'payment_detail_screen.dart';

/// MoneySearchScreen - Search invoices and payments
/// Exact specification from UI_Inventory_v2.5.1
class MoneySearchScreen extends StatefulWidget {
  const MoneySearchScreen({super.key});

  @override
  State<MoneySearchScreen> createState() => _MoneySearchScreenState();
}

class _MoneySearchScreenState extends State<MoneySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Payment> _searchResults = [];
  List<Payment> _allPayments = [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    if (kUseMockData) {
      final payments = await MockPayments.fetchAllPayments();
      if (mounted) {
        setState(() {
          _allPayments = payments;
        });
      }
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    // Load invoices too for comprehensive search
    List<Invoice> invoices = [];
    if (kUseMockData) {
      invoices = await MockPayments.fetchAllInvoices();
    }

    setState(() {
      _isSearching = true;
      
      // Search in payments
      final paymentResults = _allPayments.where((payment) {
        return payment.contactName.toLowerCase().contains(query.toLowerCase()) ||
            payment.id.toLowerCase().contains(query.toLowerCase());
      }).toList();
      
      // Search in invoices and convert to Payment-like results
      final invoiceResults = invoices.where((invoice) {
        return (invoice.contactName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            invoice.id.toLowerCase().contains(query.toLowerCase()) ||
            (invoice.serviceDescription?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
      
      // Combine results - use payments directly, create payment-like objects from invoices
      _searchResults = List.from(paymentResults);
      // Add invoice results as payments (for display purposes)
      for (final invoice in invoiceResults) {
        _searchResults.add(Payment(
          id: invoice.id,
          invoiceId: invoice.id,
          amount: invoice.amount,
          method: PaymentMethod.other,
          status: invoice.status == InvoiceStatus.paid 
              ? PaymentStatus.completed 
              : PaymentStatus.pending,
          timestamp: invoice.createdAt,
          contactName: invoice.contactName ?? '',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Search Payments',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // SearchBar
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: SwiftleadSearchBar(
              controller: _searchController,
              hintText: 'Search invoices, payments, or clients...',
              onChanged: _performSearch,
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? _searchResults.isNotEmpty
                    ? _buildSearchResults()
                    : _buildEmptyState()
                : _buildSearchTips(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTips() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Search Tips',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        _TipItem(
          icon: Icons.search,
          tip: 'Search by invoice number or client name',
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        _TipItem(
          icon: Icons.payment,
          tip: 'Search by payment amount or method',
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final payment = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: payment.status == PaymentStatus.completed
                  ? const Color(SwiftleadTokens.successGreen)
                  : const Color(SwiftleadTokens.warningYellow),
              child: Icon(
                payment.status == PaymentStatus.completed
                    ? Icons.check
                    : Icons.pending,
                color: Theme.of(context).cardColor,
              ),
            ),
            title: Text(payment.contactName),
            subtitle: Text(
              'Invoice ${payment.invoiceId}',
            ),
            trailing: Text(
              '£${payment.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              // Fetch invoice to get invoice number
              Invoice? invoice;
              if (kUseMockData) {
                invoice = await MockPayments.fetchInvoiceById(payment.invoiceId);
              }
              
              if (invoice != null) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => InvoiceDetailScreen(
                        invoiceId: payment.invoiceId,
                        invoiceNumber: invoice!.id,
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
                    ),
                );
              } else {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => PaymentDetailScreen(
                        paymentId: payment.id,
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
                    ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateCard(
      title: 'No results found',
      description: 'Try different keywords or check your spelling.',
      icon: Icons.search_off,
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String tip;

  const _TipItem({
    required this.icon,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
        ),
        const SizedBox(width: SwiftleadTokens.spaceM),
        Expanded(
          child: Text(
            tip,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

