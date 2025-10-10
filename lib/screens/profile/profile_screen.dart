import 'package:flutter/material.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/profile/settings_screen.dart';
import 'package:recipe_book/services/auth_service.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key, required this.user});

  final AppUser user;

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
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
          }, icon: const Icon(Icons.settings)),
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

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  widget.user?.photoUrl != null &&
                      widget.user!.photoUrl!.isNotEmpty
                  ? NetworkImage(widget.user!.photoUrl!)
                  : const AssetImage('assets/images/avatar_placeholder.png')
                        as ImageProvider,
            ),
            //out put user email
            Text(widget.user.displayName),
            Text(widget.user!.email),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
