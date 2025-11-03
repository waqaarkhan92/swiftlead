import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// Account Deletion Screen - Multi-step deletion flow
/// Exact specification from UI_Inventory_v2.5.1
class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  int _currentStep = 0;
  bool _acknowledgeDataLoss = false;
  bool _acknowledgeIrreversible = false;
  bool _acknowledgeBackup = false;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Delete Account',
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _canProceed() ? _nextStep : null,
        onStepCancel: _currentStep > 0 ? _previousStep : null,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: SwiftleadTokens.spaceM),
            child: Row(
              children: [
                if (details.stepIndex > 0)
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                if (details.stepIndex > 0)
                  const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: PrimaryButton(
                    label: _currentStep == 2 ? 'Delete Account' : 'Continue',
                    onPressed: _canProceed() ? details.onStepContinue : null,
                    icon: _currentStep == 2 ? Icons.delete_forever : Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          _buildStep1(),
          _buildStep2(),
          _buildStep3(),
        ],
      ),
    );
  }

  Step _buildStep1() {
    return Step(
      title: const Text('Understand the Consequences'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: const Color(SwiftleadTokens.errorRed),
                      size: 32,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Expanded(
                      child: Text(
                        'This action cannot be undone',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(SwiftleadTokens.errorRed),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Deleting your account will permanently:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _WarningItem(text: 'Delete all your contacts, jobs, and invoices'),
                _WarningItem(text: 'Remove all messages and conversations'),
                _WarningItem(text: 'Cancel all active bookings and subscriptions'),
                _WarningItem(text: 'Delete all settings and preferences'),
                _WarningItem(text: 'Permanently remove all associated data'),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          CheckboxListTile(
            title: const Text('I understand that all my data will be permanently deleted'),
            value: _acknowledgeDataLoss,
            onChanged: (value) {
              setState(() {
                _acknowledgeDataLoss = value ?? false;
              });
            },
            activeColor: const Color(SwiftleadTokens.primaryTeal),
          ),
          CheckboxListTile(
            title: const Text('I understand this action is irreversible'),
            value: _acknowledgeIrreversible,
            onChanged: (value) {
              setState(() {
                _acknowledgeIrreversible = value ?? false;
              });
            },
            activeColor: const Color(SwiftleadTokens.primaryTeal),
          ),
          CheckboxListTile(
            title: const Text('I have backed up any data I want to keep'),
            value: _acknowledgeBackup,
            onChanged: (value) {
              setState(() {
                _acknowledgeBackup = value ?? false;
              });
            },
            activeColor: const Color(SwiftleadTokens.primaryTeal),
          ),
        ],
      ),
    );
  }

  Step _buildStep2() {
    return Step(
      title: const Text('Tell Us Why'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help us improve by sharing why you\'re leaving (optional)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            controller: _reasonController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Please share your feedback...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Step _buildStep3() {
    return Step(
      title: const Text('Confirm Deletion'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Final Confirmation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(SwiftleadTokens.errorRed),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'To confirm account deletion, please enter your password:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _acknowledgeDataLoss && _acknowledgeIrreversible && _acknowledgeBackup;
      case 1:
        return true; // Reason is optional
      case 2:
        return _passwordController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmDeletion();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _confirmDeletion() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete Account Forever?',
      description: 'This is your last chance. Your account and all data will be permanently deleted and cannot be recovered.',
      primaryActionLabel: 'Delete Forever',
      secondaryActionLabel: 'Cancel',
      icon: Icons.delete_forever,
      isDestructive: true,
    );

    if (confirmed == true) {
      // TODO: Implement actual account deletion
      Toast.show(
        context,
        message: 'Account deletion request submitted',
        type: ToastType.success,
      );
      
      // Navigate back or to login
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

class _WarningItem extends StatelessWidget {
  final String text;

  const _WarningItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.close,
            size: 16,
            color: const Color(SwiftleadTokens.errorRed),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

