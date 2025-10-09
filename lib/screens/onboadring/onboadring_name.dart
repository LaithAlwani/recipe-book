
import 'package:flutter/material.dart';

class OnboadringName extends StatelessWidget {
  const OnboadringName({super.key, required this.nameController});
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What's your display name?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Display Name",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
