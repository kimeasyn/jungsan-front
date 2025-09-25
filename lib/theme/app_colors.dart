import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6B2C);
  static const Color secondary = Color(0xFFFFC542);
  static const Color accent = Color(0xFF4CAF50);
  
  // Neutral Colors
  static const Color neutralLight = Color(0xFFF5F6F8);
  static const Color neutralDark = Color(0xFF333333);
  static const Color neutralMedium = Color(0xFF666666);
  static const Color neutralLightGray = Color(0xFFE5E5E5);
  
  // Status Colors
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF4285F4);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color card = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Border Colors
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderFocus = Color(0xFFFF6B2C);
  
  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
