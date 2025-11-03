import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/primary_button.dart';
import '../../models/contact.dart';

/// ContactStageChangeSheet - Bottom sheet for changing contact stage
/// Exact specification from UI_Inventory_v2.5.1
class ContactStageChangeSheet {
  static Future<ContactStage?> show({
    required BuildContext context,
    required ContactStage currentStage,
  }) async {
    return await SwiftleadBottomSheet.show<ContactStage>(
      context: context,
      title: 'Change Stage',
      height: SheetHeight.half,
      child: _ContactStageChangeSheetContent(
        currentStage: currentStage,
      ),
    );
  }
}

class _ContactStageChangeSheetContent extends StatefulWidget {
  final ContactStage currentStage;

  const _ContactStageChangeSheetContent({
    required this.currentStage,
  });

  @override
  State<_ContactStageChangeSheetContent> createState() => _ContactStageChangeSheetContentState();
}

class _ContactStageChangeSheetContentState extends State<_ContactStageChangeSheetContent> {
  late ContactStage _selectedStage;

  @override
  void initState() {
    super.initState();
    _selectedStage = widget.currentStage;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Stage options
          ...ContactStage.values.map((stage) {
            final isSelected = _selectedStage == stage;
            return RadioListTile<ContactStage>(
              title: Text(stage.displayName),
              value: stage,
              groupValue: _selectedStage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStage = value;
                  });
                }
              },
              activeColor: const Color(SwiftleadTokens.primaryTeal),
              selected: isSelected,
            );
          }),
          const SizedBox(height: SwiftleadTokens.spaceL),
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: 'Update Stage',
                    onPressed: () => Navigator.of(context).pop(_selectedStage),
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
        ],
      ),
    );
  }
}

