import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/components/trend_tile.dart';
import '../../widgets/global/chip.dart';
import '../../theme/tokens.dart';
import 'faq_management_screen.dart';
import 'ai_activity_log_screen.dart';
import 'ai_training_mode_screen.dart';
import 'ai_configuration_screen.dart';
import 'call_transcript_screen.dart';
import 'ai_performance_screen.dart';
import '../main_navigation.dart' as main_nav;
import '../../widgets/forms/ai_tone_selector_sheet.dart';
import '../../widgets/forms/ai_quote_assistant_config_sheet.dart';
import '../../widgets/forms/ai_review_reply_config_sheet.dart';
import '../../widgets/components/ai_usage_credits_card.dart';
import '../../widgets/components/animated_counter.dart';
import '../../widgets/components/smart_collapsible_section.dart';
import '../../widgets/components/celebration_banner.dart';
import '../../widgets/components/ai_insight_banner.dart';
import '../../widgets/global/spring_animation.dart';
import '../../utils/keyboard_shortcuts.dart' show AppShortcuts, SearchIntent, RefreshIntent, CloseIntent;

/// AI Hub Screen - Central control for AI features
/// Exact specification from Screen_Layouts_v2.5.1
class AIHubScreen extends StatefulWidget {
  const AIHubScreen({super.key});

  @override
  State<AIHubScreen> createState() => _AIHubScreenState();
}

class _AIHubScreenState extends State<AIHubScreen> {
  bool _isLoading = true;
  bool _isAIActive = true;
  String _selectedTone = 'Friendly';
  
  // Phase 2 features
  final Set<String> _milestonesShown = {};
  String? _celebrationMessage;
  
