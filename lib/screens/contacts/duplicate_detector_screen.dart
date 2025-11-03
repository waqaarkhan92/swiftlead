import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';
import '../../mock/mock_contacts.dart';
import '../../models/contact.dart';
import '../../widgets/forms/contact_merge_preview_modal.dart';

/// Duplicate Detector Screen - Find and merge duplicate contacts
/// Exact specification from UI_Inventory_v2.5.1
class DuplicateDetectorScreen extends StatefulWidget {
  const DuplicateDetectorScreen({super.key});

  @override
  State<DuplicateDetectorScreen> createState() => _DuplicateDetectorScreenState();
}

class _DuplicateDetectorScreenState extends State<DuplicateDetectorScreen> {
  bool _isDetecting = true;
  List<DuplicatePair> _duplicates = [];

  @override
  void initState() {
    super.initState();
    _detectDuplicates();
  }

  Future<void> _detectDuplicates() async {
    setState(() => _isDetecting = true);
    
    // Simulate duplicate detection
    await Future.delayed(const Duration(seconds: 2));
    
    final contacts = await MockContacts.fetchAll();
    
    // Mock duplicate pairs
    final duplicates = <DuplicatePair>[];
    for (int i = 0; i < contacts.length - 1; i++) {
      for (int j = i + 1; j < contacts.length; j++) {
        final c1 = contacts[i];
        final c2 = contacts[j];
        
        // Simple similarity check (name or email match)
        double confidence = 0.0;
        if (c1.name.toLowerCase() == c2.name.toLowerCase()) {
          confidence = 0.9;
        } else if (c1.email != null && c2.email != null && 
                   c1.email!.toLowerCase() == c2.email!.toLowerCase()) {
          confidence = 0.85;
        } else if (c1.phone != null && c2.phone != null && 
                   c1.phone == c2.phone) {
          confidence = 0.8;
        }
        
        if (confidence > 0.7) {
          duplicates.add(DuplicatePair(
            contact1: c1,
            contact2: c2,
            confidence: confidence,
          ));
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _duplicates = duplicates;
        _isDetecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Find Duplicates',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _detectDuplicates,
            tooltip: 'Scan Again',
          ),
        ],
      ),
      body: _isDetecting
          ? _buildLoadingState()
          : _duplicates.isEmpty
              ? _buildEmptyState()
              : _buildDuplicatesList(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              children: [
                SkeletonLoader(width: double.infinity, height: 20),
                const SizedBox(height: SwiftleadTokens.spaceS),
                SkeletonLoader(width: 200, height: 16),
                const SizedBox(height: SwiftleadTokens.spaceS),
                SkeletonLoader(width: 150, height: 16),
              ],
            ),
          ),
        )),
        const SizedBox(height: SwiftleadTokens.spaceM),
        Center(
          child: Text(
            'Analyzing contacts...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: EmptyStateCard(
        icon: Icons.check_circle_outline,
        title: 'No Duplicates Found',
        description: 'All contacts appear to be unique.',
        actionLabel: 'Scan Again',
        onAction: _detectDuplicates,
      ),
    );
  }

  Widget _buildDuplicatesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _duplicates.length,
      itemBuilder: (context, index) {
        final pair = _duplicates[index];
        return _buildDuplicateCard(pair, index);
      },
    );
  }

  Widget _buildDuplicateCard(DuplicatePair pair, int index) {
    return Dismissible(
      key: Key('duplicate_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.grey),
      ),
      onDismissed: (direction) {
        setState(() {
          _duplicates.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dismissed')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(pair.confidence).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(pair.confidence * 100).toInt()}% Match',
                      style: TextStyle(
                        color: _getConfidenceColor(pair.confidence),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showMergePreview(pair),
                    icon: const Icon(Icons.merge, size: 18),
                    label: const Text('Merge'),
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Row(
                children: [
                  Expanded(
                    child: _buildContactSummary(pair.contact1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceS),
                    child: Icon(Icons.compare_arrows, size: 24, color: Colors.grey),
                  ),
                  Expanded(
                    child: _buildContactSummary(pair.contact2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSummary(Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        if (contact.email != null) ...[
          const SizedBox(height: 4),
          Text(
            contact.email!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (contact.phone != null) ...[
          const SizedBox(height: 4),
          Text(
            contact.phone!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return const Color(SwiftleadTokens.errorRed);
    if (confidence >= 0.8) return Colors.orange;
    return const Color(SwiftleadTokens.primaryTeal);
  }

  Future<void> _showMergePreview(DuplicatePair pair) async {
    final merged = await ContactMergePreviewModal.show(
      context,
      contact1: pair.contact1,
      contact2: pair.contact2,
      confidence: pair.confidence,
    );
    
    if (merged == true) {
      setState(() {
        _duplicates.remove(pair);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts merged successfully')),
      );
    }
  }
}

class DuplicatePair {
  final Contact contact1;
  final Contact contact2;
  final double confidence;

  DuplicatePair({
    required this.contact1,
    required this.contact2,
    required this.confidence,
  });
}
