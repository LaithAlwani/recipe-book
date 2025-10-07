import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/firebase_options.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/provider/auth_provider.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: Consumer(
        builder: (conetxt, ref, child) {
          final AsyncValue<AppUser?> user = ref.watch(authProvider);
          return user.when(
            data: (value) {
              if (value == null) {
                return const WelcomeScreen();
              }
              return Profilescreen(user: value);
            },
            error: (error, _) => const Text("error loading auth status..."),
            loading: () => const Text("loading ..."),
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
