import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// FallbackResponseConfigSheet - Configure fallback response when AI is uncertain
/// Note: Backend verification needed once backend is wired
class FallbackResponseConfigSheet {
  static Future<String?> show({
    required BuildContext context,
    String? initialResponse,
  }) async {
    final controller = TextEditingController(
      text: initialResponse ?? 
          'I\'m not sure how to help with that. Let me connect you with our team who can assist you better.',
    );
    
    return await SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Fallback Response',
      height: SheetHeight.half,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info banner
                FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color(SwiftleadTokens.infoBlue),
                        size: 20,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: Text(
                          'This message is sent when AI is uncertain about how to respond.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                
                // Text field
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter fallback response message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                
                // Note about backend
                Text(
                  'Note: Backend verification needed once backend is wired.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                
                PrimaryButton(
                  label: 'Save',
                  onPressed: () {
                    Navigator.pop(context, controller.text);
                  },
                  icon: Icons.check,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

