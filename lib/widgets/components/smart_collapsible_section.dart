import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// SmartCollapsibleSection - Collapsible section with smooth animation
class SmartCollapsibleSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final VoidCallback? onExpandedChanged;

  const SmartCollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
    this.onExpandedChanged,
  });

  @override
  State<SmartCollapsibleSection> createState() => _SmartCollapsibleSectionState();
}

class _SmartCollapsibleSectionState extends State<SmartCollapsibleSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpandedChanged?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 0.5).animate(_expandAnimation),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: ClipRect(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SwiftleadTokens.spaceM,
                  0,
                  SwiftleadTokens.spaceM,
                  SwiftleadTokens.spaceM,
                ),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

