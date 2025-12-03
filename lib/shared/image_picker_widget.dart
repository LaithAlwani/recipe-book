import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';

class ImagePickerWidget extends ConsumerStatefulWidget {
  const ImagePickerWidget({super.key, required this.onImageSelected});

  final Function(File?) onImageSelected;

  @override
  ConsumerState<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends ConsumerState<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      widget.onImageSelected(File(pickedFile.path));
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final firebaseUser = authState.firebaseUser!;
    final photoUrl = firebaseUser.photoURL;

    ImageProvider? backgroundImage;
    if (_selectedImageFile != null) {
      backgroundImage = FileImage(_selectedImageFile!);
    } else if (photoUrl != null && photoUrl.isNotEmpty) {
      backgroundImage = NetworkImage(photoUrl);
    }

    return TextButton(
      onPressed: _showImagePickerOptions,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 20),
          const Text("Choose an Image"),
        ],
      ),
    );
  }
}
