import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';

/// Media Upload Sheet - Upload media files for jobs/bookings
/// Exact specification from UI_Inventory_v2.5.1
class MediaUploadSheet {
  static void show({
    required BuildContext context,
    required String jobId,
    Function()? onUploadComplete,
  }) {
    bool isUploading = false;
    double uploadProgress = 0.0;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Upload Media',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            if (isUploading) ...[
              Text(
                'Uploading...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              SwiftleadProgressBar(value: uploadProgress),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                '${(uploadProgress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                'Select media to upload:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Upload Options
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    isUploading = true;
                  });
                  // Simulate upload progress
                  Future.forEach<int>([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], (i) async {
                    await Future.delayed(const Duration(milliseconds: 100));
                    setState(() {
                      uploadProgress = i / 10;
                    });
                  }).then((_) {
                    Navigator.pop(context);
                    onUploadComplete?.call();
                    Toast.show(
                      context,
                      message: 'Media uploaded successfully',
                      type: ToastType.success,
                    );
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Choose Document'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Open file picker
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

