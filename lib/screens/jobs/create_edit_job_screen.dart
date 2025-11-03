import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/progress_bar.dart';
import '../../theme/tokens.dart';
import '../../widgets/forms/deposit_request_sheet.dart';

/// Create/Edit Job Form - Create or edit a job
/// Exact specification from UI_Inventory_v2.5.1
class CreateEditJobScreen extends StatefulWidget {
  final String? jobId; // If provided, editing mode
  final Map<String, dynamic>? initialData;

  const CreateEditJobScreen({
    super.key,
    this.jobId,
    this.initialData,
  });

  @override
  State<CreateEditJobScreen> createState() => _CreateEditJobScreenState();
}

class _CreateEditJobScreenState extends State<CreateEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  
  bool _isSaving = false;
  DateTime? _dueDate;
  String? _selectedStatus;
  String? _selectedPriority;
  String? _selectedServiceType;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _titleController.text = widget.initialData!['title'] ?? '';
      _descriptionController.text = widget.initialData!['description'] ?? '';
      _clientController.text = widget.initialData!['clientName'] ?? '';
      _valueController.text = widget.initialData!['value']?.toString() ?? '';
      _selectedStatus = widget.initialData!['status'];
      _selectedPriority = widget.initialData!['priority'];
      _selectedServiceType = widget.initialData!['serviceType'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _clientController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _saveJob() async {
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
            content: Text(widget.jobId != null ? 'Job updated' : 'Job created'),
            backgroundColor: const Color(SwiftleadTokens.successGreen),
          ),
        );
        Navigator.of(context).pop();
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
        title: widget.jobId != null ? 'Edit Job' : 'Create Job',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          shrinkWrap: false,
          children: [
            // Info Banner
            InfoBanner(
              message: widget.jobId != null
                  ? 'Editing will update the job details. Changes will be saved automatically.'
                  : 'Fill in the details below to create a new job. You can add more information after creation.',
              type: InfoBannerType.info,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Job Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Job Title *',
                hintText: 'e.g., Kitchen Sink Repair',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Client Selector
            TextFormField(
              controller: _clientController,
              decoration: InputDecoration(
                labelText: 'Client *',
                hintText: 'Select or enter client name',
                suffixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a client';
                }
                return null;
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Service Type
            Text(
              'Service Type',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['Repair', 'Installation', 'Maintenance', 'Consultation'].map((type) {
                final isSelected = _selectedServiceType == type;
                return SwiftleadChip(
                  label: type,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedServiceType = isSelected ? null : type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Status
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['Lead', 'Quote', 'Booked', 'In Progress', 'Complete'].map((status) {
                final isSelected = _selectedStatus == status;
                return SwiftleadChip(
                  label: status,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedStatus = isSelected ? null : status;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Priority
            Text(
              'Priority',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['Low', 'Medium', 'High', 'Urgent'].map((priority) {
                final isSelected = _selectedPriority == priority;
                return SwiftleadChip(
                  label: priority,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedPriority = isSelected ? null : priority;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Due Date
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
                  initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _dueDate != null
                    ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                    : 'Select Due Date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Job Value
            TextFormField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Estimated Value',
                hintText: '£0.00',
                prefixText: '£',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                suffixIcon: _valueController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.payments),
                        tooltip: 'Request Deposit',
                        onPressed: () {
                          final jobValue = double.tryParse(_valueController.text) ?? 0.0;
                          if (jobValue > 0) {
                            DepositRequestSheet.show(
                              context: context,
                              jobId: widget.jobId,
                              jobTitle: _titleController.text.isNotEmpty
                                  ? _titleController.text
                                  : 'Job',
                              jobAmount: jobValue,
                              onSend: (amount, dueDate, message) {
                                // Handle deposit request sent
                              },
                            );
                          }
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Add details about the job...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            if (_isSaving)
              const SwiftleadProgressBar()
            else
              PrimaryButton(
                label: widget.jobId != null ? 'Update Job' : 'Create Job',
                onPressed: _saveJob,
                icon: widget.jobId != null ? Icons.save : Icons.add,
              ),
          ],
        ),
      ),
    );
  }
}

