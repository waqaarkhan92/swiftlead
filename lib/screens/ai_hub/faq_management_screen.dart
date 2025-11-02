import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../theme/tokens.dart';

/// FAQ Management Screen - Manage AI FAQs
/// Exact specification from UI_Inventory_v2.5.1
class FAQManagementScreen extends StatefulWidget {
  const FAQManagementScreen({super.key});

  @override
  State<FAQManagementScreen> createState() => _FAQManagementScreenState();
}

class _FAQManagementScreenState extends State<FAQManagementScreen> {
  bool _isLoading = false;
  final List<_FAQItem> _faqs = [
    _FAQItem(
      id: '1',
      question: 'What are your business hours?',
      answer: 'We are open Monday to Friday, 9am to 5pm.',
      usageCount: 24,
    ),
    _FAQItem(
      id: '2',
      question: 'Do you offer emergency services?',
      answer: 'Yes, we offer 24/7 emergency services for urgent repairs.',
      usageCount: 18,
    ),
    _FAQItem(
      id: '3',
      question: 'What payment methods do you accept?',
      answer: 'We accept cash, card, and bank transfer payments.',
      usageCount: 12,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'FAQ Management',
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFAQSheet(context),
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add FAQ',
          style: TextStyle(color: Colors.white),
        ),
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
    if (_faqs.isEmpty) {
      return EmptyStateCard(
        title: 'No FAQs yet',
        description: 'Add your first FAQ to help AI respond to common questions.',
        icon: Icons.help_outline,
        actionLabel: 'Add First FAQ',
        onAction: () => _showAddFAQSheet(context),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        ..._faqs.map((faq) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: _FAQCard(
            faq: faq,
            onEdit: () => _showEditFAQSheet(context, faq),
            onDelete: () => _showDeleteConfirmation(context, faq),
          ),
        )),
      ],
    );
  }

  void _showAddFAQSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Add FAQ',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Question',
              hintText: 'e.g., What are your business hours?',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Answer',
              hintText: 'Enter the answer that AI should provide',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Save FAQ',
            onPressed: () {
              Navigator.pop(context);
              // Save FAQ
            },
          ),
        ],
      ),
    );
  }

  void _showEditFAQSheet(BuildContext context, _FAQItem faq) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Edit FAQ',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          TextField(
            controller: TextEditingController(text: faq.question),
            decoration: const InputDecoration(
              labelText: 'Question',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            controller: TextEditingController(text: faq.answer),
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Answer',
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Update FAQ',
            onPressed: () {
              Navigator.pop(context);
              // Update FAQ
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, _FAQItem faq) {
    SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete FAQ',
      description: 'Are you sure you want to delete "${faq.question}"?',
      primaryActionLabel: 'Delete',
      isDestructive: true,
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
    );
  }
}

class _FAQItem {
  final String id;
  final String question;
  final String answer;
  final int usageCount;

  _FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.usageCount,
  });
}

class _FAQCard extends StatelessWidget {
  final _FAQItem faq;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FAQCard({
    required this.faq,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  faq.question,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            faq.answer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceXS),
              Text(
                'Used ${faq.usageCount} times',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

