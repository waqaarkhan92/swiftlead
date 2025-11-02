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

class SwiftleadApp extends StatelessWidget {
  const SwiftleadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiftlead',
      debugShowCheckedModeBanner: false,
      theme: SwiftleadTheme.lightTheme(),
      darkTheme: SwiftleadTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

