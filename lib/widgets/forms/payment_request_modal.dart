import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// PaymentRequestModal - Request payment from client
/// Exact specification from Screen_Layouts_v2.5.1
class PaymentRequestModal {
  static void show({
    required BuildContext context,
    String? clientName,
    required Function(double amount, String method) onSendRequest,
  }) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedMethod = 'Stripe Link';
    DateTime? dueDate = DateTime.now().add(const Duration(days: 7));

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Request Payment',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // ClientSelector (if multiple)
            if (clientName != null) ...[
              Text(
                'Client',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          clientName[0],
                          style: const TextStyle(
                            color: Color(SwiftleadTokens.primaryTeal),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Expanded(
                      child: Text(
                        clientName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
            ],

            // AmountField
            Text(
              'Amount',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '£ ',
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['£50', '£100', '£150', '£200'].map((suggestion) {
                return SwiftleadChip(
                  label: suggestion,
                  isSelected: false,
                  onTap: () {
                    amountController.text = suggestion.replaceAll('£', '');
                    setState(() {});
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // DescriptionField
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'What is this payment for?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // DueDatePicker
            Text(
              'Due Date',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                dueDate != null
                    ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                    : 'Select date',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() => dueDate = picked);
                }
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // PaymentMethodChips
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ['Stripe Link', 'Cash', 'Bank Transfer'].map((method) {
                final isSelected = selectedMethod == method;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedMethod = method);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceM,
                      vertical: SwiftleadTokens.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                    ),
                    child: Text(
                      method,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // SendButton
            PrimaryButton(
              label: 'Send Request',
              onPressed: amountController.text.isNotEmpty
                  ? () {
                      final amount = double.tryParse(amountController.text) ?? 0.0;
                      Navigator.pop(context);
                      onSendRequest(amount, selectedMethod);
                    }
                  : null,
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }
}

