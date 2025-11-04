import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// MultiLanguageConfigSheet - Configure supported languages
/// Note: Backend verification needed once backend is wired
class MultiLanguageConfigSheet {
  static Future<Set<String>?> show({
    required BuildContext context,
    Set<String> initialLanguages = const {'en'},
  }) async {
    Set<String> selectedLanguages = Set.from(initialLanguages);
    
    return await SwiftleadBottomSheet.show<Set<String>>(
      context: context,
      title: 'Supported Languages',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          final availableLanguages = {
            'en': 'English',
            'es': 'Spanish',
            'fr': 'French',
            'de': 'German',
            'it': 'Italian',
            'pt': 'Portuguese',
          };
          
          return ListView(
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
                        'AI will detect client language and respond in the appropriate language.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Language selection
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: availableLanguages.entries.map((entry) {
                  final isSelected = selectedLanguages.contains(entry.key);
                  return SwiftleadChip(
                    label: entry.value,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedLanguages.remove(entry.key);
                        } else {
                          selectedLanguages.add(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
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
                label: 'Save',
                onPressed: () {
                  Navigator.pop(context, selectedLanguages);
                },
                icon: Icons.check,
              ),
            ],
          );
        },
      ),
    );
  }
}

