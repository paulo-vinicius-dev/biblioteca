import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle listTitleDefaultTextStyle = TextStyle(
      color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600);
  static const TextStyle listTitleSelectedTextStyle = TextStyle(
      color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700);

  static Color selectedColor(context) => Theme.of(context).primaryColorDark;
  static const drawerBackgroundColor = Colors.white;

  static const scaffoldBackgroundColor = Color(0xFFF0F0F0);

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff262A4F),
  );
}
