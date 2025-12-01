import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_view_model.dart';
import 'package:recipe_book/models/app_user.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthViewModel, AppUser?>(
  () => AuthViewModel(),
);
