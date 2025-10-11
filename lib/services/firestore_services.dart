import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/app_user.dart';


class FirestoreService {
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
    try {
      await _userRef.doc(uid).update(data);
    } catch (e) {
      print("❌ Error updating user: $e");
      rethrow;
    }
  }

  /// Delete user document
  static Future<void> deleteUser(String uid) async {
    try {
      await _userRef.doc(uid).delete();
    } catch (e) {
      print("❌ Error deleting user: $e");
      rethrow;
    }
  }

  /// Stream of user updates (for real-time profile changes)
  static Stream<AppUser?> streamUser(String uid) {
  return _userRef.doc(uid).snapshots().map((snapshot) {
    if (!snapshot.exists) return null;
    return snapshot.data();
  });
}
}

