import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';
import 'quote_detail_screen.dart';
import 'create_edit_quote_screen.dart';

/// Quotes Screen - Quote list and management
/// Exact specification from UI_Inventory_v2.5.1 and Cross_Reference_Matrix_v2.5.1
class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Quotes',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateQuoteSheet(context),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateQuoteSheet(context),
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 120,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    final hasQuotes = true; // Replace with actual data check

    if (!hasQuotes) {
      return EmptyStateCard(
        title: 'No quotes yet',
        description: 'Create your first quote to send to clients.',
        icon: Icons.description_outlined,
        actionLabel: 'Create Quote',
        onAction: () => _showCreateQuoteSheet(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Draft', 'Sent', 'Viewed', 'Accepted', 'Declined', 'Expired'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                  child: SwiftleadChip(
                    label: filter,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Quotes List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8, // Example
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: _QuoteCard(
                quoteNumber: 'QUO-${1000 + index}',
                clientName: _getClientName(index),
                service: _getService(index),
                amount: _getAmount(index),
                status: _getStatus(index),
                validUntil: DateTime.now().add(Duration(days: 7 - index)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuoteDetailScreen(
                        quoteId: 'quote_$index',
                        quoteNumber: 'QUO-${1000 + index}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Filter Quotes',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Filter options:\n- Status\n- Date Range\n- Amount Range\n- Client',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showCreateQuoteSheet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEditQuoteScreen(),
      ),
    );
  }

  String _getClientName(int index) {
    final names = ['John Smith', 'Sarah Williams', 'Mike Johnson', 'Emily Davis'];
    return names[index % names.length];
  }

  String _getService(int index) {
    final services = ['Kitchen Sink Repair', 'Bathroom Installation', 'Heating Repair', 'Electrical Work'];
    return services[index % services.length];
  }

  double _getAmount(int index) {
    return 200.0 + (index * 100.0);
  }

  String _getStatus(int index) {
    final statuses = ['Draft', 'Sent', 'Viewed', 'Accepted', 'Declined'];
    return statuses[index % statuses.length];
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

