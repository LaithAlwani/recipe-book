import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/firebase_options.dart';
import 'package:recipe_book/l10n/app_localizations.dart';
import 'package:recipe_book/shared/main_layout.dart';
import 'package:recipe_book/features/onboadrding/ui/onboarding_screen.dart';
import 'package:recipe_book/features/auth/ui/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  const bool useEmulator = true;
  if (kDebugMode && useEmulator) {
    const emulatorHost = '192.168.86.29'; //192.168.2.137
    // const emulatorHost = '192.168.2.137'; //192.168.2.137
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
      FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      final functions = FirebaseFunctions.instanceFor(app: Firebase.app());
      functions.useFunctionsEmulator(emulatorHost, 5001);
    } catch (err) {
      debugPrint("error in firebase emulator $err");
    }
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authNotifierProvider);
    return MaterialApp(
      title: 'Recipie Book',
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.primaryAccent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: AppColors.primaryAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundColor,
        ),
      ),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // navigatorObservers: [LoggingNavigatorObserver()],
      home: _getLandingScreen(authState),
    );
  }

  Widget _getLandingScreen(AuthState authState) {
    switch (authState.status) {
      case AuthStatus.loading:
        return const Scaffold(
          body: const Center(child: CircularProgressIndicator()),
        );

      case AuthStatus.unauthenticated:
        return const WelcomeScreen();

      case AuthStatus.error:
        return const WelcomeScreen();

      case AuthStatus.authenticated:
        // If this user is new and has no appUser data → onboarding

        if (authState.isRegistering) {
          return const OnboardingScreen();
        }
        return const MainLayout(); // Normal signed-in user
    }
  }
}
