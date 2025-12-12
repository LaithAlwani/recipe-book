import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_state.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_view_model.dart';

final recipeListProvider =
    NotifierProvider.family<
      RecipeBookDetailViewModel,
      RecipeBookDetailState,
      String
    >((bookId) {
      return RecipeBookDetailViewModel();
    });
