import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_state.dart';
import 'package:recipe_book/features/auth/auth_view_model.dart';

final authNotifierProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
