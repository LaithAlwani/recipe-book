import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/services/firestore_services.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    print("🔔 authStateChanges emission → ${user?.uid} at ${DateTime.now()}");
    if (user == null) {
      return null;
    }
    final appUser = await FirestoreService.getUserById(user.uid);
    return appUser;
  });
});



