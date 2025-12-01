import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';
import 'package:recipe_book/services/auth_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.user});
  final AppUser user;
  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(
                  builder: (context) => Profilescreen(user: user),
                ),
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
              await AuthService.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
