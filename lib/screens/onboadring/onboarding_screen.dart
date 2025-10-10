import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/main_layout.dart';
import 'package:recipe_book/screens/onboadring/onboadring_name.dart';
import 'package:recipe_book/screens/onboadring/onboarding_bottom_navbar.dart';
import 'package:recipe_book/screens/onboadring/onboarding_image.dart';
import 'package:recipe_book/services/firestore_services.dart';
import 'package:recipe_book/services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.user});

  final AppUser? user;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _totalPages = 2;
  final PageController _controller = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImageFile;

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
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

  void _submitOnboarding() async {
    String? imageUrl;
    // Save user data (to Firestore, local storage, etc.)
    debugPrint("Name: ${_nameController.text}");
    debugPrint("Image: $_selectedImageFile");
    if (_selectedImageFile != null) {
      imageUrl = await StorageService.uploadImageAndGetUrl(
        _selectedImageFile!,
        widget.user!.uid,
      );
    }
    AppUser user = AppUser(
      uid: widget.user!.uid,
      email: widget.user!.email,
      displayName: _nameController.text,
      photoUrl: imageUrl,
    );

    try {
      await FireStoreService.createUser(user);
      // ✅ Success — navigate to main layout
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainLayout(user: user)),
      );
    } catch (e) {
      // ❌ Error — show a message
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create user: $e")));
    }
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
                  OnboadringName(nameController: _nameController),
                  OnboardingImage(
                    selectedImage: (file) {
                      _selectedImageFile = file;
                    },
                  ),
                ],
              ),
            ),
            OnboardingBottomNavbar(
              totalPages: _totalPages,
              currentPage: _currentPage,
              perviousPage: _previousPage,
              onNextPage: _nextPage,
            ),
          ],
        ),
      ),
    );
  }
}
