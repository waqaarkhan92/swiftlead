import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/primary_button.dart';
import '../global/toast.dart';
import '../global/frosted_container.dart';

/// Custom Field Editor Sheet - Add/edit custom fields for jobs
/// Matches theme and design system
class CustomFieldEditorSheet {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    Map<String, dynamic>? initialField,
  }) async {
    final TextEditingController nameController = TextEditingController(
      text: initialField?['name'] ?? '',
    );
    final TextEditingController valueController = TextEditingController(
      text: initialField?['value'] ?? '',
    );
    String selectedType = initialField?['type'] ?? 'text';
    bool isRequired = initialField?['required'] ?? false;

    return await SwiftleadBottomSheet.show<Map<String, dynamic>?>(
      context: context,
      title: initialField == null ? 'Add Custom Field' : 'Edit Custom Field',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setSheetState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Field Name
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Field Name *',
                hintText: 'e.g., Property Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Field Type
            Text(
              'Field Type',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: ['text', 'number', 'date', 'select'].map((type) {
                return ChoiceChip(
                  label: Text(type.toUpperCase()),
                  selected: selectedType == type,
                  onSelected: (selected) {
                    setSheetState(() {
                      selectedType = type;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Field Value (if editing existing field)
            if (initialField != null) ...[
              TextFormField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: 'Field Value',
                  hintText: 'Enter value',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],
            
            // Required toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Required',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Switch(
                  value: isRequired,
                  onChanged: (value) {
                    setSheetState(() {
                      isRequired = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Save Button
            PrimaryButton(
              label: initialField == null ? 'Add Field' : 'Save Changes',
              onPressed: () {
                if (nameController.text.isEmpty) {
                  Toast.show(
                    context,
                    message: 'Please enter a field name',
                    type: ToastType.error,
                  );
                  return;
                }
                Navigator.pop(context, {
                  'name': nameController.text,
                  'type': selectedType,
                  'value': valueController.text,
                  'required': isRequired,
                });
              },
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }
}

