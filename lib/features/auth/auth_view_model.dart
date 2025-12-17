import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/firebase_options.dart';
import 'package:recipe_book/features/user/user_model.dart';
import 'package:recipe_book/features/user/app_user_repo.dart';

class AuthViewModel extends Notifier<AuthState> {
  final _auth = FirebaseAuth.instance;

  @override
  AuthState build() {
    state = AuthState.initial();
    _init();
    return state;
  }

  Future<void> _init() async {
    final user = _auth.currentUser;

    if (user == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    state = state.copyWith(status: AuthStatus.loading, isLoading: true);

    try {
      final appUser = await AppUserRepo.getUserById(user.uid);
      if (appUser != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: user,
          appUser: appUser,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: user,
          isRegistering: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ---------------------------
  // REGISTER
  // ---------------------------
  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, status: AuthStatus.loading);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: "User registration failed",
        );
      }
      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: userCredential.user,
        appUser: null,
        isRegistering: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ---------------------------
  //google login
  // ---------------------------
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, status: AuthStatus.loading);
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: DefaultFirebaseOptions.serverClientId,
      );
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential credential = await _auth.signInWithCredential(
        googleCredential,
      );

      final User? user = credential.user;
      if (user == null)
        throw Exception("No user returned from Google Sign-In.");

      final AppUser? exsistingUser = await AppUserRepo.getUserById(user.uid);
      if (exsistingUser == null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          firebaseUser: credential.user,
          isRegistering: true,
          isSignedIn: true,
          appUser: null,
        );
        return;
      }
      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: credential.user,
        appUser: exsistingUser,
        isSignedIn: true,
        isRegistering: false,
      );
    } catch (err) {
      debugPrint(err.toString());
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: err.toString(),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ---------------------------
  // LOGIN
  // ---------------------------

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, status: AuthStatus.loading);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final appUser = await AppUserRepo.getUserById(userCredential.user!.uid);
      state = state.copyWith(errorMessage: "user data not found");

      state = state.copyWith(
        status: AuthStatus.authenticated,
        firebaseUser: userCredential.user,
        appUser: appUser,
        isSignedIn: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //--------------
  //create a new User
  //-------------

  Future<bool> createNewUser(AppUser user) async {
    state = state.copyWith(isLoading: true);
    final FirebaseFunctions functions = FirebaseFunctions.instance;

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

      state = state.copyWith(appUser: user, isRegistering: false);
      return true;
    } catch (err) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: err.toString(),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // ---------------------------
  // SIGNOUT
  // ---------------------------

  Future<void> signOut() async {
    state = state.copyWith(
      isSigingOut: true,
      isLoading: true,
      status: AuthStatus.loading,
    );

    try {
      await _auth.signOut();
      state = AuthState.initial();
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      state = state.copyWith(isSigingOut: false, isLoading: false);
    }
  }
}
