import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/firebase_options.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/provider/auth_provider.dart';
import 'package:recipe_book/screens/main_layout.dart';
import 'package:recipe_book/screens/onboadring/onboarding_screen.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //  debugPaintSizeEnabled = true;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipie Book',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final AsyncValue<AppUser?> user = ref.watch(authProvider);

          return user.when(
            data: (value) {
              if (value == null) return const WelcomeScreen();
              return OnboardingScreen(user: value);
            },
            error: (error, stack) =>
                Center(child: Text("Error loading auth status: $error")),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
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
