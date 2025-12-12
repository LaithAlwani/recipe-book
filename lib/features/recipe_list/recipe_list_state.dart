import 'package:recipe_book/features/recipie/recipe.dart';

enum RecipeBookDetailStatus { initial, loading, loaded, error }

class RecipeListState {
  final RecipeBookDetailStatus status;
  final List<Recipe> recipes; // The collection itself // Or just recipes
  final bool isLoadingRecipes;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeListState({
    this.status = RecipeBookDetailStatus.initial,
    this.recipes = const [],
    this.isLoadingRecipes = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeListState copyWith({
    RecipeBookDetailStatus? status,
    List<Recipe>? recipes,
    bool? isLoadingRecipes,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeListState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      isLoadingRecipes: isLoadingRecipes ?? this.isLoadingRecipes,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeListState.initial() => const RecipeListState(
    status: RecipeBookDetailStatus
        .initial, // custom enum, e.g., initial/loading/loaded/error
    recipes: [],
    isLoadingRecipes: false,
    isUpdating: false,
    errorMessage: null,
  );
}
