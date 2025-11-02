import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/progress_bar.dart';
import '../global/chip.dart';
import '../global/toast.dart';
import '../global/primary_button.dart';

/// Job Export Sheet - Export jobs to file
/// Exact specification from UI_Inventory_v2.5.1
class JobExportSheet {
  static void show({
    required BuildContext context,
    Function(String format)? onExportComplete,
  }) {
    String selectedFormat = 'CSV';
    bool isExporting = false;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Export Jobs',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            Text(
              'Select export format',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Format Selector
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['CSV', 'Excel', 'PDF'].map((format) {
                return SwiftleadChip(
                  label: format,
                  isSelected: selectedFormat == format,
                  onTap: () {
                    setState(() {
                      selectedFormat = format;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Options
            CheckboxListTile(
              title: const Text('Include all job details'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Include timeline events'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Include media files'),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // Export Button
            if (isExporting)
              const SwiftleadProgressBar()
            else
              PrimaryButton(
                label: 'Generate Export',
                onPressed: () {
                  setState(() {
                    isExporting = true;
                  });
                  // Simulate export
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      isExporting = false;
                    });
                    Navigator.pop(context);
                    onExportComplete?.call(selectedFormat);
                    Toast.show(
                      context,
                      message: 'Export generated successfully',
                      type: ToastType.success,
                    );
                  });
                },
                icon: Icons.download,
              ),
          ],
        ),
      ),
    );
  }
}

