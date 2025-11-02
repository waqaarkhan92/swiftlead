import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart';

/// ScoreIndicator - Lead score badge with color coding
/// Exact specification from UI_Inventory_v2.5.1
enum ScoreClassification { hot, warm, cold }

class ScoreIndicator extends StatelessWidget {
  final int score;
  final String? classification;
  final bool compact;

  const ScoreIndicator({
    super.key,
    required this.score,
    this.classification,
    this.compact = false,
  });

  ScoreClassification _getClassification() {
    if (classification != null) {
      switch (classification!.toLowerCase()) {
        case 'hot':
          return ScoreClassification.hot;
        case 'warm':
          return ScoreClassification.warm;
        case 'cold':
          return ScoreClassification.cold;
      }
    }
    
    // Auto-classify based on score
    if (score >= 80) return ScoreClassification.hot;
    if (score >= 60) return ScoreClassification.warm;
    return ScoreClassification.cold;
  }

  Color _getColor() {
    switch (_getClassification()) {
      case ScoreClassification.hot:
        return const Color(SwiftleadTokens.errorRed);
      case ScoreClassification.warm:
        return const Color(SwiftleadTokens.warningYellow);
      case ScoreClassification.cold:
        return const Color(SwiftleadTokens.infoBlue);
    }
  }

  String _getLabel() {
    final classification = _getClassification();
    if (compact) {
      switch (classification) {
        case ScoreClassification.hot:
          return '🔥 $score';
        case ScoreClassification.warm:
          return '⚡ $score';
        case ScoreClassification.cold:
          return '❄️ $score';
      }
    }
    final classificationName = classification.name.toUpperCase();
    return '$score ($classificationName)';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: color,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

