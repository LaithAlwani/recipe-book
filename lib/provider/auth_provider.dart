import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/services/firestore_services.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) {
   return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    // Fetch user document from Firestore
    final snapshot = await FireStoreService.getUserById(user.uid);
    final appUser = snapshot;

    return appUser;
  });
});
