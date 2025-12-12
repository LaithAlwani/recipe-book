import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_repo.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_state.dart';

class RecipeBookDetailViewModel extends Notifier<RecipeBookDetailState> {
  @override
  RecipeBookDetailState build() {
    return RecipeBookDetailState.initial();
  }

  Future<void> loadRecipesByBook(String bookId) async {
    state = state.copyWith(status: RecipeBookDetailStatus.loading);

    try {
      final recipes = await RecipeBookDetailRepo.fetchRecipiesByBook(bookId);
      state = state.copyWith(
        status: RecipeBookDetailStatus.loaded,
        recipes: recipes,
      );
    } catch (err) {
      state = state.copyWith(
        status: RecipeBookDetailStatus.error,
        errorMessage: err.toString(),
      );
    }
  }
}
