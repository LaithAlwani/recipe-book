import 'package:flutter/material.dart';

class SettingsState {
  final Locale? locale;
  final Color backgroundColor;
  final Color fontColor;
  final String fontFamily; // NEW

  const SettingsState({
    this.locale,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.black,
    this.fontFamily = 'Roboto', // default font
  });

  SettingsState copyWith({
    Locale? locale,
    Color? backgroundColor,
    Color? fontColor,
    String? fontFamily,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontColor: fontColor ?? this.fontColor,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
