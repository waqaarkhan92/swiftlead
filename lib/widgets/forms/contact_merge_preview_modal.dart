import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../../models/contact.dart';

/// Contact Merge Preview Modal - Side-by-side merge comparison
/// Shows two contacts side-by-side with field selection for merge
class ContactMergePreviewModal extends StatefulWidget {
  final Contact contact1;
  final Contact contact2;
  final double confidence;

  const ContactMergePreviewModal({
    super.key,
    required this.contact1,
    required this.contact2,
    required this.confidence,
  });

  static Future<bool?> show(
    BuildContext context, {
    required Contact contact1,
    required Contact contact2,
    required double confidence,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContactMergePreviewModal(
        contact1: contact1,
        contact2: contact2,
        confidence: confidence,
      ),
    );
  }

  @override
  State<ContactMergePreviewModal> createState() => _ContactMergePreviewModalState();
}

class _ContactMergePreviewModalState extends State<ContactMergePreviewModal> {
  final Map<String, bool> _selectedFields = {};
  bool _isMerging = false;

  @override
  void initState() {
    super.initState();
    // Default: use contact1's data for all fields
    _selectedFields['name'] = true;
    _selectedFields['email'] = true;
    _selectedFields['phone'] = true;
    _selectedFields['company'] = true;
    _selectedFields['stage'] = true;
    _selectedFields['source'] = true;
    _selectedFields['tags'] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Merge Contacts',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Confidence badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(widget.confidence * 100).toInt()}% Match',
                      style: TextStyle(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Comparison
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildContactCard(widget.contact1, true),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    const Icon(Icons.arrow_forward, size: 32),
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Expanded(
                      child: _buildContactCard(widget.contact2, false),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            // Actions
            Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isMerging
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  PrimaryButton(
                    label: _isMerging ? 'Merging...' : 'Merge Contacts',
                    onPressed: _isMerging ? null : _mergeContacts,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact, bool isContact1) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildFieldRow('Email', contact.email ?? '—', 'email', isContact1),
          _buildFieldRow('Phone', contact.phone ?? '—', 'phone', isContact1),
          _buildFieldRow('Company', contact.company ?? '—', 'company', isContact1),
          _buildFieldRow('Stage', contact.stage.displayName, 'stage', isContact1),
          _buildFieldRow('Source', contact.source ?? '—', 'source', isContact1),
          _buildFieldRow('Tags', contact.tags.isEmpty ? '—' : contact.tags.join(', '), 'tags', isContact1),
          _buildFieldRow('Score', '${contact.score}', null, isContact1),
        ],
      ),
    );
  }

  Widget _buildFieldRow(
    String label,
    String value,
    String? fieldKey,
    bool isContact1,
  ) {
    final isSelected = fieldKey != null && _selectedFields[fieldKey] == isContact1;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          if (fieldKey != null)
            Checkbox(
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  _selectedFields[fieldKey] = checked == true ? isContact1 : !isContact1;
                });
              },
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mergeContacts() async {
    setState(() => _isMerging = true);
    
    // Simulate merge operation
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Contacts merged successfully'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Undo merge logic here
            },
          ),
        ),
      );
    }
  }
}
