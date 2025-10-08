import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';

class CreateRecipieScreen extends StatelessWidget {
  const CreateRecipieScreen({super.key, required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Create"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profilescreen(user: user),
                ),
              );
            },
            icon: const Icon(Icons.manage_accounts_sharp),
          ),
        ],
      ),
      body: const Text("Create a New Recipie"),
    );
  }
}
