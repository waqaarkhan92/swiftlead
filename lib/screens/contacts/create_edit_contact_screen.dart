import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';
import '../../models/contact.dart';

/// Create/Edit Contact Form - Create or edit a contact
/// Exact specification from UI_Inventory_v2.5.1
class CreateEditContactScreen extends StatefulWidget {
  final String? contactId; // If provided, editing mode
  final Contact? initialContact;

  const CreateEditContactScreen({
    super.key,
    this.contactId,
    this.initialContact,
  });

  @override
  State<CreateEditContactScreen> createState() => _CreateEditContactScreenState();
}

class _CreateEditContactScreenState extends State<CreateEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  
  bool _isSaving = false;
  String? _selectedStage;
  String? _selectedSource;

  @override
  void initState() {
    super.initState();
    if (widget.initialContact != null) {
      _nameController.text = widget.initialContact!.name;
      _emailController.text = widget.initialContact!.email ?? '';
      _phoneController.text = widget.initialContact!.phone ?? '';
      _companyController.text = widget.initialContact!.company ?? '';
      _selectedStage = widget.initialContact!.stage.name;
      _selectedSource = widget.initialContact!.source;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate save
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.contactId != null ? 'Contact updated' : 'Contact created'),
            backgroundColor: const Color(SwiftleadTokens.successGreen),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(SwiftleadTokens.errorRed),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.contactId != null ? 'Edit Contact' : 'Create Contact',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  // Stage selection
                  Text(
                    'Stage',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    children: ['Lead', 'Contacted', 'Quoted', 'Customer', 'Archived'].map((stage) {
                      return SwiftleadChip(
                        label: stage,
                        isSelected: _selectedStage == stage,
                        onTap: () {
                          setState(() {
                            _selectedStage = stage;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                  PrimaryButton(
                    label: widget.contactId != null ? 'Update Contact' : 'Create Contact',
                    onPressed: _isSaving ? null : _saveContact,
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

