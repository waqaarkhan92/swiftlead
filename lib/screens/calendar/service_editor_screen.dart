import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/progress_bar.dart';
import '../../theme/tokens.dart';

/// ServiceEditorScreen - Create/edit service
/// Exact specification from UI_Inventory_v2.5.1
class ServiceEditorScreen extends StatefulWidget {
  final String? serviceId; // If null, creating new service

  const ServiceEditorScreen({
    super.key,
    this.serviceId,
  });

  @override
  State<ServiceEditorScreen> createState() => _ServiceEditorScreenState();
}

class _ServiceEditorScreenState extends State<ServiceEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _travelTimeController = TextEditingController(); // Travel time in minutes
  String? _selectedCategory;
  bool _isActive = true;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasSpecificAvailability = false; // Service-specific availability toggle
  List<String> _availableDays = []; // Days this service is available

  final List<String> _categories = [
    'Repairs',
    'Installation',
    'Maintenance',
    'Consultation',
    'Inspection',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.serviceId != null) {
      _isLoading = true;
      _loadService().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _travelTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadService() async {
    // Simulate loading service data (mock implementation)
    // In production, this would fetch from API
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted && widget.serviceId != null) {
      // Mock: Load service data
      setState(() {
        _nameController.text = 'Kitchen Sink Repair';
        _descriptionController.text = 'Full repair service for kitchen sink issues';
        _durationController.text = '60';
        _priceController.text = '150.00';
        _selectedCategory = 'Repairs';
        _isActive = true;
      });
    }
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate saving service (mock implementation)
    // In production, this would save to API
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      
      // Show success toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.serviceId == null 
                ? 'Service created successfully' 
                : 'Service updated successfully',
          ),
          backgroundColor: const Color(SwiftleadTokens.successGreen),
          duration: const Duration(seconds: 2),
        ),
      );
      
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.serviceId == null ? 'New Service' : 'Edit Service',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveService,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                children: [
                  if (_isSaving)
                    const Padding(
                      padding: EdgeInsets.all(SwiftleadTokens.spaceM),
                      child: SwiftleadProgressBar(),
                    ),
                  if (_isSaving) const SizedBox(height: SwiftleadTokens.spaceM),
            // Service Name
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Name',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Kitchen Sink Repair',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a service name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Category
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Duration & Price Row
            Row(
              children: [
                Expanded(
                  child: FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration (minutes)',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceS),
                        TextFormField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '60',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceS),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: '150.00',
                            prefixText: '£',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Invalid amount';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Description
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe the service...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Travel Time
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travel Time (minutes)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  TextFormField(
                    controller: _travelTimeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '15',
                      suffixText: 'minutes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (int.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Service-Specific Availability
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service-Specific Availability',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Override general business hours for this service',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Switch(
                        value: _hasSpecificAvailability,
                        onChanged: (value) {
                          setState(() {
                            _hasSpecificAvailability = value;
                            if (!value) {
                              _availableDays = [];
                            }
                          });
                        },
                        activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ],
                  ),
                  if (_hasSpecificAvailability) ...[
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Text(
                      'Available Days',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Wrap(
                      spacing: SwiftleadTokens.spaceS,
                      runSpacing: SwiftleadTokens.spaceS,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                        final isSelected = _availableDays.contains(day);
                        return FilterChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                if (!_availableDays.contains(day)) {
                                  _availableDays.add(day);
                                }
                              } else {
                                _availableDays.remove(day);
                              }
                            });
                          },
                          selectedColor: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
                          checkmarkColor: const Color(SwiftleadTokens.primaryTeal),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Active Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Service is available for booking',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            PrimaryButton(
              label: widget.serviceId == null ? 'Create Service' : 'Save Changes',
              onPressed: _saveService,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}

