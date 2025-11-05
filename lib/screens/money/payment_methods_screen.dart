import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// PaymentMethodsScreen - Manage payment methods
/// Exact specification from UI_Inventory_v2.5.1
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<_PaymentMethod> _paymentMethods = [
    _PaymentMethod(
      id: '1',
      type: PaymentMethodType.card,
      last4: '4242',
      expiryMonth: 12,
      expiryYear: 2025,
      isDefault: true,
      holderName: 'Alex Johnson',
    ),
    _PaymentMethod(
      id: '2',
      type: PaymentMethodType.bankAccount,
      last4: '1234',
      isDefault: false,
      holderName: 'Alex Johnson',
      bankName: 'HSBC',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Payment Methods',
      ),
      body: _paymentMethods.isEmpty
          ? EmptyStateCard(
              title: 'No Payment Methods',
              description: 'Add a payment method to receive payments faster.',
              icon: Icons.payment,
              actionLabel: 'Add Payment Method',
              onAction: _showAddPaymentMethod,
            )
          : ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: [
                ..._paymentMethods.map((method) => Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                      child: _PaymentMethodCard(
                        method: method,
                        onSetDefault: () {
                          setState(() {
                            for (var m in _paymentMethods) {
                              m.isDefault = m.id == method.id;
                            }
                          });
                          Toast.show(
                            context,
                            message: 'Default payment method updated',
                            type: ToastType.success,
                          );
                        },
                        onDelete: () async {
                          final confirmed = await SwiftleadConfirmationDialog.show(
                            context: context,
                            title: 'Remove Payment Method',
                            description:
                                'Are you sure you want to remove this payment method?',
                            primaryActionLabel: 'Remove',
                            secondaryActionLabel: 'Cancel',
                            isDestructive: true,
                          );
                          if (confirmed == true) {
                            setState(() {
                              _paymentMethods.removeWhere((m) => m.id == method.id);
                            });
                            Toast.show(
                              context,
                              message: 'Payment method removed',
                              type: ToastType.success,
                            );
                          }
                        },
                      ),
                    )),
                const SizedBox(height: SwiftleadTokens.spaceL),
                PrimaryButton(
                  label: 'Add Payment Method',
                  onPressed: _showAddPaymentMethod,
                  icon: Icons.add,
                ),
              ],
            ),
    );
  }

  void _showAddPaymentMethod() {
    String selectedType = 'Card';
    final cardNumberController = TextEditingController();
    final expiryMonthController = TextEditingController();
    final expiryYearController = TextEditingController();
    final cvvController = TextEditingController();
    final holderNameController = TextEditingController();
    final accountNumberController = TextEditingController();
    final sortCodeController = TextEditingController();
    final bankNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Payment Method'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Method Type',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Card'),
                        selected: selectedType == 'Card',
                        onSelected: (selected) {
                          setState(() {
                            selectedType = 'Card';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Bank Account'),
                        selected: selectedType == 'Bank Account',
                        onSelected: (selected) {
                          setState(() {
                            selectedType = 'Bank Account';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                if (selectedType == 'Card') ...[
                  TextField(
                    controller: cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '1234 5678 9012 3456',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryMonthController,
                          decoration: InputDecoration(
                            labelText: 'MM',
                            hintText: '12',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: TextField(
                          controller: expiryYearController,
                          decoration: InputDecoration(
                            labelText: 'YYYY',
                            hintText: '2025',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    controller: holderNameController,
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: bankNameController,
                    decoration: InputDecoration(
                      labelText: 'Bank Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    controller: accountNumberController,
                    decoration: InputDecoration(
                      labelText: 'Account Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    controller: sortCodeController,
                    decoration: InputDecoration(
                      labelText: 'Sort Code',
                      hintText: '12-34-56',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextField(
                    controller: holderNameController,
                    decoration: InputDecoration(
                      labelText: 'Account Holder Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedType == 'Card') {
                  final cardNumber = cardNumberController.text.replaceAll(' ', '');
                  if (cardNumber.length >= 4) {
                    final last4 = cardNumber.substring(cardNumber.length - 4);
                    setState(() {
                      _paymentMethods.add(
                        _PaymentMethod(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: PaymentMethodType.card,
                          last4: last4,
                          expiryMonth: int.tryParse(expiryMonthController.text),
                          expiryYear: int.tryParse(expiryYearController.text),
                          isDefault: _paymentMethods.isEmpty,
                          holderName: holderNameController.text.isNotEmpty
                              ? holderNameController.text
                              : 'Cardholder',
                        ),
                      );
                    });
                    Navigator.pop(context);
                    Toast.show(
                      context,
                      message: 'Payment method added',
                      type: ToastType.success,
                    );
                  }
                } else {
                  final accountNumber = accountNumberController.text;
                  if (accountNumber.length >= 4) {
                    final last4 = accountNumber.substring(accountNumber.length - 4);
                    setState(() {
                      _paymentMethods.add(
                        _PaymentMethod(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: PaymentMethodType.bankAccount,
                          last4: last4,
                          isDefault: _paymentMethods.isEmpty,
                          holderName: holderNameController.text.isNotEmpty
                              ? holderNameController.text
                              : 'Account Holder',
                          bankName: bankNameController.text.isNotEmpty
                              ? bankNameController.text
                              : 'Bank',
                        ),
                      );
                    });
                    Navigator.pop(context);
                    Toast.show(
                      context,
                      message: 'Bank account added',
                      type: ToastType.success,
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

enum PaymentMethodType { card, bankAccount }

class _PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String last4;
  final int? expiryMonth;
  final int? expiryYear;
  bool isDefault;
  final String holderName;
  final String? bankName;

  _PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    this.expiryMonth,
    this.expiryYear,
    required this.isDefault,
    required this.holderName,
    this.bankName,
  });
}

class _PaymentMethodCard extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _PaymentMethodCard({
    required this.method,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                method.type == PaymentMethodType.card
                    ? Icons.credit_card
                    : Icons.account_balance,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.type == PaymentMethodType.card
                          ? 'Card ending in ${method.last4}'
                          : '${method.bankName} •••• ${method.last4}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (method.type == PaymentMethodType.card &&
                        method.expiryMonth != null &&
                        method.expiryYear != null)
                      Text(
                        'Expires ${method.expiryMonth.toString().padLeft(2, '0')}/${method.expiryYear}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    Text(
                      method.holderName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (method.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                  ),
                  child: Text(
                    'Default',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'set_default':
                      if (!method.isDefault) onSetDefault();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!method.isDefault)
                    const PopupMenuItem(
                      value: 'set_default',
                      child: Text('Set as Default'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

