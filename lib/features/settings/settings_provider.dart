import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/settings/settings_state.dart';
import 'package:recipe_book/features/settings/settings_view_model.dart';

final settingsProvider = NotifierProvider<SettingsViewModel, SettingsState>(
  () => SettingsViewModel(),
);
