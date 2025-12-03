import 'package:flutter/material.dart';
import 'package:recipe_book/utils/seed_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          FirestoreSeeder.seedData();
        },
        child: const Text("Seed Datebase"),
      ),
    );
  }
}
