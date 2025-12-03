import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authNotifierProvider);
    if (authState.status == AuthStatus.unauthenticated) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      });
      return const SizedBox.shrink();
    }
    final AppUser user = authState.appUser!;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profilescreen()),
              );
            },

            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? NetworkImage(user.photoUrl!)
                  : const AssetImage('assets/images/avatar_placeholder.png')
                        as ImageProvider,
            ),
          ),
          IconButton(
            onPressed: () async {
              final homeVM = ref.read(authNotifierProvider.notifier);
              await homeVM.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
