import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_book/features/user/user_model.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? firebaseUser;
  final AppUser? appUser;
  final bool isLoading;
  final bool isSignedIn;
  final bool isSigingOut;
  final bool isRegistering;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.firebaseUser,
    this.appUser,
    this.isLoading = false,
    this.isSignedIn = false,
    this.isSigingOut = false,
    this.isRegistering = false,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? firebaseUser,
    AppUser? appUser,
    bool? isLoading,
    bool? isSignedIn,
    bool? isSigingOut,
    bool? isRegistering,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      appUser: appUser ?? this.appUser,
      isLoading: isLoading ?? this.isLoading,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isSigingOut: isSigingOut ?? this.isSigingOut,
      isRegistering: isRegistering ?? this.isRegistering,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
      isSignedIn: false,
      appUser: null,
      firebaseUser: null,
      isRegistering: false,
      isSigingOut: false,
    );  
  }

  @override
  String toString() {
    return 'AuthState(status: $status,user:$firebaseUser isLoading: $isLoading, isSignedIn: $isSignedIn, isRegistering: $isRegistering, appUser: ${appUser?.displayName}, errorMessage: $errorMessage)';
  }
}
