import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/toast.dart';
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
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isSaving = false;
  String? _selectedStage;
  String? _selectedSource;
  String? _avatarUrl; // URL for network images
  XFile? _selectedImage; // Selected local image file

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
      _avatarUrl = widget.initialContact!.avatarUrl;
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

  Future<void> _pickAvatarImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
          _avatarUrl = null; // Clear network URL when local image is selected
        });
      }
    } catch (e) {
      if (mounted) {
        Toast.show(
          context,
          message: 'Failed to pick image: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
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
            // Avatar Upload Section
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAvatarImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                            shape: BoxShape.circle,
                            image: _selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(File(_selectedImage!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : (_avatarUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_avatarUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                          ),
                          child: _selectedImage == null && _avatarUrl == null
                              ? Center(
                                  child: Text(
                                    _getInitials(_nameController.text.isEmpty 
                                        ? 'Contact' 
                                        : _nameController.text),
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                      color: Color(SwiftleadTokens.primaryTeal),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(SwiftleadTokens.primaryTeal),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextButton.icon(
                    onPressed: _pickAvatarImage,
                    icon: const Icon(Icons.photo_library, size: 18),
                    label: const Text('Change Photo'),
                  ),
                  if (_selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: SwiftleadTokens.spaceXS),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Remove Photo'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(SwiftleadTokens.errorRed),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
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

