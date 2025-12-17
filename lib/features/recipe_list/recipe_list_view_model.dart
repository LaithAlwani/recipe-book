import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_repo.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_state.dart';
import 'package:recipe_book/features/recipie/recipe_model.dart';

class RecipeListViewModel extends Notifier<RecipeListState> {
  late RecipeListQuery query;
  @override
  RecipeListState build() {
    return RecipeListState.initial();
  }

  Future<void> loadRecipes(RecipeListQuery query) async {
    state = state.copyWith(status: RecipeListStatus.loading);
    print("Fetching recipes");

    try {
      List<Recipe> recipes;
      if (query.bookId != null) {
        recipes = await RecipeListRepo.fetchRecipiesByBook(query.bookId!);
      } else if (query.ownerId != null) {
        recipes = await RecipeListRepo.fetchRecipesByOwner(query.ownerId!);
      } else {
        recipes = [];
      }
      state = state.copyWith(status: RecipeListStatus.loaded, recipes: recipes);
    } catch (err) {
      state = state.copyWith(
        status: RecipeListStatus.error,
        errorMessage: err.toString(),
      );
    }
  }
}
