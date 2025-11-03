import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// Organization Profile Screen
/// Exact specification from UI_Inventory_v2.5.1
class OrganizationProfileScreen extends StatefulWidget {
  const OrganizationProfileScreen({super.key});

  @override
  State<OrganizationProfileScreen> createState() => _OrganizationProfileScreenState();
}

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  bool _isLoading = false;
  bool _isSaving = false;
  
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController(text: 'ABC Plumbing');
  final _emailController = TextEditingController(text: 'hello@abcplumbing.co.uk');
  final _phoneController = TextEditingController(text: '+44 20 1234 5678');
  final _addressController = TextEditingController();
  final _postcodeController = TextEditingController();
  String _selectedIndustry = 'Plumber';
  String _selectedCurrency = 'GBP';
  String _selectedTimezone = 'GMT';

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      // Simulate saving
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isSaving = false);
        Toast.show(
          context,
          message: 'Organization details saved successfully',
          type: ToastType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const FrostedAppBar(
        title: 'Organization Profile',
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Logo upload
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Open image picker
                    Toast.show(
                      context,
                      message: 'Logo upload coming soon',
                      type: ToastType.info,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload Logo',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Basic Information
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                DropdownButtonFormField<String>(
                  value: _selectedIndustry,
                  decoration: InputDecoration(
                    labelText: 'Industry',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  items: ['Plumber', 'Electrician', 'HVAC', 'Cleaner', 'Handyman']
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedIndustry = value!),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Contact Information
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Location & Regional Settings
          FrostedContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location & Regional',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                DropdownButtonFormField<String>(
                  value: _selectedTimezone,
                  decoration: InputDecoration(
                    labelText: 'Timezone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  items: ['GMT', 'EST', 'PST', 'IST']
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedTimezone = value!),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  decoration: InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  items: ['GBP', 'USD', 'EUR']
                      .map((String value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCurrency = value!),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // Save Button
          PrimaryButton(
            label: _isSaving ? 'Saving...' : 'Save Changes',
            onPressed: _isSaving ? null : _handleSave,
            icon: Icons.save,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],
      ),
    );
  }
}

