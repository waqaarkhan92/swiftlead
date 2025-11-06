import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import '../../utils/profession_config.dart';

/// InvoiceCustomizationScreen - Customize invoice templates and branding
/// Exact specification from UI_Inventory_v2.5.1
class InvoiceCustomizationScreen extends StatefulWidget {
  const InvoiceCustomizationScreen({super.key});

  @override
  State<InvoiceCustomizationScreen> createState() => _InvoiceCustomizationScreenState();
}

class _InvoiceCustomizationScreenState extends State<InvoiceCustomizationScreen> {
  String _getProfessionDisplayName(ProfessionType profession) {
    switch (profession) {
      case ProfessionType.trade:
        return 'trades';
      case ProfessionType.homeServices:
        return 'home services';
      case ProfessionType.professionalServices:
        return 'professional services';
      case ProfessionType.autoServices:
        return 'auto services';
      case ProfessionType.custom:
        return 'your profession';
    }
  }
  String _logoUrl = '';
  String _companyName = 'Swiftlead Plumbing';
  String _companyAddress = '123 Business Street, London SW1A 1AA';
  String _companyPhone = '+44 20 1234 5678';
  String _companyEmail = 'info@swiftlead.com';
  String _companyWebsite = 'www.swiftlead.com';
  String _taxId = 'GB123456789';
  String _paymentTerms = 'Payment due within 30 days';
  String _footerNote = 'Thank you for your business!';
  bool _showLogo = true;
  bool _showPaymentLink = true;
  bool _showQRCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: '${ProfessionState.config.getLabel('Invoice')} Customization',
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Profession-specific template info
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(SwiftleadTokens.infoBlue),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'Template: ${ProfessionState.currentProfession.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'This ${ProfessionState.config.getLabel('invoice').toLowerCase()} template is customized for ${_getProfessionDisplayName(ProfessionState.currentProfession)}.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Logo Section
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Logo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Switch(
                      value: _showLogo,
                      onChanged: (value) {
                        setState(() {
                          _showLogo = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                if (_showLogo) ...[
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.05)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: _logoUrl.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image, size: 32),
                                const SizedBox(height: SwiftleadTokens.spaceS),
                                Text(
                                  'Upload logo',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              'Logo Preview',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement logo upload
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Logo'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Company Information
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Company Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _CustomField(
                  label: 'Company Name',
                  value: _companyName,
                  onChanged: (value) => setState(() => _companyName = value),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _CustomField(
                  label: 'Address',
                  value: _companyAddress,
                  onChanged: (value) => setState(() => _companyAddress = value),
                  maxLines: 2,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _CustomField(
                  label: 'Phone',
                  value: _companyPhone,
                  onChanged: (value) => setState(() => _companyPhone = value),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _CustomField(
                  label: 'Email',
                  value: _companyEmail,
                  onChanged: (value) => setState(() => _companyEmail = value),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _CustomField(
                  label: 'Website',
                  value: _companyWebsite,
                  onChanged: (value) => setState(() => _companyWebsite = value),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                _CustomField(
                  label: 'Tax ID / VAT Number',
                  value: _taxId,
                  onChanged: (value) => setState(() => _taxId = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Invoice Settings
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _CustomField(
                  label: 'Payment Terms',
                  value: _paymentTerms,
                  onChanged: (value) => setState(() => _paymentTerms = value),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                _CustomField(
                  label: 'Footer Note',
                  value: _footerNote,
                  onChanged: (value) => setState(() => _footerNote = value),
                  maxLines: 2,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show Payment Link',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _showPaymentLink,
                      onChanged: (value) {
                        setState(() {
                          _showPaymentLink = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Show QR Code',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: _showQRCode,
                      onChanged: (value) {
                        setState(() {
                          _showQRCode = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Save Button
          PrimaryButton(
            label: 'Save Changes',
            onPressed: () {
              // TODO: Save invoice customization settings
              Navigator.pop(context);
            },
            icon: Icons.check,
          ),
        ],
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final int maxLines;

  const _CustomField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

