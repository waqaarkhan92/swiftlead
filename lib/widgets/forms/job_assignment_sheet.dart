import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/progress_bar.dart';
import '../global/toast.dart';
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
    Function(String teamMemberId, String teamMemberName)? onAssigned,
  }) {
    bool isAssigning = false;
    String? selectedMemberId;
    String? selectedMemberName;

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
                  
                  // Team member list
                  ...List.generate(5, (index) {
                    final memberId = 'member_$index';
                    final memberName = ['Alice Smith', 'Bob Johnson', 'Charlie Brown', 'Diana Wilson', 'Eve Davis'][index];
                    final isSelected = selectedMemberId == memberId;
                    final isCurrentAssignee = currentAssigneeId == memberId;
                    
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
                              : null,
                      onTap: () {
                        setState(() {
                          selectedMemberId = memberId;
                          selectedMemberName = memberName;
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
                      label: selectedMemberId == null
                          ? 'Select Team Member'
                          : 'Assign to $selectedMemberName',
                      onPressed: selectedMemberId == null
                          ? null
                          : () {
                              setState(() {
                                isAssigning = true;
                              });
                              // Simulate assignment
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pop(context);
                                onAssigned?.call(selectedMemberId!, selectedMemberName!);
                                Toast.show(
                                  context,
                                  message: 'Assigned to $selectedMemberName',
                                  type: ToastType.success,
                                );
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

