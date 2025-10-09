import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/app_user.dart';

class FireStoreService {
  static final ref = FirebaseFirestore.instance
      .collection("users")
      .withConverter(
        fromFirestore: AppUser.fromFireStore,
        toFirestore: (AppUser a, _) => a.toFireStore(),
      );

  static Future<void> createUser(AppUser user) async {
    print(user);
    return await ref.doc(user.uid).set(user);
  }

  static Future<DocumentSnapshot<AppUser?>> getUserById(String uid) async {
    final userDoc = ref.doc(uid);
    return await userDoc.get();
  }
}
