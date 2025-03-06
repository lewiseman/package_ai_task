import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const paintFont = 'RampartOne';
  static const poppinsFont = 'Poppins';

  static const primaryColor = Color.fromARGB(255, 147, 5, 5);

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      height: 100,
      indicatorColor: Colors.transparent,
    ),
    fontFamily: poppinsFont,
    dividerColor: Colors.grey,
    // textTheme: Typography().white.apply(fontFamily: poppinsFont),
  );
  final x = ThemeData(fontFamily: '');
  ss() {}

  static ThemeData dark = ThemeData.dark().copyWith();
}
