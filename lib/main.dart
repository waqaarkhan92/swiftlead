import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/swiftlead_theme.dart';
import 'screens/main_navigation.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'config/mock_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const SwiftleadApp());
}

class SwiftleadApp extends StatefulWidget {
  const SwiftleadApp({super.key});

  @override
  State<SwiftleadApp> createState() => _SwiftleadAppState();
}

class _SwiftleadAppState extends State<SwiftleadApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;
  bool _showOnboarding = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndOnboardingStatus();
  }

  Future<void> _checkAuthAndOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check authentication status
    // In production: Check Supabase auth session
    // For now: Check if user is logged in (mock auth)
    final isAuthenticated = prefs.getBool('user_authenticated') ?? false;
    
    // Only check onboarding if authenticated (or in test mode)
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    
    setState(() {
      _isAuthenticated = isAuthenticated || kTestMode; // In test mode, skip auth check
      _showOnboarding = _isAuthenticated && !onboardingCompleted;
      _isLoading = false;
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'Swiftlead',
        debugShowCheckedModeBanner: false,
        theme: SwiftleadTheme.lightTheme(),
        darkTheme: SwiftleadTheme.darkTheme(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // Determine which screen to show
    Widget homeScreen;
    
    if (!_isAuthenticated && !kTestMode) {
      // Show login if not authenticated (production mode)
      homeScreen = const LoginScreen();
    } else if (_showOnboarding) {
      // Show onboarding if authenticated but onboarding not completed
      homeScreen = const OnboardingScreen();
    } else {
      // Show main app
      homeScreen = MainNavigation(
        onThemeChanged: setThemeMode,
        currentThemeMode: _themeMode,
      );
    }

    return MaterialApp(
      title: 'Swiftlead',
      debugShowCheckedModeBanner: false,
      theme: SwiftleadTheme.lightTheme(),
      darkTheme: SwiftleadTheme.darkTheme(),
      themeMode: _themeMode,
      home: homeScreen,
    );
  }
}

