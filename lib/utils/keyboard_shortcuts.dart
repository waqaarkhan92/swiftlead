import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard Shortcuts Utility - Phase 3
/// Provides common keyboard shortcuts for power users

class AppShortcuts {
  // Intent classes for Actions
  static const searchIntent = SearchIntent();
  static const createIntent = CreateIntent();
  static const refreshIntent = RefreshIntent();
  static const closeIntent = CloseIntent();
  static const helpIntent = HelpIntent();
  
  // Screen navigation intents
  static const homeIntent = NavigateIntent('home');
  static const inboxIntent = NavigateIntent('inbox');
  static const jobsIntent = NavigateIntent('jobs');
  static const calendarIntent = NavigateIntent('calendar');
  static const moneyIntent = NavigateIntent('money');
  static const contactsIntent = NavigateIntent('contacts');
  static const reportsIntent = NavigateIntent('reports');
  static const settingsIntent = NavigateIntent('settings');
  
  // Global shortcuts map
  static Map<LogicalKeySet, Intent> get globalShortcuts => {
    // Cmd+K or Ctrl+K: Search/Command palette
    LogicalKeySet(
      Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyK,
    ): searchIntent,
    
    // Cmd+N or Ctrl+N: Create new item
    LogicalKeySet(
      Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyN,
    ): createIntent,
    
    // Cmd+R or Ctrl+R: Refresh
    LogicalKeySet(
      Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
      LogicalKeyboardKey.keyR,
    ): refreshIntent,
    
    // Esc: Close modal/sheet
    LogicalKeySet(LogicalKeyboardKey.escape): closeIntent,
    
    // Cmd+? or Ctrl+?: Show help
    LogicalKeySet(
      Platform.isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control,
      LogicalKeyboardKey.slash,
    ): helpIntent,
  };
  
  // Screen-specific shortcuts
  static Map<LogicalKeySet, Intent> getInboxShortcuts(VoidCallback onCompose) => {
    ...globalShortcuts,
    LogicalKeySet(LogicalKeyboardKey.keyC): ComposeIntent(onCompose),
  };
  
  static Map<LogicalKeySet, Intent> getJobsShortcuts(VoidCallback onCreateJob) => {
    ...globalShortcuts,
    LogicalKeySet(LogicalKeyboardKey.keyN): CreateJobIntent(onCreateJob),
  };
  
  static Map<LogicalKeySet, Intent> getMoneyShortcuts(VoidCallback onCreateInvoice) => {
    ...globalShortcuts,
    LogicalKeySet(LogicalKeyboardKey.keyN): CreateInvoiceIntent(onCreateInvoice),
  };
}

// Intent classes (public for Actions)
class SearchIntent extends Intent {
  const SearchIntent();
}

class CreateIntent extends Intent {
  const CreateIntent();
}

class RefreshIntent extends Intent {
  const RefreshIntent();
}

class CloseIntent extends Intent {
  const CloseIntent();
}

class HelpIntent extends Intent {
  const HelpIntent();
}

class NavigateIntent extends Intent {
  final String screen;
  const NavigateIntent(this.screen);
}

class ComposeIntent extends Intent {
  final VoidCallback onCompose;
  const ComposeIntent(this.onCompose);
}

class CreateJobIntent extends Intent {
  final VoidCallback onCreateJob;
  const CreateJobIntent(this.onCreateJob);
}

class CreateInvoiceIntent extends Intent {
  final VoidCallback onCreateInvoice;
  const CreateInvoiceIntent(this.onCreateInvoice);
}

