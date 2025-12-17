import 'package:recipe_book/features/recipie/recipe_model.dart';

enum RecipeListStatus { initial, loading, loaded, error }

class RecipeListState {
  final RecipeListStatus status;
  final List<Recipe> recipes; // The collection itself // Or just recipes
  final bool isUpdating;
  final String? errorMessage;

  const RecipeListState({
    this.status = RecipeListStatus.initial,
    this.recipes = const [],
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeListState copyWith({
    RecipeListStatus? status,
    List<Recipe>? recipes,
    bool? isLoadingRecipes,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeListState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeListState.initial() => const RecipeListState(
    status: RecipeListStatus
        .initial, // custom enum, e.g., initial/loading/loaded/error
    recipes: [],
    isUpdating: false,
    errorMessage: null,
  );
}
