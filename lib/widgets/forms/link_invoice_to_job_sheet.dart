import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/search_bar.dart';
import '../../mock/mock_jobs.dart';
import '../../models/job.dart';

/// LinkInvoiceToJobSheet - Link an invoice to a job
/// Exact specification from UI_Inventory_v2.5.1
class LinkInvoiceToJobSheet {
  static Future<String?> show({
    required BuildContext context,
    required String invoiceId,
    String? currentJobId,
  }) async {
    String? selectedJobId = currentJobId;
    final TextEditingController searchController = TextEditingController();
    List<Job> filteredJobs = [];
    bool isLoading = true;

    return await SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Link to Job',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) {
          // Load jobs on first build
          if (isLoading) {
            MockJobs.fetchAll().then((jobs) {
              setState(() {
                filteredJobs = jobs;
                isLoading = false;
              });
            });
          }

          // Filter jobs based on search
          final searchQuery = searchController.text.toLowerCase();
          final displayJobs = searchQuery.isEmpty
              ? filteredJobs
              : filteredJobs.where((job) =>
                  job.title.toLowerCase().contains(searchQuery) ||
                  (job.contactName?.toLowerCase().contains(searchQuery) ?? false)).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: SwiftleadSearchBar(
                  controller: searchController,
                  hintText: 'Search jobs...',
                  onChanged: (value) => setState(() {}),
                ),
              ),

              // Jobs List
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : displayJobs.isEmpty
                        ? Center(
                            child: Text(
                              'No jobs found',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SwiftleadTokens.spaceM,
                            ),
                            itemCount: displayJobs.length,
                            itemBuilder: (context, index) {
                              final job = displayJobs[index];
                              final isSelected = selectedJobId == job.id;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: SwiftleadTokens.spaceS,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedJobId = job.id;
                                    });
                                  },
                                  child: FrostedContainer(
                                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSelected
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: isSelected
                                              ? const Color(SwiftleadTokens.primaryTeal)
                                              : null,
                                        ),
                                        const SizedBox(width: SwiftleadTokens.spaceM),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                job.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                job.contactName ?? '',
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '£${job.value.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                      child: PrimaryButton(
                        label: 'Link',
                        onPressed: selectedJobId != null
                            ? () => Navigator.pop(context, selectedJobId)
                            : null,
                        icon: Icons.link,
                      ),
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

