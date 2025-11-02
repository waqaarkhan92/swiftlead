import 'package:flutter/services.dart' as services;

/// HapticFeedback - Physical touch feedback utility
/// Exact specification from UI_Inventory_v2.5.1
class HapticFeedback {
  static void light() {
    services.HapticFeedback.selectionClick();
  }

  static void medium() {
    services.HapticFeedback.mediumImpact();
  }

  static void heavy() {
    services.HapticFeedback.heavyImpact();
  }

  static void success() {
    services.HapticFeedback.mediumImpact();
  }

  static void error() {
    services.HapticFeedback.heavyImpact();
  }
}

