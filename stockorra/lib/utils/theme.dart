import 'package:flutter/material.dart';

class AppTheme {
  // Primary color palette based on the Figma designs (green theme)
  static const Color primaryColor = Color(0xFF2E6934);
  static const Color secondaryColor = Color(0xFF1A4B1E);
  static const Color accentColor = Color(0xFF529158);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFE2EBD8);
  static const Color cardColor = Color(0xFFDCE6D1);
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF4D4D4D);
  static const Color textLightColor = Color(0xFF808080);
  
  // Button colors
  static const Color buttonPrimaryColor = Color(0xFF2E6934);
  static const Color buttonSecondaryColor = Color(0xFF529158);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color disabledButtonColor = Color(0xFFBDBDBD);
  
  // Social login colors
  static const Color facebookColor = Color(0xFF3B5998);
  static const Color googleColor = Color(0xFF4285F4);
  static const Color appleColor = Color(0xFF000000);
  
  // Success, error and warning colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFF44336);
  
  // Neutral colors
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFF9E9E9E);
  static const Color lightGreyColor = Color(0xFFE0E0E0);
  static const Color darkColor = Color(0xFF212121);
  
  // Shadow
  static final BoxShadow defaultShadow = BoxShadow(
    color: darkColor.withOpacity(0.1),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );
  
  // Text styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.3,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.4,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    height: 1.5,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: whiteColor,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle captionText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLightColor,
    height: 1.5,
  );
  
  // Input decoration based on Figma designs
  static InputDecoration inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: bodyMedium.copyWith(color: textLightColor),
      filled: true,
      fillColor: cardColor,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: textLightColor) : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon, color: textLightColor),
              onPressed: onSuffixIconPressed,
            )
          : null,
      errorText: errorText,
      errorStyle: bodySmall.copyWith(color: errorColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
    );
  }
  
  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: buttonPrimaryColor,
    foregroundColor: whiteColor,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    textStyle: buttonText,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  );
  
  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: buttonPrimaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    textStyle: buttonText.copyWith(color: buttonPrimaryColor),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: buttonPrimaryColor, width: 1.5),
    ),
    elevation: 0,
  );
  
  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: buttonPrimaryColor,
    textStyle: bodyMedium.copyWith(
      color: buttonPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );
  
  static final ButtonStyle socialButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: cardColor,
    foregroundColor: textPrimaryColor,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    textStyle: bodyMedium.copyWith(fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
  );
  
  // Card style
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
  );
  
  // App theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: textPrimaryColor),
      titleTextStyle: titleMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardColor,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentColor, width: 1),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: headingLarge,
      displayMedium: headingMedium,
      displaySmall: headingSmall,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      error: errorColor,
      surface: cardColor,
      onPrimary: whiteColor,
      onSecondary: whiteColor,
      onSurface: textPrimaryColor,
      onError: whiteColor,
      brightness: Brightness.light,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: whiteColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}