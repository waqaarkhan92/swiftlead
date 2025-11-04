import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import 'create_edit_booking_screen.dart';

/// Booking Templates Screen - Manage saved booking templates
/// v2.5.1 Enhancement: Pre-configure common booking scenarios
class BookingTemplatesScreen extends StatefulWidget {
  const BookingTemplatesScreen({super.key});

  @override
  State<BookingTemplatesScreen> createState() => _BookingTemplatesScreenState();
}

class _BookingTemplatesScreenState extends State<BookingTemplatesScreen> {
  // Mock templates data
  List<BookingTemplate> _templates = [
    BookingTemplate(
      id: '1',
      name: '60-min Consultation',
      serviceName: 'Consultation',
      duration: 60,
      price: 75.0,
      notes: 'Initial client consultation',
    ),
    BookingTemplate(
      id: '2',
      name: 'Annual Service',
      serviceName: 'Annual Service',
      duration: 120,
      price: 150.0,
      notes: 'Annual maintenance check',
    ),
    BookingTemplate(
      id: '3',
      name: 'Emergency Visit',
      serviceName: 'Emergency Repair',
      duration: 90,
      price: 200.0,
      notes: 'Emergency call-out',
      requiresDeposit: true,
      depositAmount: 100.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Booking Templates',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Template',
            onPressed: () => _showCreateTemplateDialog(),
          ),
        ],
      ),
      body: _templates.isEmpty
          ? EmptyStateCard(
              title: 'No templates yet',
              description: 'Create booking templates to speed up your booking process',
              icon: Icons.event_note_outlined,
              actionLabel: 'Create Template',
              onAction: () => _showCreateTemplateDialog(),
            )
          : ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: [
                ..._templates.map((template) => Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
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
                                        template.name,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: SwiftleadTokens.spaceXS),
                                      Text(
                                        template.serviceName,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showEditTemplateDialog(template);
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmDialog(template);
                                    } else if (value == 'use') {
                                      _useTemplate(template);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'use',
                                      child: Row(
                                        children: [
                                          Icon(Icons.play_arrow, size: 20),
                                          SizedBox(width: SwiftleadTokens.spaceS),
                                          Text('Use Template'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: SwiftleadTokens.spaceS),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Color(SwiftleadTokens.errorRed), size: 20),
                                          SizedBox(width: SwiftleadTokens.spaceS),
                                          Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: SwiftleadTokens.spaceM),
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.schedule,
                                  '${template.duration} min',
                                ),
                                const SizedBox(width: SwiftleadTokens.spaceS),
                                _buildInfoChip(
                                  Icons.attach_money,
                                  '£${template.price.toStringAsFixed(2)}',
                                ),
                                if (template.requiresDeposit)
                                  Padding(
                                    padding: const EdgeInsets.only(left: SwiftleadTokens.spaceS),
                                    child: _buildInfoChip(
                                      Icons.payment,
                                      'Deposit: £${template.depositAmount?.toStringAsFixed(2)}',
                                    ),
                                  ),
                              ],
                            ),
                            if (template.notes != null && template.notes!.isNotEmpty) ...[
                              const SizedBox(height: SwiftleadTokens.spaceS),
                              Text(
                                template.notes!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(SwiftleadTokens.textSecondaryLight),
                                ),
                              ),
                            ],
                            const SizedBox(height: SwiftleadTokens.spaceM),
                            PrimaryButton(
                              label: 'Use Template',
                              icon: Icons.play_arrow,
                              onPressed: () => _useTemplate(template),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(SwiftleadTokens.primaryTeal)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(SwiftleadTokens.primaryTeal),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _useTemplate(BookingTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditBookingScreen(
          initialData: {
            'clientName': '',
            'serviceName': template.serviceName,
            'duration': template.duration,
            'price': template.price,
            'notes': template.notes ?? '',
            'requiresDeposit': template.requiresDeposit,
            'depositAmount': template.depositAmount,
            'templateId': template.id,
          },
        ),
      ),
    );
  }

  void _showCreateTemplateDialog() {
    final nameController = TextEditingController();
    final serviceController = TextEditingController();
    final durationController = TextEditingController(text: '60');
    final priceController = TextEditingController(text: '0');
    final notesController = TextEditingController();
    bool requiresDeposit = false;
    final depositController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Booking Template'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Template Name',
                    hintText: 'e.g., 60-min Consultation',
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: serviceController,
                  decoration: const InputDecoration(
                    labelText: 'Service Name',
                    hintText: 'e.g., Consultation',
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (£)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                SwitchListTile(
                  title: const Text('Requires Deposit'),
                  value: requiresDeposit,
                  onChanged: (value) => setState(() => requiresDeposit = value),
                ),
                if (requiresDeposit) ...[
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    controller: depositController,
                    decoration: const InputDecoration(
                      labelText: 'Deposit Amount (£)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: 'Create',
              onPressed: () {
                if (nameController.text.isEmpty || serviceController.text.isEmpty) {
                  Toast.show(
                    context,
                    message: 'Please fill in template name and service name',
                    type: ToastType.error,
                  );
                  return;
                }
                final template = BookingTemplate(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  serviceName: serviceController.text,
                  duration: int.tryParse(durationController.text) ?? 60,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  notes: notesController.text.isEmpty ? null : notesController.text,
                  requiresDeposit: requiresDeposit,
                  depositAmount: requiresDeposit ? (double.tryParse(depositController.text) ?? 0.0) : null,
                );
                setState(() {
                  _templates.add(template);
                });
                Navigator.pop(context);
                Toast.show(
                  context,
                  message: 'Template created',
                  type: ToastType.success,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTemplateDialog(BookingTemplate template) {
    // Similar to create, but pre-populate fields
    // Implementation similar to _showCreateTemplateDialog
    Toast.show(
      context,
      message: 'Edit template functionality (mock)',
      type: ToastType.info,
    );
  }

  void _showDeleteConfirmDialog(BookingTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _templates.removeWhere((t) => t.id == template.id);
              });
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Template deleted',
                type: ToastType.success,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Color(SwiftleadTokens.errorRed))),
          ),
        ],
      ),
    );
  }
}

class BookingTemplate {
  final String id;
  final String name;
  final String serviceName;
  final int duration; // minutes
  final double price;
  final String? notes;
  final bool requiresDeposit;
  final double? depositAmount;

  BookingTemplate({
    required this.id,
    required this.name,
    required this.serviceName,
    required this.duration,
    required this.price,
    this.notes,
    this.requiresDeposit = false,
    this.depositAmount,
  });
}

