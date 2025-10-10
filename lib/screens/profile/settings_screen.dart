import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key, required this.user});
  final AppUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: const Center(child: Text("Settings Page")),
    );
  }
}
