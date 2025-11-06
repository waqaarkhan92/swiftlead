import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart' show PrimaryButton, ButtonSize;
import '../../widgets/components/segmented_control.dart';
import '../../widgets/components/quick_action_chip.dart';
import '../../theme/tokens.dart';
import '../main_navigation.dart';

/// Onboarding Screen - Multi-step setup wizard
/// Exact specification from Product_Definition_v2.5.1 §3.15 and Cross_Reference_Matrix_v2.5.1 Module 15
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4; // Simplified from 8 to 4 steps
  final PageController _pageController = PageController();

  // Step 1: Profession Selection (combined with welcome)
  String? _selectedProfession;

  // Step 2: Business Name (simplified - just name)
  final TextEditingController _businessNameController = TextEditingController();

  // Step 3: Quick Setup (one integration or AI defaults)
  String? _selectedQuickIntegration; // User picks one or skips
  bool _aiEnabled = true; // AI enabled by default

  // Old variables (kept for old step builders that are no longer used but still in code)
  // These can be removed once old step builders are fully removed
  String? _businessLogo;
  String? _serviceArea;
  Map<String, bool> _businessHours = {};
  final List<String> _teamEmails = [];
  final TextEditingController _teamEmailController = TextEditingController();
  final TextEditingController _aiGreetingController = TextEditingController(
    text: 'Hi! Thanks for reaching out. How can we help you today?',
  );
  final List<Map<String, dynamic>> _services = [];
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDurationController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  bool _demoDataEnabled = false;
  Map<String, bool> _integrations = {
    'Google Calendar': false,
    'Apple Calendar': false,
    'Outlook': false,
    'Stripe': false,
    'SMS': false,
    'WhatsApp': false,
    'Email': false,
  };
  String _aiTone = 'Friendly';

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameController.dispose();
    _teamEmailController.dispose();
    _aiGreetingController.dispose();
    _serviceNameController.dispose();
    _serviceDurationController.dispose();
    _servicePriceController.dispose();
    super.dispose();
  }

  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            _buildProgressBar(),
            // Skip Button (on first step only)
            if (_currentStep == 0)
              Padding(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _skipOnboarding(),
                    child: const Text('Skip for now'),
                  ),
                ),
              ),
            // Step Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeAndProfessionStep(), // Step 1: Combined welcome + profession
                  _buildBusinessNameStep(), // Step 2: Just business name
                  _buildQuickSetupStep(), // Step 3: Quick setup (one integration or AI)
                  _buildDoneStep(), // Step 4: Done screen
                ],
              ),
            ),
            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentStep + 1) / _totalSteps;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceL,
      ),
      child: Column(
        children: [
          // Enhanced Step Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: () => _saveAndContinueLater(),
                  child: const Text('Save & Continue Later'),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // iOS-style Step Indicator
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? const Color(SwiftleadTokens.successGreen)
                                  : isActive
                                      ? const Color(SwiftleadTokens.primaryTeal)
                                      : Theme.of(context).brightness == Brightness.light
                                          ? Colors.black.withOpacity(0.1)
                                          : Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < _totalSteps - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          color: index < _currentStep
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.1),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(SwiftleadTokens.primaryTeal),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Welcome & Profession Selection (Combined)
  Widget _buildWelcomeAndProfessionStep() {
    final professions = ['Trade', 'Salon / Clinic', 'Professional'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Logo/Illustration
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 80,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'Welcome to Swiftlead',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Let\'s get you set up in just a few steps',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          // Profession Selection
          Text(
            'What\'s your profession?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'We\'ll customize Swiftlead for your industry',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          // Profession Cards
          ...professions.map((profession) {
            final isSelected = _selectedProfession == profession;
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedProfession = profession);
                },
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                          border: Border.all(
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Color(SwiftleadTokens.primaryTeal),
                                size: 20,
                              )
                            : null,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profession,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getProfessionDescription(profession),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: SwiftleadTokens.spaceXL),
        ],
      ),
    );
  }

  // OLD Step 1: Welcome & Value Prop (replaced by combined step)
  Widget _buildWelcomeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Logo/Illustration Placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 100,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'Welcome to Swiftlead',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'The all-in-one platform that captures leads, books jobs, and gets you paid automatically.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Key Benefits
          _buildBenefitTile(
            icon: Icons.auto_awesome,
            title: 'AI-Powered',
            description: 'Automated responses and smart scheduling',
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildBenefitTile(
            icon: Icons.schedule,
            title: 'Never Miss a Job',
            description: 'Smart booking and payment reminders',
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildBenefitTile(
            icon: Icons.payments,
            title: 'Get Paid Faster',
            description: 'Automated invoicing and payment links',
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
        ],
      ),
    );
  }

  Widget _buildBenefitTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Icon(
              icon,
              color: const Color(SwiftleadTokens.primaryTeal),
              size: 32,
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.6)
                            : Colors.white.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Profession Selection
  Widget _buildProfessionStep() {
    final professions = ['Trade', 'Salon / Clinic', 'Professional'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'What\'s your profession?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'We\'ll customize Swiftlead to match your industry',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Profession Cards
          ...professions.map((profession) {
            final isSelected = _selectedProfession == profession;
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedProfession = profession);
                },
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                          border: Border.all(
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Color(SwiftleadTokens.primaryTeal),
                              )
                            : null,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profession,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getProfessionDescription(profession),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getProfessionDescription(String profession) {
    switch (profession) {
      case 'Trade':
        return 'Plumbing, electrical, construction, etc.';
      case 'Salon / Clinic':
        return 'Hair salons, beauty clinics, medical practices';
      case 'Professional':
        return 'Legal, accounting, consulting services';
      default:
        return '';
    }
  }

  // Step 2: Business Name (Simplified)
  Widget _buildBusinessNameStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'What\'s your business name?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'You can add more details later in Settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          // Business Name
          FrostedContainer(
            child: TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: 'Business Name',
                hintText: 'e.g., Smith Plumbing',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.business),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
        ],
      ),
    );
  }

  // Step 3: Quick Setup (One integration or AI defaults)
  Widget _buildQuickSetupStep() {
    final quickIntegrations = [
      {'name': 'Google Calendar', 'icon': Icons.calendar_today},
      {'name': 'Apple Calendar', 'icon': Icons.calendar_month},
      {'name': 'SMS', 'icon': Icons.message},
      {'name': 'Skip for now', 'icon': Icons.arrow_forward},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'Quick Setup',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Connect one integration now, or skip and set up later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          // AI Enabled by default
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: _aiEnabled
                      ? const Color(SwiftleadTokens.primaryTeal)
                      : Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enabled by default - helps with responses',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _aiEnabled,
                  onChanged: (value) {
                    setState(() => _aiEnabled = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Connect an integration (optional)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Integration Options
          ...quickIntegrations.map((integration) {
            final isSelected = _selectedQuickIntegration == integration['name'];
            final isSkip = integration['name'] == 'Skip for now';
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSkip) {
                      _selectedQuickIntegration = null;
                    } else {
                      _selectedQuickIntegration = integration['name'] as String;
                    }
                  });
                },
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                          border: Border.all(
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Color(SwiftleadTokens.primaryTeal),
                                size: 20,
                              )
                            : Icon(
                                integration['icon'] as IconData,
                                size: 20,
                                color: isSkip
                                    ? Theme.of(context).textTheme.bodySmall?.color
                                    : const Color(SwiftleadTokens.primaryTeal),
                              ),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceM),
                      Expanded(
                        child: Text(
                          integration['name'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSkip
                                    ? Theme.of(context).textTheme.bodySmall?.color
                                    : null,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: SwiftleadTokens.spaceXL),
        ],
      ),
    );
  }

  // Step 4: Done Screen
  Widget _buildDoneStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          // Success Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: Color(SwiftleadTokens.successGreen),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          Text(
            'You\'re all set!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Welcome to Swiftlead. You can customize more settings anytime in Settings.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXXL),
          // Summary
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedProfession != null)
                  _buildSummaryItem('Profession', _selectedProfession!),
                if (_businessNameController.text.isNotEmpty)
                  _buildSummaryItem('Business', _businessNameController.text),
                if (_selectedQuickIntegration != null)
                  _buildSummaryItem('Integration', _selectedQuickIntegration!),
                _buildSummaryItem('AI Assistant', _aiEnabled ? 'Enabled' : 'Disabled'),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  // OLD Step 3: Business Details (kept for reference, not used)
  Widget _buildBusinessDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Tell us about your business',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Business Name
          TextField(
            controller: _businessNameController,
            decoration: InputDecoration(
              labelText: 'Business Name',
              hintText: 'Enter your business name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Logo Upload
          GestureDetector(
            onTap: () => _uploadLogo(),
            child: FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.05)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    child: _businessLogo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                            child: Semantics(
                              label: 'Business logo',
                              child: Image.network(_businessLogo!, fit: BoxFit.cover),
                            ),
                          )
                        : const Icon(Icons.add_photo_alternate_outlined),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Logo',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _businessLogo != null ? 'Tap to change' : 'Tap to upload',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Service Area
          TextField(
            onChanged: (value) => setState(() => _serviceArea = value),
            decoration: InputDecoration(
              labelText: 'Service Area',
              hintText: 'e.g., London, UK',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'Business Hours',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _buildBusinessHoursSelector(),
        ],
      ),
    );
  }

  Widget _buildBusinessHoursSelector() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return Column(
      children: days.map((day) {
        final isOpen = _businessHours[day] ?? false;
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  day,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Switch(
                value: isOpen,
                onChanged: (value) {
                  setState(() => _businessHours[day] = value);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Step 4: Team Members
  Widget _buildTeamMembersStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Invite your team',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Optional - You can skip this if you work solo',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Add Team Member
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _teamEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'teammate@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_teamEmailController.text.isNotEmpty) {
                    setState(() {
                      _teamEmails.add(_teamEmailController.text);
                      _teamEmailController.clear();
                    });
                  }
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(SwiftleadTokens.primaryTeal),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Team Member List
          if (_teamEmails.isEmpty)
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.02)
                    : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: Text(
                      'No team members added. You can invite them later.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._teamEmails.map((email) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Expanded(
                        child: Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() => _teamEmails.remove(email));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  // Step 5: Integrations
  Widget _buildIntegrationsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Connect your tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Integrate with your existing calendar, payments, and messaging',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Integration Cards
          ..._integrations.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
              child: _buildIntegrationCard(entry.key, entry.value),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(String name, bool isConnected) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isConnected
                  ? const Color(SwiftleadTokens.successGreen).withOpacity(0.1)
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Icon(
              _getIntegrationIcon(name),
              color: isConnected
                  ? const Color(SwiftleadTokens.successGreen)
                  : null,
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected ? 'Connected' : 'Not connected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isConnected
                            ? const Color(SwiftleadTokens.successGreen)
                            : Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _connectIntegration(name),
            child: Text(isConnected ? 'Reconnect' : 'Connect'),
          ),
        ],
      ),
    );
  }

  IconData _getIntegrationIcon(String name) {
    switch (name) {
      case 'Google Calendar':
        return Icons.calendar_today;
      case 'Apple Calendar':
        return Icons.calendar_month;
      case 'Outlook':
        return Icons.email_outlined;
      case 'Stripe':
        return Icons.payments;
      case 'SMS':
        return Icons.sms;
      case 'WhatsApp':
        return Icons.chat_bubble_outline;
      case 'Email':
        return Icons.email;
      default:
        return Icons.link;
    }
  }

  // Step 6: AI Configuration
  Widget _buildAIConfigStep() {
    final tones = ['Formal', 'Friendly', 'Concise'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Configure AI Receptionist',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Let AI handle your messages automatically',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // AI Toggle
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable AI Receptionist',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI will automatically respond to customer inquiries',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _aiEnabled,
                  onChanged: (value) => setState(() => _aiEnabled = value),
                ),
              ],
            ),
          ),
          if (_aiEnabled) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Tone Selection
            Text(
              'AI Tone',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            SegmentedControl(
              segments: tones,
              selectedIndex: tones.indexOf(_aiTone),
              onSelectionChanged: (index) {
                setState(() => _aiTone = tones[index]);
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Greeting Message
            TextField(
              controller: _aiGreetingController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Default Greeting',
                hintText: 'Enter your AI greeting message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            PrimaryButton(
              label: 'Test AI Response',
              onPressed: () => _testAIResponse(),
              size: ButtonSize.small,
            ),
          ],
        ],
      ),
    );
  }

  // Step 7: Booking Setup
  Widget _buildBookingSetupStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceL),
          Text(
            'Set up your services',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Add the services you offer to customers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Add Service Form
          TextField(
            controller: _serviceNameController,
            decoration: InputDecoration(
              labelText: 'Service Name',
              hintText: 'e.g., Consultation, Installation',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _serviceDurationController,
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    hintText: '60',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: TextField(
                  controller: _servicePriceController,
                  decoration: InputDecoration(
                    labelText: 'Price (£)',
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          PrimaryButton(
            label: 'Add Service',
            onPressed: () => _addService(),
            size: ButtonSize.small,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Services List
          if (_services.isEmpty)
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.02)
                    : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Text(
                'No services added yet. You can add them later in Settings.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          else
            ..._services.map((service) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'] as String,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service['duration']} min • £${service['price']}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() => _services.remove(service));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  // Step 8: Final Checklist
  Widget _buildFinalChecklistStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Success Icon
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(SwiftleadTokens.successGreen),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          Text(
            'You\'re all set!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Review your settings and launch Swiftlead',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXL),
          // Checklist
          _buildChecklistItem('Profession Selected', _selectedProfession != null),
          _buildChecklistItem('Business Details', _businessNameController.text.isNotEmpty),
          _buildChecklistItem('Integrations', _integrations.values.any((v) => v)),
          _buildChecklistItem('AI Configured', _aiEnabled),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Demo Data Toggle
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Demo Data',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Get started with sample jobs and bookings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _demoDataEnabled,
                  onChanged: (value) => setState(() => _demoDataEnabled = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String label, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isComplete
                ? const Color(SwiftleadTokens.successGreen)
                : Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isComplete
                      ? null
                      : Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white.withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _previousStep(),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: SwiftleadTokens.spaceS),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              label: _currentStep == _totalSteps - 1 ? 'Launch Swiftlead' : 'Next',
              onPressed: () {
                // Validate required fields before proceeding
                if (_currentStep == 0 && _selectedProfession == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select your profession')),
                  );
                  return;
                }
                if (_currentStep == _totalSteps - 1) {
                  _finishOnboarding();
                } else {
                  _nextStep();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    // Navigate to main app - need to restart app to refresh state
    // Use Navigator to go back to root and let main.dart handle navigation
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        _createPageRoute(const MainNavigation()),
        (route) => false,
      );
    }
  }

  void _saveAndContinueLater() {
    // Save progress and navigate to main app
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress saved. You can continue later in Settings.')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        _createPageRoute(const MainNavigation()),
        (route) => false,
      );
    }
  }

  void _finishOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    // Complete onboarding and launch app - need to restart app to refresh state
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome to Swiftlead!')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        _createPageRoute(const MainNavigation()),
        (route) => false,
      );
    }
  }

  void _uploadLogo() {
    // Placeholder for image picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logo upload - Feature coming soon')),
    );
  }

  void _connectIntegration(String name) {
    // Placeholder for OAuth flow
    setState(() {
      _integrations[name] = !_integrations[name]!;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_integrations[name]! ? 'Connected' : 'Disconnected'} $name')),
    );
  }

  void _testAIResponse() {
    // Placeholder for AI test
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Response Test - Feature coming soon')),
    );
  }

  void _addService() {
    if (_serviceNameController.text.isNotEmpty) {
      setState(() {
        _services.add({
          'name': _serviceNameController.text,
          'duration': _serviceDurationController.text.isEmpty
              ? '60'
              : _serviceDurationController.text,
          'price': _servicePriceController.text.isEmpty
              ? '0.00'
              : _servicePriceController.text,
        });
        _serviceNameController.clear();
        _serviceDurationController.clear();
        _servicePriceController.clear();
      });
    }
  }
}

