import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/search_bar.dart';
import '../global/avatar.dart' show SwiftleadAvatar, AvatarSize;
import '../global/primary_button.dart';
import '../../models/contact.dart';
import '../../mock/mock_contacts.dart';

/// ContactSelectorSheet - Reusable contact picker with search
/// Used for selecting contacts in forms (e.g., Client Selector in Job creation)
class ContactSelectorSheet {
  static Future<Contact?> show({
    required BuildContext context,
    String? title,
    String? hintText,
  }) async {
    return await SwiftleadBottomSheet.show<Contact>(
      context: context,
      title: title ?? 'Select Contact',
      height: SheetHeight.threeQuarter,
      child: _ContactSelectorSheetContent(
        hintText: hintText ?? 'Search contacts...',
      ),
    );
  }
}

class _ContactSelectorSheetContent extends StatefulWidget {
  final String hintText;

  const _ContactSelectorSheetContent({
    required this.hintText,
  });

  @override
  State<_ContactSelectorSheetContent> createState() => _ContactSelectorSheetContentState();
}

class _ContactSelectorSheetContentState extends State<_ContactSelectorSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });
    final contacts = await MockContacts.fetchAll();
    if (mounted) {
      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = _allContacts;
      });
    } else {
      setState(() {
        _filteredContacts = _allContacts.where((contact) {
          return contact.name.toLowerCase().contains(query) ||
              (contact.email?.toLowerCase().contains(query) ?? false) ||
              (contact.phone?.toLowerCase().contains(query) ?? false);
        }).toList();
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
            controller: _searchController,
            hintText: widget.hintText,
          ),
        ),
        // Contacts List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredContacts.isEmpty
                  ? Center(
                      child: Text(
                        'No contacts found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = _filteredContacts[index];
                        return ListTile(
                          leading: SwiftleadAvatar(
                            initials: _getInitials(contact.name),
                            imageUrl: contact.avatarUrl,
                            size: AvatarSize.medium,
                          ),
                          title: Text(contact.name),
                          subtitle: contact.email != null
                              ? Text(contact.email!)
                              : contact.phone != null
                                  ? Text(contact.phone!)
                                  : null,
                          onTap: () {
                            Navigator.of(context).pop(contact);
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

