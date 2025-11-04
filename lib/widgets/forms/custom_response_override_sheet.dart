import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// CustomResponseOverrideSheet - Configure keyword-based response overrides
/// Note: Backend verification needed once backend is wired
class CustomResponseOverrideSheet {
  static Future<void> show({
    required BuildContext context,
  }) async {
    final keywordController = TextEditingController();
    final responseController = TextEditingController();
    
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'Custom Response Override',
      height: SheetHeight.half,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
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
                    'Set specific responses for particular keywords or phrases.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Keyword field
          Text(
            'Keyword or Phrase',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          TextField(
            controller: keywordController,
            decoration: InputDecoration(
              hintText: 'e.g., "refund", "cancel", "urgent"',
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
          
          // Response field
          Text(
            'Custom Response',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          TextField(
            controller: responseController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter the response message...',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceS),
            child: Text(
              'Note: Backend verification needed once backend is wired.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          PrimaryButton(
            label: 'Add Override',
            onPressed: () {
              if (keywordController.text.isNotEmpty && 
                  responseController.text.isNotEmpty) {
                // TODO: Save custom response override
                Navigator.pop(context);
              }
            },
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

