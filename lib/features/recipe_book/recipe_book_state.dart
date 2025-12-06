import 'package:recipe_book/features/recipe_book/recipe_book_model.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

enum RecipeBookStatus { loading, loaded, error }

class RecipeBookState {
  final RecipeBookStatus status;
  final RecipeBook? recipeBook; // The collection itself
  final List<Recipe> recipes; // Or just recipes
  final bool isAddingRecipe;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeBookState({
    this.status = RecipeBookStatus.loading,
    this.recipeBook,
    this.recipes = const [],
    this.isAddingRecipe = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeBookState copyWith({
    RecipeBookStatus? status,
    RecipeBook? recipeBook,
    List<Recipe>? recipes,
    bool? isAddingRecipe,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeBookState(
      status: status ?? this.status,
      recipeBook: recipeBook ?? this.recipeBook,
      recipes: recipes ?? this.recipes,
      isAddingRecipe: isAddingRecipe ?? this.isAddingRecipe,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeBookState.initial() => const RecipeBookState();
}
