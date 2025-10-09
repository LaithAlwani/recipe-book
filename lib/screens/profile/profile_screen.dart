import 'package:flutter/material.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/wlecome/welcome.dart';
import 'package:recipe_book/services/auth_service.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key, required this.user});

  final AppUser? user;

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          const Icon(Icons.settings),
          IconButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await AuthService.signOut();
              nav.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyApp()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile"),
            const SizedBox(height: 16),

            //out put user email
            Text("Welcome to profile, ${widget.user!.displayName}"),
            Text("Welcome to profile, ${widget.user!.uid}"),
            Text("Your email address is: ${widget.user!.email}"),
            Text("Your email address is: ${widget.user!.photoUrl}"),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
