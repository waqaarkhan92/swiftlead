import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';


/// Contact Import Results Screen - Dedicated results screen with undo
/// Exact specification from UI_Inventory_v2.5.1
class ContactImportResultsScreen extends StatefulWidget {
  final String importJobId;
  final int successCount;
  final int errorCount;
  final List<ImportError> errors;

  const ContactImportResultsScreen({
    super.key,
    required this.importJobId,
    required this.successCount,
    required this.errorCount,
    required this.errors,
  });

  @override
  State<ContactImportResultsScreen> createState() => _ContactImportResultsScreenState();
}

class _ContactImportResultsScreenState extends State<ContactImportResultsScreen> {
  bool _canUndo = true; // Can undo if import is <24h old
  bool _isUndoing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Import Results',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Summary Card
          _buildSummaryCard(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Actions
          if (_canUndo) _buildUndoButton(),
          if (_canUndo) const SizedBox(height: SwiftleadTokens.spaceM),
          
          PrimaryButton(
            label: 'View Contacts',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigate to contacts screen
            },
            icon: Icons.people_outline,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Error List
          if (widget.errorCount > 0) _buildErrorList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import Complete',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Success',
                  '${widget.successCount}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: _buildStatCard(
                  'Errors',
                  '${widget.errorCount}',
                  Icons.error_outline,
                  Colors.orange,
                ),
              ),
            ],
          ),
          if (widget.errorCount > 0) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            OutlinedButton.icon(
              onPressed: _downloadErrorReport,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Error Report'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildUndoButton() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.undo,
                size: 20,
                color: Colors.orange,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Undo Import',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'You can undo this import within 24 hours. This will remove all imported contacts.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          OutlinedButton.icon(
            onPressed: _isUndoing ? null : _undoImport,
            icon: _isUndoing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.undo, size: 18),
            label: Text(_isUndoing ? 'Undoing...' : 'Undo Import'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorList() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Import Errors',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          ...widget.errors.take(10).map((error) => Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Row ${error.rowNumber}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        error.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          if (widget.errors.length > 10)
            Padding(
              padding: const EdgeInsets.only(top: SwiftleadTokens.spaceS),
              child: Text(
                'And ${widget.errors.length - 10} more errors...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _undoImport() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Undo Import?'),
        content: Text(
          'This will remove all ${widget.successCount} imported contacts. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Undo Import'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isUndoing = true);

    // Simulate undo operation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import undone successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  void _downloadErrorReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error report downloaded')),
    );
  }
}

class ImportError {
  final int rowNumber;
  final String message;
  final String? field;

  ImportError({
    required this.rowNumber,
    required this.message,
    this.field,
  });
}
