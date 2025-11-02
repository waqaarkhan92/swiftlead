/// Swiftlead Design Tokens v2.5.1
/// Exact token values from Theme_and_Design_System_v2.5.1_10of10.md

class SwiftleadTokens {
  // Colors - Primary Palette
  static const primaryTeal = 0xFF00C6A2;
  static const accentAqua = 0xFF00DDB0;
  static const successGreen = 0xFF22C55E;
  static const warningYellow = 0xFFFACC15;
  static const errorRed = 0xFFEF4444;
  static const infoBlue = 0xFF3B82F6;

  // Background Gradients
  static const lightBackgroundStart = 0xFFFFFFFF; // #FFFFFF
  static const lightBackgroundEnd = 0xFFF6FAF8; // #F6FAF8 (2% teal hue)
  static const darkBackgroundStart = 0xFF0B0D0D; // #0B0D0D
  static const darkBackgroundEnd = 0xFF131516; // #131516

  // Glass Opacity
  static const double surfaceOpacityLight = 0.88;
  static const double surfaceOpacityDark = 0.78;
  static const double appBarOpacityLight = 0.85;
  static const double appBarOpacityDark = 0.90;
  static const double modalOpacityLight = 0.96;
  static const double modalOpacityDark = 0.88;

  // Blur Strength (sigma)
  static const double blurLight = 24.0;
  static const double blurDark = 26.0;
  static const double blurModal = 28.0;
  static const double blurBottomNav = 30.0;

  // Border Radius
  static const double radiusCard = 20.0;
  static const double radiusButton = 16.0;
  static const double radiusModal = 28.0;
  static const double radiusBottomNav = 28.0;
  static const double radiusChip = 40.0;

  // Shadows
  static const double shadowOpacityLight = 0.06;
  static const double shadowOpacityDark = 0.25;
  static const double shadowBlurLight = 10.0;
  static const double shadowBlurDark = 16.0;

  // Borders
  static const double borderOpacityLight = 0.05;
  static const double borderOpacityDark = 0.08;
  static const double innerGlowOpacity = 0.04;

  // Spacing (4-pt grid)
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Animation Durations
  static const Duration motionInstant = Duration(milliseconds: 100);
  static const Duration motionFast = Duration(milliseconds: 250);
  static const Duration motionMedium = Duration(milliseconds: 300);
  static const Duration motionSlow = Duration(milliseconds: 500);
  static const Duration motionXSlow = Duration(milliseconds: 1000);

  // Button Heights
  static const double buttonHeightLarge = 52.0;
  static const double buttonHeightMedium = 44.0;

  // Text Colors
  static const int textPrimaryLight = 0xFF1A1C1E;
  static const int textPrimaryDark = 0xFFF5F5F5;
  static const int textSecondaryLight = 0xFF4B5563;
  static const int textSecondaryDark = 0xFF9CA3AF;

  // Badge Colors
  static const int badgeCountRed = 0xFFEF4444;
  static const int badgeDotTeal = primaryTeal;
  
  // Toast Duration
  static const Duration toastSuccess = Duration(seconds: 3);
  static const Duration toastError = Duration(seconds: 4);
  static const Duration toastInfo = Duration(seconds: 3);
  static const Duration toastWarning = Duration(seconds: 4);
}

