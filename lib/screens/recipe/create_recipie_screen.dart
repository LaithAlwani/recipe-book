import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/profile/profile_screen.dart';

class CreateRecipieScreen extends StatelessWidget {
  const CreateRecipieScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Create a New Recipie"));
  }
}
