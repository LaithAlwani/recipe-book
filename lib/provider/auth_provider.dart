import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/services/firestore_services.dart';

final authProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncExpand((user) {
    print("Auth state changed → ${user?.uid}");
    if (user == null) {
      return Stream.value(null);
    }
    return FirestoreService.streamUser(user.uid);
  });
});
