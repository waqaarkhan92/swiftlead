import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';
import '../global/search_bar.dart';
import '../global/avatar.dart';
import '../../models/contact.dart';
import '../../mock/mock_contacts.dart';
import '../../models/message.dart';

/// ComposeMessageSheet - Start new conversation with contact and channel selection
/// Exact specification from UI_Inventory_v2.5.1
class ComposeMessageSheet {
  static Future<ComposeMessageResult?> show({
    required BuildContext context,
  }) async {
    return await SwiftleadBottomSheet.show<ComposeMessageResult>(
      context: context,
      title: 'New Message',
      height: SheetHeight.threeQuarter,
      child: _ComposeMessageSheetContent(),
    );
  }
}

class _ComposeMessageSheetContent extends StatefulWidget {
  @override
  State<_ComposeMessageSheetContent> createState() => _ComposeMessageSheetContentState();
}

class _ComposeMessageSheetContentState extends State<_ComposeMessageSheetContent> {
  String? selectedContactId;
  String? selectedContactName;
  String selectedChannel = 'SMS';
  final TextEditingController searchController = TextEditingController();
  List<Contact> filteredContacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() {
      isLoading = true;
    });
    final contacts = await MockContacts.fetchAll();
    if (mounted) {
      setState(() {
        filteredContacts = contacts;
        isLoading = false;
      });
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

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: SwiftleadSearchBar(
            controller: searchController,
            hintText: 'Search contacts...',
            onChanged: (value) {
              if (value.isEmpty) {
                _loadContacts();
              } else {
                setState(() {
                  isLoading = true;
                });
                MockContacts.search(value).then((contacts) {
                  if (mounted) {
                    setState(() {
                      filteredContacts = contacts;
                      isLoading = false;
                    });
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),

        // Channel Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Channel',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                children: ['SMS', 'WhatsApp', 'Email', 'Facebook', 'Instagram'].map((channel) {
                  return SwiftleadChip(
                    label: channel,
                    isSelected: selectedChannel == channel,
                    onTap: () {
                      setState(() {
                        selectedChannel = channel;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Contact List
        Expanded(
          child: isLoading && filteredContacts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : filteredContacts.isEmpty
                  ? Center(
                      child: Text(
                        'No contacts found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        final isSelected = selectedContactId == contact.id;

                        return ListTile(
                          leading: SwiftleadAvatar(
                            initials: _getInitials(contact.name),
                            imageUrl: contact.avatarUrl,
                            size: AvatarSize.small,
                          ),
                          title: Text(contact.name),
                          subtitle: contact.phone != null
                              ? Text(contact.phone!)
                              : contact.email != null
                                  ? Text(contact.email!)
                                  : null,
                          trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Color(SwiftleadTokens.primaryTeal))
                              : null,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              selectedContactId = contact.id;
                              selectedContactName = contact.name;
                            });
                          },
                        );
                      },
                    ),
        ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Start Conversation',
                  onPressed: selectedContactId != null && selectedContactName != null
                      ? () {
                          Navigator.pop(
                            context,
                            ComposeMessageResult(
                              contactId: selectedContactId!,
                              contactName: selectedContactName!,
                              channel: selectedChannel,
                            ),
                          );
                        }
                      : null,
                  icon: Icons.chat_bubble_outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Result from compose message sheet
class ComposeMessageResult {
  final String contactId;
  final String contactName;
  final String channel;

  ComposeMessageResult({
    required this.contactId,
    required this.contactName,
    required this.channel,
  });
}

