import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:recipe_book/services/firestore_services.dart';

class AuthViewModel extends AsyncNotifier<AppUser?> {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FutureOr<AppUser?> build() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    final appUser = FirestoreService.getUserById(firebaseUser.uid);
    return appUser;
  }
}
