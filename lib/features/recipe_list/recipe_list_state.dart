import 'package:recipe_book/features/recipie/recipe.dart';

enum RecipeBookDetailStatus { initial, loading, loaded, error }

class RecipeBookDetailState {
  final RecipeBookDetailStatus status;
  final List<Recipe> recipes; // The collection itself // Or just recipes
  final bool isLoadingRecipes;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeBookDetailState({
    this.status = RecipeBookDetailStatus.initial,
    this.recipes = const [],
    this.isLoadingRecipes = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeBookDetailState copyWith({
    RecipeBookDetailStatus? status,
    List<Recipe>? recipes,
    bool? isLoadingRecipes,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeBookDetailState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      isLoadingRecipes: isLoadingRecipes ?? this.isLoadingRecipes,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeBookDetailState.initial() => const RecipeBookDetailState(
    status: RecipeBookDetailStatus
        .initial, // custom enum, e.g., initial/loading/loaded/error
    recipes: [],
    isLoadingRecipes: false,
    isUpdating: false,
    errorMessage: null,
  );
}
