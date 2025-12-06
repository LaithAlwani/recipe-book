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
      // navigatorObservers: [LoggingNavigatorObserver()],
      home: _getLandingScreen(authState),
    );
  }

  Widget _getLandingScreen(AuthState authState) {
    print("STATUS = ${authState.status}");
    print("SIGNED IN = ${authState.isSignedIn}");
    print("USER = ${authState.appUser?.displayName}");
    print("Loading = ${authState.isLoading}");
    print("isRegistering = ${authState.isRegistering}");

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

class LoggingNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print(
      'PUSHED: ${route.settings.name}  | previous: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print(
      'POPPED: ${route.settings.name}  | back to: ${previousRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print('REMOVED: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('REPLACED: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
