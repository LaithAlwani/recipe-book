import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/settings/profile_screen.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authNotifierProvider);
    // if (authState.status == AuthStatus.unauthenticated) {
    //   Future.microtask(() {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    //     );
    //   });
    //   return const SizedBox.shrink();
    // }

    final AppUser? user = authState.appUser;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: Center(
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
            IconButton(
              onPressed: () async {
                final homeVM = ref.read(authNotifierProvider.notifier);
                await homeVM.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false, // remove all previous routes
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
