import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/confirmation_dialog.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';
import '../global/bottom_sheet.dart';
import 'package:flutter/services.dart';

/// Convert Quote Modal - Convert quote to job or invoice
/// Exact specification from UI_Inventory_v2.5.1
class ConvertQuoteModal {
  static void show({
    required BuildContext context,
    required String quoteId,
    required String quoteNumber,
    required String clientName,
    required double amount,
    Function(String conversionType)? onConverted,
  }) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Convert Quote',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Quote Info
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quote #$quoteNumber',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$clientName • £${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          Text(
            'Convert to:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Convert to Job
          _ConvertOption(
            icon: Icons.work_outline,
            title: 'Convert to Job',
            description: 'Create a new job from this quote',
            onTap: () {
              _convertQuote(
                context: context,
                quoteId: quoteId,
                conversionType: 'job',
                onConverted: onConverted,
              );
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),

          // Convert to Invoice
          _ConvertOption(
            icon: Icons.receipt_outlined,
            title: 'Convert to Invoice',
            description: 'Create an invoice from this quote',
            onTap: () {
              _convertQuote(
                context: context,
                quoteId: quoteId,
                conversionType: 'invoice',
                onConverted: onConverted,
              );
            },
          ),
        ],
      ),
    );
  }

  static Future<void> _convertQuote({
    required BuildContext context,
    required String quoteId,
    required String conversionType,
    Function(String)? onConverted,
  }) async {
    bool isConverting = false;

    // Show confirmation
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Convert Quote to ${conversionType == 'job' ? 'Job' : 'Invoice'}?',
      description: 'This will create a new ${conversionType == 'job' ? 'job' : 'invoice'} from the quote. The quote will remain unchanged.',
      icon: conversionType == 'job' ? Icons.work_outline : Icons.receipt_outlined,
      isDestructive: false,
      primaryActionLabel: 'Yes, Convert',
    );

    if (confirmed != true) return;

    // Show converting dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          if (!isConverting) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isConverting = true;
              });
            });
          }

          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isConverting) ...[
                  const SwiftleadProgressBar(),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Text(
                    'Converting quote...',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Navigator.pop(context); // Close converting dialog
        Navigator.pop(context); // Close convert modal
        
        HapticFeedback.mediumImpact();
        Toast.show(
          context,
          message: 'Quote converted to ${conversionType == 'job' ? 'job' : 'invoice'}',
          type: ToastType.success,
        );
        onConverted?.call(conversionType);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close converting dialog
        Toast.show(
          context,
          message: 'Failed to convert quote',
          type: ToastType.error,
        );
      }
    }
  }
}

class _ConvertOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ConvertOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Icon(
                icon,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

