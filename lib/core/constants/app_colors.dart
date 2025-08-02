import 'package:flutter/material.dart';

class AppColors {
  static const Color kBlack = Color(0xFF000000);
  static const Color kYellow = Color(0xFFFFDD55);
  static const Color kBlue = Color(0xFF106EE8);
  static const Color kTeal = Color(0xFF00C6AE);
  static const Color kOrange = Color(0xFFEB7711);
  static const Color kGreen = Color(0xFF0ACF83);
  static const Color kPurple = Color(0xFFA259FF);

  // Black color variants with opacity
  static const Color black05 = Color.fromRGBO(0, 0, 0, 0.05);
  static const Color black08 = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color black15 = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color black20 = Color.fromRGBO(0, 0, 0, 0.2);
  static const Color black30 = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color black50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color black60 = Color.fromRGBO(0, 0, 0, 0.6);
  static const Color black70 = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color black77 = Color.fromRGBO(0, 0, 0, 0.77);
  static const Color black80 = Color.fromRGBO(0, 0, 0, 0.8);
  static const Color black90 = Color.fromRGBO(0, 0, 0, 0.9);

  // White color variants with opacity
  static const Color white05 = Color.fromRGBO(255, 255, 255, 0.05);
  static const Color white10 = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color white20 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color white30 = Color.fromRGBO(255, 255, 255, 0.3);
  static const Color white40 = Color.fromRGBO(255, 255, 255, 0.4);
  static const Color white50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color white60 = Color.fromRGBO(255, 255, 255, 0.6);
  static const Color white70 = Color.fromRGBO(255, 255, 255, 0.7);
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.8);
  static const Color white90 = Color.fromRGBO(255, 255, 255, 0.9);
  static const Color white93 = Color.fromRGBO(255, 255, 255, 0.93);

  // Yellow color variants with opacity
  static const Color yellow05 = Color.fromRGBO(255, 221, 85, 0.05);
  static const Color yellow10 = Color.fromRGBO(255, 221, 85, 0.1);
  static const Color yellow19 = Color.fromRGBO(255, 221, 85, 0.19);
  static const Color yellow20 = Color.fromRGBO(255, 221, 85, 0.2);
  static const Color yellow30 = Color.fromRGBO(255, 221, 85, 0.3);
  static const Color yellow50 = Color.fromRGBO(255, 221, 85, 0.5);
  static const Color yellow70 = Color.fromRGBO(255, 221, 85, 0.7);
  static const Color yellow80 = Color.fromRGBO(255, 221, 85, 0.8);
  static const Color yellow90 = Color.fromRGBO(255, 221, 85, 0.9);

  // Blue color variants with opacity (16, 110, 232)
  static const Color blue05 = Color.fromRGBO(16, 110, 232, 0.05);
  static const Color blue10 = Color.fromRGBO(16, 110, 232, 0.1);
  static const Color blue20 = Color.fromRGBO(16, 110, 232, 0.2);
  static const Color blue30 = Color.fromRGBO(16, 110, 232, 0.3);
  static const Color blue50 = Color.fromRGBO(16, 110, 232, 0.5);
  static const Color blue70 = Color.fromRGBO(16, 110, 232, 0.7);
  static const Color blue80 = Color.fromRGBO(16, 110, 232, 0.8);
  static const Color blue90 = Color.fromRGBO(16, 110, 232, 0.9);

  // Utility method to create custom opacity colors
  static Color withCustomOpacity(Color color, double opacity) {
    return Color.fromRGBO(
      (color.r * 255.0).round() & 0xff,
      (color.g * 255.0).round() & 0xff,
      (color.b * 255.0).round() & 0xff,
      opacity,
    );
  }
}
