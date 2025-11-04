import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';
import '../global/info_banner.dart';
import '../components/team_member_avatar.dart';
import '../global/primary_button.dart';
import '../global/search_bar.dart';

/// Job Assignment Sheet - Assign job to team member
/// Exact specification from UI_Inventory_v2.5.1
class JobAssignmentSheet {
  static void show({
    required BuildContext context,
    required String jobId,
    String? currentAssigneeId,
    List<String>? currentAssigneeIds, // For multi-member support
    bool allowMultiSelect = true, // Allow selecting multiple members
    Function(String teamMemberId, String teamMemberName)? onAssigned,
    Function(List<String> teamMemberIds, List<String> teamMemberNames)? onMultiAssigned,
  }) {
    bool isAssigning = false;
    String? selectedMemberId;
    String? selectedMemberName;
    final Set<String> selectedMemberIds = <String>{};
    final Map<String, String> selectedMemberNamesMap = <String, String>{};

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Assign Job',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: SwiftleadSearchBar(
                hintText: 'Search team members...',
              ),
            ),
            
            // Team Members List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                children: [
                  Text(
                    'Team Members',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  
                  // Multi-select info (if enabled)
                  if (allowMultiSelect) ...[
                    InfoBanner(
                      message: 'Tap multiple team members to assign them all to this job',
                      type: InfoBannerType.info,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                  ],
                  // Team member list
                  ...List.generate(5, (index) {
                    final memberId = 'member_$index';
                    final memberName = ['Alice Smith', 'Bob Johnson', 'Charlie Brown', 'Diana Wilson', 'Eve Davis'][index];
                    final isSelected = allowMultiSelect 
                        ? selectedMemberIds.contains(memberId)
                        : selectedMemberId == memberId;
                    final isCurrentAssignee = currentAssigneeId == memberId || 
                        (currentAssigneeIds?.contains(memberId) ?? false);
                    
                    return ListTile(
                      leading: TeamMemberAvatar(
                        memberId: memberId,
                        name: memberName,
                        isOnline: index % 2 == 0,
                        isAvailable: true,
                        size: 40,
                      ),
                      title: Text(memberName),
                      subtitle: Text('Role: Team Member'),
                      trailing: isCurrentAssignee
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Current',
                                style: TextStyle(
                                  color: const Color(SwiftleadTokens.primaryTeal),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Color(SwiftleadTokens.primaryTeal),
                                )
                              : allowMultiSelect
                                  ? const Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey,
                                    )
                                  : null,
                      onTap: () {
                        setState(() {
                          if (allowMultiSelect) {
                            if (isSelected) {
                              selectedMemberIds.remove(memberId);
                              selectedMemberNamesMap.remove(memberId);
                            } else {
                              selectedMemberIds.add(memberId);
                              selectedMemberNamesMap[memberId] = memberName;
                            }
                            // Also update single select for backward compatibility
                            if (selectedMemberIds.length == 1) {
                              selectedMemberId = selectedMemberIds.first;
                              selectedMemberName = selectedMemberNamesMap[selectedMemberId]!;
                            } else {
                              selectedMemberId = null;
                              selectedMemberName = null;
                            }
                          } else {
                            selectedMemberId = memberId;
                            selectedMemberName = memberName;
                          }
                        });
                      },
                    );
                  }).toList(),
                  
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  
                  // Assign Button
                  if (isAssigning)
                    const SwiftleadProgressBar()
                  else
                    PrimaryButton(
                      label: allowMultiSelect
                          ? (selectedMemberIds.isEmpty
                              ? 'Select Team Member(s)'
                              : selectedMemberIds.length == 1
                                  ? 'Assign to ${selectedMemberNamesMap[selectedMemberIds.first]}'
                                  : 'Assign to ${selectedMemberIds.length} members')
                          : (selectedMemberId == null
                              ? 'Select Team Member'
                              : 'Assign to $selectedMemberName'),
                      onPressed: (allowMultiSelect && selectedMemberIds.isEmpty) || 
                          (!allowMultiSelect && selectedMemberId == null)
                          ? null
                          : () {
                              setState(() {
                                isAssigning = true;
                              });
                              // Simulate assignment
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pop(context);
                                if (allowMultiSelect && selectedMemberIds.isNotEmpty) {
                                  final memberIds = selectedMemberIds.toList();
                                  final memberNames = memberIds.map((id) => selectedMemberNamesMap[id]!).toList();
                                  onMultiAssigned?.call(memberIds, memberNames);
                                  Toast.show(
                                    context,
                                    message: 'Assigned to ${memberNames.length} team member(s)',
                                    type: ToastType.success,
                                  );
                                } else if (selectedMemberId != null) {
                                  onAssigned?.call(selectedMemberId!, selectedMemberName!);
                                  Toast.show(
                                    context,
                                    message: 'Assigned to $selectedMemberName',
                                    type: ToastType.success,
                                  );
                                }
                              });
                            },
                      icon: Icons.person_add,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

