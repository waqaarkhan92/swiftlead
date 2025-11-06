import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';

/// CannedResponsesScreen - Quick reply templates management
/// Exact specification from UI_Inventory_v2.5.1
class CannedResponsesScreen extends StatefulWidget {
  const CannedResponsesScreen({super.key});

  @override
  State<CannedResponsesScreen> createState() => _CannedResponsesScreenState();
}

class _CannedResponsesScreenState extends State<CannedResponsesScreen> {
  bool _isLoading = false;
  final List<_CannedResponse> _responses = [
    _CannedResponse(
      id: '1',
      title: 'Business Hours',
      content: 'We are open Monday to Friday, 9am to 5pm.',
      category: 'General',
    ),
    _CannedResponse(
      id: '2',
      title: 'Booking Confirmation',
      content: 'Thank you! Your appointment is confirmed for [DATE] at [TIME].',
      category: 'Booking',
    ),
    _CannedResponse(
      id: '3',
      title: 'Pricing Inquiry',
      content: 'Our standard rate is £150-300 depending on the service. Would you like a quote?',
      category: 'Pricing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Canned Responses',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddResponseSheet(context),
            tooltip: 'Add Response',
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
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    if (_responses.isEmpty) {
      return EmptyStateCard(
        title: 'No canned responses yet',
        description: 'Create quick reply templates to save time when responding to messages.',
        icon: Icons.message_outlined,
        actionLabel: 'Create First Response',
        onAction: () => _showAddResponseSheet(context),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Quick Reply Templates',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ..._responses.map((response) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _CannedResponseCard(
            response: response,
            onTap: () => _showEditResponseSheet(context, response),
            onDelete: () => _deleteResponse(response),
          ),
        )),
      ],
    );
  }

  void _showAddResponseSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Add Canned Response',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'e.g., Business Hours',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Category',
              hintText: 'General, Booking, Pricing, etc.',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Response Content',
              hintText: 'Enter the message template...',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Save Response',
            onPressed: () {
              Navigator.pop(context);
              // Save response
            },
          ),
        ],
      ),
    );
  }

  void _showEditResponseSheet(BuildContext context, _CannedResponse response) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Edit Canned Response',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          TextField(
            controller: TextEditingController(text: response.title),
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            controller: TextEditingController(text: response.category),
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            controller: TextEditingController(text: response.content),
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Response Content',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Update Response',
            onPressed: () {
              Navigator.pop(context);
              // Update response
            },
          ),
        ],
      ),
    );
  }

  void _deleteResponse(_CannedResponse response) {
    setState(() {
      _responses.removeWhere((r) => r.id == response.id);
    });
  }
}

class _CannedResponse {
  final String id;
  final String title;
  final String content;
  final String category;

  _CannedResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });
}

class _CannedResponseCard extends StatelessWidget {
  final _CannedResponse response;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CannedResponseCard({
    required this.response,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                        response.title,
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
                          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.4),
                        ),
                        child: Text(
                          response.category,
                          style: const TextStyle(
                            color: Color(SwiftleadTokens.primaryTeal),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              response.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