  // Progressive disclosure states
  bool _statusExpanded = true;
  bool _performanceExpanded = true;
  bool _configurationExpanded = false;
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _checkForMilestones();
      }
    });
  }
  
  // Phase 2: Check for milestones and show celebrations
  void _checkForMilestones() {
    // Milestones can be added based on AI performance
    // For now, placeholder for future implementation
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

  void _showToneSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AIToneSelectorSheet(
        selectedTone: _selectedTone,
      ),
    ).then((result) {
      if (result != null && mounted) {
        setState(() {
          _selectedTone = result as String;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: AppShortcuts.globalShortcuts,
      child: Actions(
        actions: {
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (_) {
              // TODO: Implement search
              return null;
            },
          ),
          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) {
              setState(() => _isLoading = true);
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _isLoading = false);
              });
              return null;
            },
          ),
          CloseIntent: CallbackAction<CloseIntent>(
            onInvoke: (_) {
              Navigator.of(context).pop();
              return null;
            },
          ),
        },
        child: Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'AI Hub',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                _createPageRoute(const AIConfigurationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('AI Hub Help'),
                  content: const Text(
                    'The AI Hub helps you manage your AI receptionist settings.\n\n'
                    '• Configure response tone and behavior\n'
                    '• Train the AI with your business information\n'
                    '• View activity logs and performance\n'
                    '• Manage FAQs and auto-responses',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(
          width: double.infinity,
          height: 120,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        Row(
          children: List.generate(2, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? 8 : 0),
              child: SkeletonLoader(
                width: double.infinity,
                height: 120,
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // AIStatusCard - Current AI state
        _buildAIStatusCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // InfoBanner - Current status
        AIInsightBanner(
          message: _isAIActive
              ? 'AI active on WhatsApp + SMS'
              : 'AI paused — messages need manual reply',
          onTap: () {
            // Tap to configure channels
          },
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Core Features Section
        SmartCollapsibleSection(
          title: 'Core Features',
          initiallyExpanded: true,
          child: Column(
            children: [
              _buildSmartTileGrid(),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // AI Activity Section
        SmartCollapsibleSection(
          title: 'AI Activity',
          initiallyExpanded: true,
          child: Column(
            children: [
              _buildAIThreadPreview(),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Configuration & Settings Section
        SmartCollapsibleSection(
          title: 'Configuration & Settings',
          initiallyExpanded: false,
          child: Column(
            children: [
              _buildAIConfigCard(),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _buildAIFeatureConfigurations(),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        
        // Analytics & Usage Section
        SmartCollapsibleSection(
          title: 'Analytics & Usage',
          initiallyExpanded: false,
          child: Column(
            children: [
              _buildPerformanceMetrics(),
              const SizedBox(height: SwiftleadTokens.spaceM),
              const AIUsageCreditsCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIStatusCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // StatusIndicator: Active (green pulse) / Paused / Error
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _isAIActive
                            ? const Color(SwiftleadTokens.successGreen)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _isAIActive ? 'Active' : 'Paused',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // QuickToggle: Pause/Resume AI
              Switch(
                value: _isAIActive,
                onChanged: (value) {
                  setState(() => _isAIActive = value);
                },
                activeColor: const Color(SwiftleadTokens.primaryTeal),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // LastActivity: "Last response 2m ago"
          Text(
            'Last response 2m ago',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // TodayStats: Responses sent, leads qualified, bookings made
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Responses',
                  value: '24',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Leads',
                  value: '12',
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Bookings',
                  value: '5',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartTileGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'Auto-Reply feature, 24 active',
                button: true,
              child: _AIFeatureTile(
                label: 'Auto-Reply',
                icon: Icons.reply_all,
                badge: '24',
                onTap: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const AIConfigurationScreen()),
                    );
                },
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: Semantics(
                label: 'Smart Replies feature, 12 active',
                button: true,
              child: _AIFeatureTile(
                label: 'Smart Replies',
                icon: Icons.auto_awesome,
                badge: '12',
                onTap: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const AIConfigurationScreen()),
                    );
                },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'FAQ Manager feature, 8 active',
                button: true,
              child: _AIFeatureTile(
                label: 'FAQ Manager',
                icon: Icons.help_outline,
                badge: '8',
                onTap: () {
                  Navigator.push(
                    context,
                    _createPageRoute(const FAQManagementScreen()),
                  );
                },
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: Semantics(
                label: 'Booking Assistant feature, 5 active',
                button: true,
              child: _AIFeatureTile(
                label: 'Booking Assistant',
                icon: Icons.event_available,
                badge: '5',
                onTap: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const AIConfigurationScreen()),
                    );
                },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAIThreadPreview() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent AI Interactions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const CallTranscriptScreen()),
                    );
                    },
                    child: const Text('Transcripts'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        _createPageRoute(const AIPerformanceScreen()),
                      );
                    },
                    child: const Text('Performance'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        _createPageRoute(const AIActivityLogScreen()),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // AIReceptionistThread preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // AIBubble with AI badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Color(SwiftleadTokens.primaryTeal),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI',
                              style: TextStyle(
                                color: const Color(SwiftleadTokens.primaryTeal),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Hi! I can help you with that. When would be convenient?',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                // ClientBubble
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(SwiftleadTokens.primaryTeal),
                              Color(SwiftleadTokens.accentAqua),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Tomorrow afternoon works',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIConfigCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Tone Selector: Formal / Friendly / Concise (chips)
          Text(
            'Tone',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: ['Formal', 'Friendly', 'Concise'].map((tone) {
              return Padding(
                padding: const EdgeInsets.only(right: SwiftleadTokens.spaceS),
                child: SwiftleadChip(
                  label: tone,
                  isSelected: tone == _selectedTone,
                  onTap: () {
                    _showToneSelector();
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const AITrainingModeScreen()),
                    );
                  },
                  child: const Text('Train AI'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      _createPageRoute(const AIConfigurationScreen()),
                    );
                  },
                  child: const Text('Full Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Expanded(
                child: TrendTile(
                  label: 'Response Time',
                  value: '2.4s',
                  trend: 'Avg',
                  isPositive: true,
                  tooltip: 'Average time to reply',
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: TrendTile(
                  label: 'Qualification',
                  value: '68%',
                  trend: '+5%',
                  isPositive: true,
                  tooltip: '% of leads fully qualified',
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Expanded(
                child: TrendTile(
                  label: 'Bookings',
                  value: '42%',
                  trend: '+8%',
                  isPositive: true,
                  tooltip: '% of inquiries → bookings',
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: TrendTile(
                  label: 'Satisfaction',
                  value: '4.8',
                  trend: '⭐',
                  isPositive: true,
                  tooltip: 'Average satisfaction rating',
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Chart would go here
          SizedBox(
            height: 150,
            child: Center(
              child: Text(
                'Chart: Trend over time (line graph)',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeatureConfigurations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Feature Configurations',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // AI Quote Assistant Config
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: InkWell(
            onTap: () {
              AIQuoteAssistantConfigSheet.show(context: context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: const Color(SwiftleadTokens.primaryTeal),
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            'AI Quote Assistant',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceXS),
                      Text(
                        'Configure smart pricing, pricing rules, and approval thresholds',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        
        // AI Review Reply Config
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: InkWell(
            onTap: () {
              AIReviewReplyConfigSheet.show(context: context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.reviews,
                            size: 20,
                            color: const Color(SwiftleadTokens.primaryTeal),
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            'AI Review Reply',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceXS),
                      Text(
                        'Configure auto-respond, tone, templates, and approval workflow',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _AIFeatureTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String badge;
  final VoidCallback? onTap;

  const _AIFeatureTile({
    required this.label,
    required this.icon,
    required this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpringCard(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(SwiftleadTokens.primaryTeal),
              Color(SwiftleadTokens.accentAqua),
            ],
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          boxShadow: [
            BoxShadow(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

