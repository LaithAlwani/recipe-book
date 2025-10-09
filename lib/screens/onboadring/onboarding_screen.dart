import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/main_layout.dart';
import 'package:recipe_book/screens/onboadring/onboadring_name.dart';
import 'package:recipe_book/screens/onboadring/onboarding_image.dart';
import 'package:recipe_book/shared/image_picker_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.user});

  final AppUser? user;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImageFile;

  final int totalPages = 2;

  void _nextPage() {
    if (_currentPage < totalPages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _submitOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitOnboarding() {
    // Save user data (to Firestore, local storage, etc.)
    debugPrint("Name: ${_nameController.text}");
    debugPrint("Image: $_selectedImageFile");

    // Navigate to home
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => MainLayout(user: widget.user)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  OnboadringName(nameController: _nameController ),
                  OnboardingImage(
                    selectedImage: (file) {
                      _selectedImageFile = file;
                    },
                  ),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentPage > 0 ? _previousPage : null,
            style: TextButton.styleFrom(
              foregroundColor: _currentPage > 0 ? Colors.blue : Colors.grey,
            ),
            child: const Text("Back"),
          ),

          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(_currentPage == totalPages - 1 ? "Finish" : "Next"),
          ),
        ],
      ),
    );
  }
}
