import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Twilio Configuration Screen
/// For WhatsApp and SMS integration setup
/// Spec: Cross_Reference_Matrix_v2.5.1 Module 16
class TwilioConfigurationScreen extends StatefulWidget {
  const TwilioConfigurationScreen({super.key});

  @override
  State<TwilioConfigurationScreen> createState() => _TwilioConfigurationScreenState();
}

class _TwilioConfigurationScreenState extends State<TwilioConfigurationScreen> {
  bool _isLoading = false;
  bool _isConnected = true;
  
  final _accountSidController = TextEditingController(text: 'AC••••••••••••••••••••');
  final _authTokenController = TextEditingController(text: '••••••••••••••••••••');
  final _phoneNumberController = TextEditingController(text: '+44 20 1234 5678');

  @override
  void dispose() {
    _accountSidController.dispose();
    _authTokenController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _handleConnectDisconnect() {
    setState(() => _isConnected = !_isConnected);
    Toast.show(
      context,
      message: _isConnected ? 'Twilio connected successfully' : 'Twilio disconnected',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Twilio Configuration'),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(width: double.infinity, height: 200, borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard)),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Status Card
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: const Color(SwiftleadTokens.primaryTeal), size: 32),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Twilio Integration', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text('Configure WhatsApp & SMS', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  SwiftleadBadge.status(
                    status: _isConnected ? BadgeStatus.success : BadgeStatus.error,
                    label: _isConnected ? 'Connected' : 'Disconnected',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Configuration Form
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuration', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _accountSidController,
                decoration: const InputDecoration(
                  labelText: 'Account SID',
                  hintText: 'Enter your Twilio Account SID',
                  prefixIcon: Icon(Icons.key),
                ),
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _authTokenController,
                decoration: const InputDecoration(
                  labelText: 'Auth Token',
                  hintText: 'Enter your Twilio Auth Token',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your Twilio phone number',
                  prefixIcon: Icon(Icons.phone),
                ),
                enabled: !_isConnected,
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Connect/Disconnect Button
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: _isConnected ? 'Disconnect' : 'Connect',
            onPressed: _handleConnectDisconnect,
          ),
        ),
      ],
    );
  }
}

