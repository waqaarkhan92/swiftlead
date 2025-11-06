/// Profession Configuration Utility
/// Provides adaptive terminology and module visibility based on profession
/// Decision Matrix: Module 3.13 - Batch 7: KEEP ALL

enum ProfessionType {
  trade,
  homeServices,
  professionalServices,
  autoServices,
  custom,
}

class ProfessionConfig {
  final ProfessionType profession;
  final Map<String, String> labelOverrides;
  final List<String> visibleModules;
  
  ProfessionConfig({
    required this.profession,
    required this.labelOverrides,
    required this.visibleModules,
  });
  
  // Get label with profession-specific override
  String getLabel(String defaultLabel) {
    final lower = defaultLabel.toLowerCase();
    // Handle plural forms
    if (lower.endsWith('s') && lower.length > 1) {
      final singular = lower.substring(0, lower.length - 1);
      if (labelOverrides.containsKey(singular)) {
        return labelOverrides[singular]! + 's';
      }
    }
    return labelOverrides[lower] ?? defaultLabel;
  }
  
  // Check if module should be visible
  bool isModuleVisible(String moduleName) {
    return visibleModules.contains(moduleName.toLowerCase());
  }
  
  // Profession-specific configurations
  static final Map<ProfessionType, ProfessionConfig> _profiles = {
    ProfessionType.trade: ProfessionConfig(
      profession: ProfessionType.trade,
      labelOverrides: {}, // No overrides for trade
      visibleModules: ['home', 'inbox', 'jobs', 'calendar', 'money'],
    ),
    ProfessionType.homeServices: ProfessionConfig(
      profession: ProfessionType.homeServices,
      labelOverrides: {},
      visibleModules: ['home', 'inbox', 'jobs', 'calendar', 'money'],
    ),
    ProfessionType.professionalServices: ProfessionConfig(
      profession: ProfessionType.professionalServices,
      labelOverrides: {
        'job': 'appointment',
        'jobs': 'appointments',
        'client': 'patient',
        'clients': 'patients',
      },
      visibleModules: ['home', 'inbox', 'calendar', 'money'],
    ),
    ProfessionType.autoServices: ProfessionConfig(
      profession: ProfessionType.autoServices,
      labelOverrides: {},
      visibleModules: ['home', 'inbox', 'jobs', 'calendar', 'money'],
    ),
    ProfessionType.custom: ProfessionConfig(
      profession: ProfessionType.custom,
      labelOverrides: {},
      visibleModules: ['home', 'inbox', 'jobs', 'calendar', 'money'],
    ),
  };
  
  // Get profession configuration
  static ProfessionConfig getProfessionConfig(ProfessionType profession) {
    return _profiles[profession] ?? _profiles[ProfessionType.trade]!;
  }
  
  // Get profession-specific service type templates
  static List<String> getServiceTypeTemplates(ProfessionType profession) {
    switch (profession) {
      case ProfessionType.trade:
        return [
          'Plumbing Repair',
          'Electrical Installation',
          'HVAC Service',
          'Roofing',
          'General Construction',
          'Landscaping',
        ];
      case ProfessionType.homeServices:
        return [
          'House Cleaning',
          'Pest Control',
          'Locksmith',
          'Handyman',
          'Window Cleaning',
          'Carpet Cleaning',
        ];
      case ProfessionType.professionalServices:
        return [
          'Consultation',
          'Treatment',
          'Session',
          'Appointment',
          'Therapy',
          'Assessment',
        ];
      case ProfessionType.autoServices:
        return [
          'Mobile Mechanic',
          'Car Detailing',
          'Towing',
          'Oil Change',
          'Tire Service',
          'Battery Replacement',
        ];
      case ProfessionType.custom:
        return [];
    }
  }
  
  // Get profession-specific custom field templates
  static List<Map<String, String>> getCustomFieldTemplates(ProfessionType profession) {
    switch (profession) {
      case ProfessionType.trade:
        return [
          {'name': 'License Number', 'type': 'text'},
          {'name': 'Permit Number', 'type': 'text'},
          {'name': 'Insurance Policy', 'type': 'text'},
        ];
      case ProfessionType.professionalServices:
        return [
          {'name': 'Treatment Notes', 'type': 'textarea'},
          {'name': 'Consent Form', 'type': 'file'},
          {'name': 'Medical History', 'type': 'textarea'},
        ];
      case ProfessionType.homeServices:
        return [
          {'name': 'Insurance Policy', 'type': 'text'},
          {'name': 'Access Instructions', 'type': 'textarea'},
        ];
      case ProfessionType.autoServices:
        return [
          {'name': 'Vehicle Registration', 'type': 'text'},
          {'name': 'License Plate', 'type': 'text'},
        ];
      case ProfessionType.custom:
        return [];
    }
  }
  
  // Get profession-specific workflow defaults
  static Map<String, dynamic> getWorkflowDefaults(ProfessionType profession) {
    switch (profession) {
      case ProfessionType.trade:
        return {
          'bookingDuration': 120, // 2 hours
          'paymentTerms': 'Due on completion',
          'quoteExpiry': 30, // 30 days
          'reminderTiming': {'24h': true, '1h': true},
        };
      case ProfessionType.professionalServices:
        return {
          'bookingDuration': 60, // 1 hour
          'paymentTerms': 'Due at appointment',
          'quoteExpiry': 7, // 7 days
          'reminderTiming': {'24h': true, '2h': true},
        };
      case ProfessionType.homeServices:
        return {
          'bookingDuration': 90, // 1.5 hours
          'paymentTerms': 'Due on completion',
          'quoteExpiry': 14, // 14 days
          'reminderTiming': {'24h': true, '1h': true},
        };
      case ProfessionType.autoServices:
        return {
          'bookingDuration': 120, // 2 hours
          'paymentTerms': 'Due on completion',
          'quoteExpiry': 30, // 30 days
          'reminderTiming': {'24h': true, '1h': true},
        };
      case ProfessionType.custom:
        return {
          'bookingDuration': 60,
          'paymentTerms': 'Due on completion',
          'quoteExpiry': 30,
          'reminderTiming': {'24h': true, '1h': true},
        };
    }
  }
}

// Global profession state (would be stored in shared preferences or backend in production)
class ProfessionState {
  static ProfessionType _currentProfession = ProfessionType.trade;
  
  static ProfessionType get currentProfession => _currentProfession;
  
  static void setProfession(ProfessionType profession) {
    _currentProfession = profession;
  }
  
  static ProfessionConfig get config => 
    ProfessionConfig.getProfessionConfig(_currentProfession);
}

