import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsViewModel extends Notifier<SettingsState> {
  static const _localeKey = 'locale';
  static const _bgColorKey = 'background_color';
  static const _fontColorKey = 'font_color';

  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsState();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final localeCode = prefs.getString(_localeKey);

    final bgColorValue = prefs.getInt(_bgColorKey);
    final fontColorValue = prefs.getInt(_fontColorKey);

    state = state.copyWith(
      locale: localeCode != null ? Locale(localeCode) : null,
      backgroundColor: bgColorValue != null
          ? Color(bgColorValue)
          : AppColors.backgroundColor,
      fontColor: fontColorValue != null
          ? Color(fontColorValue)
          : AppColors.primaryColor,
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setBackgroundColor(Color color) async {
    state = state.copyWith(backgroundColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgColorKey, color.toARGB32());
  }

  Future<void> setFontColor(Color color) async {
    state = state.copyWith(fontColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontColorKey, color.toARGB32());
  }
}
