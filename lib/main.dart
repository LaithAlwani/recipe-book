import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/firebase_options.dart';
import 'package:recipe_book/screens/main_layout.dart';
import 'package:recipe_book/screens/onboadring/onboarding_screen.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
      home: _getLandingScreen(authState),
    );
  }

  Widget _getLandingScreen(AuthState authState) {
    if (authState.isRegistering && authState.firebaseUser != null) {
      return const OnboardingScreen();
    }

    if (authState.isSignedIn) {
      return const MainLayout();
    }

    return const WelcomeScreen();
  }
}

class SandBox extends StatelessWidget {
  const SandBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sand box"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: const Text("Sand Box"),
    );
  }
}
