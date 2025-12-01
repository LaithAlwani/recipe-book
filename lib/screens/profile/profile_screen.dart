import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? NetworkImage(user.photoUrl!)
                  : const AssetImage('assets/images/avatar_placeholder.png')
                        as ImageProvider,
            ),
            //out put user email
            Text(user.displayName),
            Text(user.email),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
