import 'package:flutter/material.dart';

class AppTheme {
  // 主要颜色
  static const Color primaryColor = Color(0xFF5C6BC0); // 靛蓝色
  static const Color secondaryColor = Color(0xFFFF9800); // 橙色
  static const Color backgroundColor = Color(0xFFF5F5F5); // 浅灰色背景

  // 文本颜色
  static const Color textPrimaryColor = Color(0xFF212121); // 深灰色
  static const Color textSecondaryColor = Color(0xFF757575); // 中灰色
  static const Color textLightColor = Color(0xFFFFFFFF); // 白色

  // 其他颜色
  static const Color successColor = Color(0xFF4CAF50); // 绿色
  static const Color errorColor = Color(0xFFF44336); // 红色
  static const Color shadowColor = Color(0x1A000000); // 阴影颜色

  // 圆角大小
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;

  // 阴影
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // 主题数据
  static ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textLightColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      shadowColor: shadowColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: textPrimaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: textPrimaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: textPrimaryColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: textSecondaryColor,
        fontSize: 14,
      ),
    ),
  );
} 