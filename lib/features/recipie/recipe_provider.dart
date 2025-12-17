import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipie/recipe_state.dart';
import 'package:recipe_book/features/recipie/recipe_viewmodel.dart';

final recipeProvider =
    NotifierProvider<recipeNotifier, RecipeState>(
      () => recipeNotifier(),
    );
