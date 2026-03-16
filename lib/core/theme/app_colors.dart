import 'package:flutter/material.dart';

class AppColors {
  // Semantic aliases for game-specific UI elements
  static const Color menuBackground = greenLight;
  static const Color badgeBackground = greenDarker;
  static const Color badgeText = gold;
  static const Color badgeTransparentBackground = brown;
  static const Color badgeTransparentText = gold;
  static const Color tileBackground = greenNormal;
  static const Color tileBorder = Colors.grey;
  static const Color tileShadow = brown;
  static const Color iconColor = brown;
  static const Color shadow = Color(0x1F000000);

  static const Color greenLight = Color(0xFFE7F3DE);
  static const Color greenNormal = Color(0xFFC1DFAE);
  static const Color greenDark = Color(0xFF63B944);
  static const Color greenDarker = Color(0xFF35762C);
  static const Color brown = Color(0xFF2C0801);
  static const Color gold = Color(0xFFFFC20F);

  static const Color white = Color(0xFFF8F3E6);
  static const Color red = Color(0xFFEB1D2E);
  static const Color purple = Color(0xFF773C93);
  static const Color yellow = Color(0xFFFBC217);
  static const Color black = Color(0xFF231F20);

  static final Map<String, Color> colors = {
    'white': white,
    'red': red,
    'purple': purple,
    'yellow': yellow,
  };

  static Color findColorByName(String color) {
    return colors[color] ?? Colors.transparent;
  }

  static String findColorName(Color color) {
    return colors.entries
        .firstWhere(
          (entry) => entry.value == color,
          orElse: () => const MapEntry('', Colors.transparent),
        )
        .key;
  }
}
