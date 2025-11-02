import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tokens.dart';

/// Swiftlead Theme System v2.5.1
/// Implements Revolut × iOS premium aesthetic exactly as specified

class SwiftleadTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: const Color(SwiftleadTokens.primaryTeal),
        secondary: const Color(SwiftleadTokens.accentAqua),
        error: const Color(SwiftleadTokens.errorRed),
        surface: Colors.white.withOpacity(SwiftleadTokens.surfaceOpacityLight),
        background: const Color(SwiftleadTokens.lightBackgroundStart),
      ),
      
      scaffoldBackgroundColor: const Color(SwiftleadTokens.lightBackgroundStart),
      
      // Typography (SF Pro Display / Inter fallback)
      textTheme: TextTheme(
        // Display XL - Dashboard stats
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.2,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Headline L - Screen titles
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          height: 1.21,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Headline M - Section headers
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.27,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Headline S - Subsection headers
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
          height: 1.33,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Body L - Paragraph text
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
          height: 1.5,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Body S - Secondary text
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.43,
          color: const Color(SwiftleadTokens.textSecondaryLight),
        ),
        
        // Label - Buttons, tags
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02, // 2% tracking
          height: 1.23,
          color: const Color(SwiftleadTokens.textPrimaryLight),
        ),
        
        // Button Large - Primary button text
        labelLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Colors.white,
        ),
        
        // Caption - Sub-labels
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.17,
          color: const Color(SwiftleadTokens.textSecondaryLight),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        color: Colors.white.withOpacity(SwiftleadTokens.surfaceOpacityLight),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          minimumSize: const Size(double.infinity, SwiftleadTokens.buttonHeightLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          ),
          side: BorderSide(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.35),
            width: 1.0,
          ),
          foregroundColor: const Color(SwiftleadTokens.primaryTeal),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.88),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(SwiftleadTokens.borderOpacityLight),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(SwiftleadTokens.borderOpacityLight),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: const BorderSide(
            color: Color(0xFF0FD6C7), // Aqua focus ring
            width: 2.0,
          ),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(SwiftleadTokens.appBarOpacityLight),
        foregroundColor: const Color(SwiftleadTokens.textPrimaryLight),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: const Color(SwiftleadTokens.primaryTeal),
        secondary: const Color(SwiftleadTokens.accentAqua),
        error: const Color(0xFFF87171),
        surface: const Color(0xFF131516).withOpacity(SwiftleadTokens.surfaceOpacityDark),
        background: const Color(SwiftleadTokens.darkBackgroundStart),
      ),
      
      scaffoldBackgroundColor: const Color(SwiftleadTokens.darkBackgroundStart),
      
      // Typography (same structure, different colors)
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.2,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          height: 1.21,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          height: 1.27,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
          height: 1.33,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.1,
          height: 1.5,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.43,
          color: const Color(SwiftleadTokens.textSecondaryDark),
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          height: 1.23,
          color: const Color(SwiftleadTokens.textPrimaryDark),
        ),
        labelLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.17,
          color: const Color(SwiftleadTokens.textSecondaryDark),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        color: const Color(0xFF131516).withOpacity(SwiftleadTokens.surfaceOpacityDark),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          minimumSize: const Size(double.infinity, SwiftleadTokens.buttonHeightLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          ),
          side: BorderSide(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.35),
            width: 1.0,
          ),
          foregroundColor: const Color(SwiftleadTokens.accentAqua),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF131516).withOpacity(0.78),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(SwiftleadTokens.borderOpacityDark),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(SwiftleadTokens.borderOpacityDark),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
          borderSide: const BorderSide(
            color: Color(0xFF0FD6C7), // Aqua focus ring
            width: 2.0,
          ),
        ),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: const Color(0xFF131516).withOpacity(SwiftleadTokens.appBarOpacityDark),
        foregroundColor: const Color(SwiftleadTokens.textPrimaryDark),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}

