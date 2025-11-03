import 'package:flutter/material.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

/// NPS Survey View - Net Promoter Score tracking
/// Exact specification from Cross_Reference_Matrix_v2.5.1 Module 8
class NpsSurveyView extends StatefulWidget {
  const NpsSurveyView({super.key});

  @override
  State<NpsSurveyView> createState() => _NpsSurveyViewState();
}

class _NpsSurveyViewState extends State<NpsSurveyView> {
  bool _isLoading = false;
  int _selectedTab = 0;
  final List<String> _tabs = ['Active Surveys', 'Results', 'History'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Selector
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SwiftleadTokens.spaceM,
            vertical: SwiftleadTokens.spaceS,
          ),
          child: Row(
            children: _tabs.map((tab) {
              final index = _tabs.indexOf(tab);
              final isSelected = _selectedTab == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : null,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildActiveSurveysTab(),
              _buildResultsTab(),
              _buildHistoryTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSurveysTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) setState(() => _isLoading = false);
      },
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              children: [
                PrimaryButton(
                  label: 'Create NPS Survey',
                  onPressed: () => _showCreateSurvey(context),
                  icon: Icons.add,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                EmptyStateCard(
                  title: 'No Active Surveys',
                  description: 'Create an NPS survey to measure customer satisfaction',
                  icon: Icons.poll_outlined,
                ),
              ],
            ),
    );
  }

  Widget _buildResultsTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // NPS Score
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              children: [
                Text(
                  'Current NPS Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  '42',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'Good',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(SwiftleadTokens.successGreen),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                // NPS Breakdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNpsSegment('Promoters', 65, const Color(SwiftleadTokens.successGreen)),
                    _buildNpsSegment('Passives', 23, const Color(SwiftleadTokens.warningYellow)),
                    _buildNpsSegment('Detractors', 12, const Color(SwiftleadTokens.errorRed)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Response Distribution
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score Distribution',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                ...List.generate(11, (index) {
                  final score = index;
                  final count = _getScoreCount(score);
                  final total = 100;
                  final percentage = count / total;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceXS),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '$score',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                score >= 9
                                    ? const Color(SwiftleadTokens.successGreen)
                                    : score >= 7
                                        ? const Color(SwiftleadTokens.warningYellow)
                                        : const Color(SwiftleadTokens.errorRed),
                              ),
                              minHeight: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '$count',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpsSegment(String label, int percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$percentage%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  int _getScoreCount(int score) {
    // Mock data - normally from API
    final distribution = {
      0: 2, 1: 1, 2: 1, 3: 2, 4: 1, 5: 3, 6: 4,
      7: 8, 8: 12, 9: 25, 10: 41,
    };
    return distribution[score] ?? 0;
  }

  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          EmptyStateCard(
            title: 'No Survey History',
            description: 'Completed surveys will appear here',
            icon: Icons.history_outlined,
          ),
        ],
      ),
    );
  }

  void _showCreateSurvey(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create NPS Survey - Feature coming soon'),
      ),
    );
  }
}

