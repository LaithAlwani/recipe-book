import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser? user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return const Material(child: Text("HomeScreen"));
  }
}
