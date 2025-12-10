import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_state.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_view_model.dart';

final recipeBookDetailProvider =
    NotifierProvider.family<
      RecipeBookDetailViewModel,
      RecipeBookDetailState,
      String
    >((bookId) {
      return RecipeBookDetailViewModel();
    });
