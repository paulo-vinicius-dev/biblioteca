import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle listTitleDefaultTextStyle = TextStyle(
      color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600);
  static const TextStyle listTitleSelectedTextStyle = TextStyle(
      color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700);

  static Color selectedColor(context) => Theme.of(context).primaryColorDark;
  static const drawerBackgroundColor = Colors.white;
  static const appBarBackGroundColor = Color.fromARGB(179, 255, 255, 255);
  static const scaffoldBackgroundColor = Color(0xFFF0F0F0);
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xff262A4F),
  );

  static ButtonStyle btnPrimary(context) => ElevatedButton.styleFrom(
        overlayColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static TextStyle btnPrimaryText(context) =>
      TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 18);
}
