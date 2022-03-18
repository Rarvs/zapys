import 'package:flutter/material.dart';
import 'package:zapys/constants/styles.dart';

class CustomTheme {
  static final ThemeData defaultTheme = _buildCustomTheme();

  static ThemeData _buildCustomTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        buttonTheme: base.buttonTheme.copyWith(
          buttonColor: secondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        scaffoldBackgroundColor: backgroundColor,
        cardColor: backgroundColor,
        backgroundColor: backgroundColor,
        floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
          backgroundColor: secondaryColor,
          foregroundColor: secondaryTextColor,
        ));
  }
}
