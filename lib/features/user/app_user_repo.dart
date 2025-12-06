import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/user/user_model.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class AppUserRepo {
  static final _firestore = FirebaseFirestore.instance;

  /// Users collection with typed converter
  static final _userRef = _firestore
      .collection("users")
      .withConverter<AppUser>(
        fromFirestore: AppUser.fromFirestore,
        toFirestore: (AppUser user, _) => user.toFirestore(),
      );

  /// Create or overwrite a user
  static Future<void> createUser(AppUser user) async {
    //ToDo: create a firebase function call to create the new user in the back end;
    try {
      await _userRef.doc(user.uid).set(user);
    } catch (e) {
      print("❌ Error creating user: $e");
      rethrow;
    }
  }

  /// Get a user by their UID
  static Future<AppUser?> getUserById(String uid) async {
    try {
      final userDoc = await _userRef.doc(uid).get();
      if (!userDoc.exists) return null;
      return userDoc.data();
    } catch (e) {
      print("❌ Error fetching user: $e");
      return null;
    }
  }

  /// Update user partially
  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    //ToDo: create this function in the firebase functions
    try {
      await _userRef.doc(uid).update(data);
    } catch (e) {
      print("❌ Error updating user: $e");
      rethrow;
    }
  }

  /// Delete user document
  static Future<void> deleteUser(String uid) async {
    //ToDo: create this function in the firebase functions
    try {
      await _userRef.doc(uid).delete();
    } catch (e) {
      print("❌ Error deleting user: $e");
      rethrow;
    }
  }

  

  
}
