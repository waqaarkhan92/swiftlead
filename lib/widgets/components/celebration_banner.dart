import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'dart:math' as math;

/// CelebrationBanner - Animated celebration for milestones
class CelebrationBanner extends StatefulWidget {
  final String message;
  final VoidCallback? onDismiss;
  final Duration displayDuration;

  const CelebrationBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.displayDuration = const Duration(seconds: 4),
  });

  @override
  State<CelebrationBanner> createState() => _CelebrationBannerState();
}

class _CelebrationBannerState extends State<CelebrationBanner>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Scale animation (elastic bounce)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );
    
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
    
    _scaleController.forward();
    _fadeController.forward();
    
    // Auto-dismiss
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted && widget.onDismiss != null) {
            widget.onDismiss!();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
          padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
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
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () {
                  _fadeController.reverse().then((_) {
                    if (mounted && widget.onDismiss != null) {
                      widget.onDismiss!();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

