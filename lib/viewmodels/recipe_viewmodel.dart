import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/services/firestore_services.dart';

class RecipeViewModel extends StateNotifier<AsyncValue<List<Recipe>>> {

  RecipeViewModel() : super(const AsyncValue.data([]));

  Future<void> fetchRecipes(String uid) async {
    // Optionally set state to an empty list or loading state before fetching
    // state = [];
    state = const AsyncValue.loading();
    try {
      final recipes = await FirestoreService.getRecipesByCreatedBy(uid);
      state = AsyncValue.data(recipes); // Update the state with the fetched list
    } catch (e, st) {
      // Handle error, e.g., print to console or set an error state
      state = AsyncValue.error(e, st);
    }
  }
}

final recipeViewModelProvider =
    StateNotifierProvider<RecipeViewModel, AsyncValue<List<Recipe>>>(
  (ref) => RecipeViewModel(),
);
