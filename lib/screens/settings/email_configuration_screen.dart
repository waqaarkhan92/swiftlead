import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Email Configuration Screen
/// For IMAP/SMTP email integration setup
/// Spec: Cross_Reference_Matrix_v2.5.1 Module 16
class EmailConfigurationScreen extends StatefulWidget {
  const EmailConfigurationScreen({super.key});

  @override
  State<EmailConfigurationScreen> createState() => _EmailConfigurationScreenState();
}

class _EmailConfigurationScreenState extends State<EmailConfigurationScreen> {
  bool _isLoading = false;
  bool _isConnected = false;
  
  final _emailController = TextEditingController(text: 'hello@abcplumbing.co.uk');
  final _imapHostController = TextEditingController(text: 'imap.gmail.com');
  final _imapPortController = TextEditingController(text: '993');
  final _smtpHostController = TextEditingController(text: 'smtp.gmail.com');
  final _smtpPortController = TextEditingController(text: '587');
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _imapHostController.dispose();
    _imapPortController.dispose();
    _smtpHostController.dispose();
    _smtpPortController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleConnectDisconnect() {
    setState(() => _isConnected = !_isConnected);
    Toast.show(
      context,
      message: _isConnected ? 'Email configured successfully' : 'Email configuration removed',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(title: 'Email Configuration'),
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
                  Icon(Icons.email, color: const Color(SwiftleadTokens.primaryTeal), size: 32),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IMAP/SMTP Email', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: SwiftleadTokens.spaceXS),
                        Text('Configure email inbox integration', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  SwiftleadBadge.status(
                    status: _isConnected ? BadgeStatus.success : BadgeStatus.error,
                    label: _isConnected ? 'Connected' : 'Not Configured',
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
              Text('Email Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your-email@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your email password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              Text('IMAP Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _imapHostController,
                decoration: const InputDecoration(
                  labelText: 'IMAP Host',
                  hintText: 'imap.example.com',
                  prefixIcon: Icon(Icons.download_outlined),
                ),
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _imapPortController,
                decoration: const InputDecoration(
                  labelText: 'IMAP Port',
                  hintText: '993',
                  prefixIcon: Icon(Icons.numbers),
                ),
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              Text('SMTP Settings', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _smtpHostController,
                decoration: const InputDecoration(
                  labelText: 'SMTP Host',
                  hintText: 'smtp.example.com',
                  prefixIcon: Icon(Icons.upload_outlined),
                ),
                enabled: !_isConnected,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextFormField(
                controller: _smtpPortController,
                decoration: const InputDecoration(
                  labelText: 'SMTP Port',
                  hintText: '587',
                  prefixIcon: Icon(Icons.numbers),
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
            label: _isConnected ? 'Disconnect' : 'Connect Email',
            onPressed: _handleConnectDisconnect,
          ),
        ),
      ],
    );
  }
}

