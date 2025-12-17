import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends ConsumerStatefulWidget {
  const ImagePickerWidget({
    super.key,
    required this.onImagesSelected,
    this.maxImages = 1,
    this.initialImageUrls = const [],
  });

  final int maxImages;
  final List<String> initialImageUrls;
  final Function(List<File>) onImagesSelected;

  @override
  ConsumerState<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends ConsumerState<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  late List<String> _existingUrls;
  late List<File> _newImages;

  @override
  void initState() {
    super.initState();
    _existingUrls = List.from(widget.initialImageUrls);
    _newImages = [];
  }

  Future<File?> _processImage(XFile pickedFile) async {
    final originalBytes = await pickedFile.readAsBytes();

    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) return null;

    final resized = img.copyResize(decoded, width: 500);
    final resizedBytes = Uint8List.fromList(
      img.encodeJpg(resized, quality: 80),
    );

    final tempDir = Directory.systemTemp;
    final file = File(
      '${tempDir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await file.writeAsBytes(resizedBytes);
    return file;
  }

  Future<void> _pickImages(ImageSource source) async {
    if (widget.maxImages > 1 && source == ImageSource.gallery) {
      final picked = await _picker.pickMultiImage();
      for (final xFile in picked) {
        if (_newImages.length + _existingUrls.length >= widget.maxImages) break;
        final file = await _processImage(xFile);
        if (file != null) _newImages.add(file);
      }
    } else {
      final picked = await _picker.pickImage(source: source);
      if (picked == null) return;
      final file = await _processImage(picked);
      if (file != null) {
        _newImages
          ..clear()
          ..add(file);
      }
    }

    setState(() {});
    widget.onImagesSelected(_newImages);
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_existingUrls.length + _newImages.length < widget.maxImages)
                InkWell(
                  onTap: _showPicker,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),

              // Existing images (URLs)
              ..._existingUrls.map(
                (url) => _imageTile(
                  Image.network(url, fit: BoxFit.cover),
                  onRemove: () {
                    setState(() => _existingUrls.remove(url));
                  },
                ),
              ),

              ..._newImages.map(
                (file) => _imageTile(
                  Image.file(file, fit: BoxFit.cover),
                  onRemove: () {
                    setState(() => _newImages.remove(file));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _imageTile(Widget image, {required VoidCallback onRemove}) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 120, height: 120, child: image),
      ),
      Positioned(
        top: 0,
        right: 5,
        child: Container(
          width: 32,
          decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(80, 0, 0, 0),
                        ),
          child: IconButton(
            icon: const Icon(Icons.close, size: 24, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            onPressed: onRemove,
          ),
        ),
      ),
    ],
  );
}
                     
                     
                        
                          
