/// Mock Configuration for Swiftlead
///
/// Controls whether the app uses mock data or live backend integration.
/// Set kUseMockData = true for offline preview and development.
/// Set kUseMockData = false for live backend integration with Supabase.

/// Global mock data toggle
///
/// When true: All repositories and services use mock data only
/// When false: Services connect to live Supabase backend
const bool kUseMockData = true;

/// Mock configuration class for additional settings
class MockConfig {
  /// Whether to use mock data globally
  static const bool useMockData = kUseMockData;

  /// Simulate network delay for realistic preview
  static const bool simulateNetworkDelay = true;

  /// Network delay duration in milliseconds
  static const int networkDelayMs = 300;

  /// Whether to show mock data indicators in UI
  static const bool showMockIndicators = true;

  /// Whether to log mock data operations
  static const bool logMockOperations = true;
}

/// Helper to simulate network delay
Future<void> simulateDelay() async {
  if (MockConfig.simulateNetworkDelay) {
    await Future.delayed(
      Duration(milliseconds: MockConfig.networkDelayMs),
    );
  }
}

/// Helper to log mock operations
void logMockOperation(String operation) {
  if (MockConfig.logMockOperations) {
    print('[MOCK] $operation');
  }
}
