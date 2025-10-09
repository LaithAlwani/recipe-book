import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/screens/main_layout.dart';

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
  ImageProvider? _selectedImage;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainLayout(user: widget.user)),
    );
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
                children: [_buildNameStep(), _buildImageStep()],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameStep() {
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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Display Name",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "add a profile photo?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 12),

          TextButton(
            onPressed: _showImagePickerOptions,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _selectedImageFile != null
                      ? FileImage(_selectedImageFile!)
                      : null,
                  child: _selectedImageFile == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null,
                ),
                // CircleAvatar(
                //   radius: 50,
                //   backgroundImage: _selectedImage,
                //   child: _selectedImage == null
                //       ? const Icon(Icons.add_a_photo, size: 40)
                //       : null,
                // ),
                const SizedBox(height: 20),
                const Text("Choose an Image"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildGenderStep() {
  //   return Padding(
  //     padding: const EdgeInsets.all(24.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           "How do you identify?",
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 24),
  //         Wrap(
  //           spacing: 12,
  //           children: ["Male", "Female", "Other"].map((gender) {
  //             final isSelected = _selectedGender == gender;
  //             return ChoiceChip(
  //               label: Text(gender),
  //               selected: isSelected,
  //               onSelected: (_) => setState(() => _selectedGender = gender),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
