import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/services/auth_service.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue[500],
        actions: [
          const Icon(Icons.settings, color: Colors.white,),
          IconButton(
            onPressed: () async {
              await AuthService.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
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
            Text("Welcome to profile, ${user.email}"),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
