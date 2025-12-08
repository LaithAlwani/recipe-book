import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_book/features/user/user_model.dart';

class AppUserRepo {
  static final _firestore = FirebaseFirestore.instance;
  static final FirebaseFunctions functions = FirebaseFunctions.instance;

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
    final HttpsCallable callable = functions.httpsCallable('createUser');

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print("❌ User is not signed in");
    } else {
      print("✅ Signed in as ${firebaseUser.uid}");
    }

    try {
      await callable.call({
        'uid': user.uid,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
      // await _userRef.doc(user.uid).set(user);
    } on FirebaseFunctionsException catch (e) {
      print("❌ Firebase Functions error: ${e.code} - ${e.message}");
      rethrow;
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
