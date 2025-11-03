import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/empty_state_card.dart';
import '../global/primary_button.dart';
import '../global/skeleton_loader.dart';
import '../global/toast.dart' as toast;

/// Internal Notes Modal - Create and read internal team notes for conversations
/// Exact specification from UI_Inventory_v2.5.1
class InternalNotesModal {
  static void show({
    required BuildContext context,
    required String threadId,
    List<InternalNote>? existingNotes,
    Function(String note)? onNoteAdded,
  }) {
    bool isLoading = false;
    List<InternalNote> notes = existingNotes ?? [];
    final TextEditingController noteController = TextEditingController();

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Internal Notes',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) {
          if (isLoading && notes.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 80,
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              )),
            );
          }

          return Column(
            children: [
              // Notes List
              Expanded(
                child: notes.isEmpty
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        child: EmptyStateCard(
                          title: 'No notes yet',
                          description: 'Add internal notes that only your team can see.',
                          icon: Icons.note_outlined,
                          actionLabel: 'Add First Note',
                          onAction: () {
                            // Focus note input
                          },
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        shrinkWrap: false,
                        children: [
                          ...notes.map((note) => Padding(
                            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                            child: _NoteCard(
                              note: note,
                              onEdit: () {
                                // Edit note
                              },
                              onDelete: () {
                                setState(() {
                                  notes.remove(note);
                                });
                                toast.Toast.show(
                                  context,
                                  message: 'Note deleted',
                                  type: toast.ToastType.success,
                                );
                              },
                            ),
                          )),
                        ],
                      ),
              ),

              // Add Note Section
              Container(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.1)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add an internal note...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                        ),
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    PrimaryButton(
                      label: 'Save Note',
                      onPressed: () {
                        if (noteController.text.trim().isEmpty) return;
                        
                        final newNote = InternalNote(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          content: noteController.text,
                          authorName: 'Current User',
                          authorAvatar: null,
                          timestamp: DateTime.now(),
                        );
                        
                        setState(() {
                          notes.insert(0, newNote);
                          noteController.clear();
                        });
                        
                        onNoteAdded?.call(newNote.content);
                        
                        toast.Toast.show(
                          context,
                          message: 'Note saved',
                          type: toast.ToastType.success,
                        );
                      },
                      icon: Icons.save,
                      size: ButtonSize.small,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class InternalNote {
  final String id;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final DateTime timestamp;

  InternalNote({
    required this.id,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.timestamp,
  });
}

class _NoteCard extends StatelessWidget {
  final InternalNote note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _NoteCard({
    required this.note,
    this.onEdit,
    this.onDelete,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Author Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    note.authorName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              
              // Author Name and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.authorName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatTimestamp(note.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          // Note Content
          Text(
            note.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

