import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/swiftlead_theme.dart';
import 'screens/main_navigation.dart';

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

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiftlead',
      debugShowCheckedModeBanner: false,
      theme: SwiftleadTheme.lightTheme(),
      darkTheme: SwiftleadTheme.darkTheme(),
      themeMode: _themeMode,
      home: MainNavigation(
        onThemeChanged: setThemeMode,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

