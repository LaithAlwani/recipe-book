import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/features/settings/settings_provider.dart';
import 'package:recipe_book/features/user/user_model.dart';
import 'package:recipe_book/features/user/ui/profile_screen.dart';
import 'package:recipe_book/l10n/app_localizations.dart';
import 'package:recipe_book/theme.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authNotifierProvider);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final AppUser? user = authState.appUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings_title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profilescreen(),
                  ),
                );
              },
              child: ClipOval(
                child: Image.network(
                  user?.photoUrl ?? "",
                  width: 60 * 2,
                  height: 60 * 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (user?.displayName ?? "").toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(user?.email ?? ""),
            const Expanded(child: SizedBox()),
            ListTile(
              title: Text(AppLocalizations.of(context)!.settings_language),
              trailing: DropdownButton<Locale>(
                value: settings.locale ?? const Locale('en'),
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                  DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                ],
                onChanged: (locale) {
                  if (locale != null) notifier.setLocale(locale);
                },
              ),
            ),
            ListTile(
              title: const Text("Background Color"),
              trailing: IconButton(
                icon: Icon(Icons.color_lens, color: settings.fontColor),
                onPressed: () {
                  // Example: cycle between white and grey
                  final newColor = settings.backgroundColor == Colors.white
                      ? AppColors.backgroundColor
                      : Colors.white;
                  notifier.setBackgroundColor(newColor);
                },
              ),
            ),
            ListTile(
              title: const Text("Font Color"),
              trailing: IconButton(
                icon: Icon(Icons.format_color_text, color: settings.fontColor),
                onPressed: () {
                  // Example: cycle between black and blue
                  final newColor = settings.fontColor == Colors.black
                      ? AppColors.primaryColor
                      : Colors.black;
                  notifier.setFontColor(newColor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
