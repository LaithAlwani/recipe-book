import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/features/user/user_model.dart';
import 'package:recipe_book/features/onboadrding/ui/onboadring_name.dart';
import 'package:recipe_book/features/onboadrding/ui/onboarding_bottom_navbar.dart';
import 'package:recipe_book/features/onboadrding/ui/onboarding_image.dart';
import 'package:recipe_book/services/storage_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  User? _currentUser;
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

    final authVM = ref.read(authNotifierProvider.notifier);
    if (_selectedImageFile != null) {
      imageUrl = await StorageService.uploadImageAndGetUrl(
        _selectedImageFile!,
        _currentUser!.uid,
      );
    } else if (_currentUser?.photoURL != null) {
      imageUrl = _currentUser?.photoURL;
    }
    AppUser user = AppUser(
      uid: _currentUser!.uid,
      email: _currentUser!.email!,
      displayName: _nameController.text,
      photoUrl: imageUrl,
    );

    try {
      await authVM.createNewUser(user);
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
    final AuthState authState = ref.watch(authNotifierProvider);
    final User firebaseUser = authState.firebaseUser!;

    _currentUser = firebaseUser;
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
