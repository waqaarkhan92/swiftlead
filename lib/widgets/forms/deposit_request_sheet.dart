import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// DepositRequestSheet - Request deposit for job/booking
/// Exact specification from Screen_Layouts_v2.5.1
class DepositRequestSheet {
  static void show({
    required BuildContext context,
    String? jobId,
    String? jobTitle,
    double? jobAmount,
    Function(double amount, DateTime dueDate, String? message)? onSend,
  }) {
    double depositAmount = 0.0;
    bool usePercentage = true;
    double depositPercentage = 50.0;
    final TextEditingController messageController = TextEditingController();
    DateTime? dueDate = DateTime.now().add(const Duration(days: 7));
    bool paymentLinkEnabled = true;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Request Deposit',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Job Link (if provided)
            if (jobTitle != null) ...[
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    const Icon(
                      Icons.build,
                      size: 20,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            jobTitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (jobAmount != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Total: £${jobAmount!.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Deposit Amount Toggle
            Text(
              'Deposit Amount',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        usePercentage = true;
                        if (jobAmount != null) {
                          depositAmount = jobAmount! * (depositPercentage / 100);
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: usePercentage
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: usePercentage
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Colors.grey,
                      ),
                    ),
                    child: const Text('Percentage'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        usePercentage = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !usePercentage
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: !usePercentage
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Colors.grey,
                      ),
                    ),
                    child: const Text('Fixed Amount'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Amount Input
            if (usePercentage)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deposit Percentage',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Slider(
                    value: depositPercentage,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${depositPercentage.toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() {
                        depositPercentage = value;
                        if (jobAmount != null) {
                          depositAmount = jobAmount! * (value / 100);
                        }
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${depositPercentage.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                      Text(
                        '100%',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (jobAmount != null) ...[
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Text(
                      'Amount: £${depositAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              )
            else
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Deposit Amount',
                  prefixText: '£',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
                onChanged: (value) {
                  depositAmount = double.tryParse(value) ?? 0.0;
                },
              ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Due Date Picker
            Text(
              'Due Date',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    dueDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dueDate != null
                    ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                    : 'Select Due Date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Payment Link Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-generate Payment Link',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create Stripe payment link automatically',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: paymentLinkEnabled,
                    onChanged: (value) {
                      setState(() {
                        paymentLinkEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Message Preview
            Text(
              'Message (Optional)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a custom message to the deposit request...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Send Button
            PrimaryButton(
              label: 'Send Deposit Request',
              onPressed: () {
                if (dueDate != null) {
                  onSend?.call(
                    depositAmount,
                    dueDate!,
                    messageController.text.isEmpty ? null : messageController.text,
                  );
                  Navigator.pop(context);
                }
              },
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }
}

