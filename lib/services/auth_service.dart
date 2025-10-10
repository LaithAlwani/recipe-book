import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_book/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //google login
  static Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithCredential(googleCredential);
      if (credential.user != null) {
        return AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          displayName: "",
        );
      }
      return null;
    } catch (err) {
      return null;
    }
  }

  //signup with email and password
  static Future<bool> signUp(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  //login with email and password
  static Future<bool> signIn(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
