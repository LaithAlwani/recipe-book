import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  //ToDo: create this function in the firebase functions
  static final _storage = FirebaseStorage.instance.ref();

  static Future<String> uploadImageAndGetUrl(File file, String uid) async {
    final ref = _storage
        .child("user_profiles")
        .child(uid)
        .child("${DateTime.now().millisecondsSinceEpoch}-$uid.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<String> uploadRecipeImage({
    required File file,
    required String recipeId,
  }) async {
    final imageId = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = _storage
        .child('recipes')
        .child(recipeId)
        .child('images')
        .child('$imageId.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
