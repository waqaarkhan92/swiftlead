import 'package:flutter/services.dart' as services;

/// HapticFeedback - Physical touch feedback utility
/// Exact specification from UI_Inventory_v2.5.1
/// Enhanced with iOS/Revolut-level variety
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
    // Success: Medium + Light sequence (iOS pattern)
    services.HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 50), () {
      services.HapticFeedback.selectionClick();
    });
  }

  static void error() {
    // Error: Heavy + Light sequence (iOS pattern)
    services.HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 50), () {
      services.HapticFeedback.selectionClick();
    });
  }

  static void warning() {
    // Warning: Medium impact
    services.HapticFeedback.mediumImpact();
  }

  static void notification() {
    // Notification: Light impact
    services.HapticFeedback.selectionClick();
  }

  static void dragStart() {
    // Drag start: Light feedback
    services.HapticFeedback.selectionClick();
  }

  static void dragEnd() {
    // Drag end: Medium feedback
    services.HapticFeedback.mediumImpact();
  }

  static void longPress() {
    // Long press: Heavy feedback
    services.HapticFeedback.heavyImpact();
  }
}

