import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../theme/tokens.dart';

/// AI Training Mode Screen - Add training examples to improve AI
/// Exact specification from UI_Inventory_v2.5.1
class AITrainingModeScreen extends StatefulWidget {
  const AITrainingModeScreen({super.key});

  @override
  State<AITrainingModeScreen> createState() => _AITrainingModeScreenState();
}

class _TrainingExample {
  final String id;
  final String category;
  final String input;
  final String expectedOutput;

  _TrainingExample({
    required this.id,
    required this.category,
    required this.input,
    required this.expectedOutput,
  });
}

class _AITrainingModeScreenState extends State<AITrainingModeScreen> {
  bool _isLoading = false;
  bool _isTraining = false;
  final List<_TrainingExample> _trainingExamples = [];
  String _selectedCategory = 'Booking';

  @override
  void initState() {
    super.initState();
    // Initialize with example data
    _trainingExamples.addAll([
      _TrainingExample(
        id: '1',
        category: 'Booking',
        input: _getInputExample(0),
        expectedOutput: _getOutputExample(0),
      ),
      _TrainingExample(
        id: '2',
        category: 'Pricing',
        input: _getInputExample(1),
        expectedOutput: _getOutputExample(1),
      ),
      _TrainingExample(
        id: '3',
        category: 'Hours',
        input: _getInputExample(2),
        expectedOutput: _getOutputExample(2),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Train AI',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTrainingExampleSheet(context),
            tooltip: 'Add Example',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 140,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // InfoBanner
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(SwiftleadTokens.infoBlue),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Text(
                  'Add training examples to help AI learn your business better',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Training Examples
        Text(
          'Training Examples',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // Example Cards
        if (_trainingExamples.isEmpty)
          EmptyStateCard(
            icon: Icons.school_outlined,
            title: 'No Training Examples',
            description: 'Add your first training example to help the AI learn your business.',
            actionLabel: 'Add Example',
            onAction: () => _showAddTrainingExampleSheet(context),
          )
        else
          ..._trainingExamples.map((example) => Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: _TrainingExampleCard(
              category: example.category,
              input: example.input,
              expectedOutput: example.expectedOutput,
              onDelete: () {
                setState(() {
                  _trainingExamples.removeWhere((e) => e.id == example.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Training example deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        )),

        const SizedBox(height: SwiftleadTokens.spaceL),

        // Train Button
        if (!_isTraining)
          PrimaryButton(
            label: 'Train AI with Examples',
            onPressed: () {
              setState(() => _isTraining = true);
              // Simulate training
              Future.delayed(const Duration(seconds: 3), () {
                if (mounted) {
                  setState(() => _isTraining = false);
                }
              });
            },
            icon: Icons.school,
          )
        else
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  'Training AI...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  'This may take a few moments',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showAddTrainingExampleSheet(BuildContext context) {
    SwiftleadBottomSheet.show(
      context: context,
      title: 'Add Training Example',
      height: SheetHeight.threeQuarter,
      child: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          Text(
            'Category',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            children: ['Booking', 'Pricing', 'Hours', 'Services', 'Other'].map((category) {
              return SwiftleadChip(
                label: category,
                isSelected: category == _selectedCategory,
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Input (What customer says)',
              hintText: 'e.g., "What are your business hours?"',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Expected Output (What AI should respond)',
              hintText: 'e.g., "We are open Monday to Friday, 9am to 5pm."',
            ),
            maxLines: 5,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Save Example',
            onPressed: () {
              Navigator.pop(context);
              // Save training example
            },
          ),
        ],
      ),
    );
  }

  String _getInputExample(int index) {
    final inputs = [
      'Can I book an appointment?',
      'How much does it cost?',
      'When are you open?',
    ];
    return inputs[index % inputs.length];
  }

  String _getOutputExample(int index) {
    final outputs = [
      'I\'d be happy to help you book an appointment. What service do you need?',
      'Our pricing varies by service. For a standard repair, it\'s typically £150-300.',
      'We are open Monday to Friday, 9am to 5pm, and Saturday 10am to 2pm.',
    ];
    return outputs[index % outputs.length];
  }
}

class _TrainingExampleCard extends StatelessWidget {
  final String category;
  final String input;
  final String expectedOutput;
  final VoidCallback? onDelete;

  const _TrainingExampleCard({
    required this.category,
    required this.input,
    required this.expectedOutput,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard * 0.4),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Color(SwiftleadTokens.primaryTeal),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Input:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            input,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Expected Output:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            expectedOutput,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

