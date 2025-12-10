import 'package:recipe_book/features/recipie/recipe.dart';

enum RecipeBookDetailStatus { initial, loading, loaded, error }

class RecipeBookDetailState {
  final RecipeBookDetailStatus status;
  final List<Recipe> recipies; // The collection itself // Or just recipes
  final bool isLoadingRecipies;
  final bool isUpdating;
  final String? errorMessage;

  const RecipeBookDetailState({
    this.status = RecipeBookDetailStatus.initial,
    this.recipies = const [],
    this.isLoadingRecipies = false,
    this.isUpdating = false,
    this.errorMessage,
  });

  RecipeBookDetailState copyWith({
    RecipeBookDetailStatus? status,
    List<Recipe>? recipes,
    bool? isLoadingRecipies,
    bool? isUpdating,
    String? errorMessage,
  }) {
    return RecipeBookDetailState(
      status: status ?? this.status,
      recipies: recipes ?? this.recipies,
      isLoadingRecipies: isLoadingRecipies ?? this.isLoadingRecipies,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RecipeBookDetailState.initial() => const RecipeBookDetailState(
    status: RecipeBookDetailStatus
        .initial, // custom enum, e.g., initial/loading/loaded/error
    recipies: [],
    isLoadingRecipies: false,
    isUpdating: false,
    errorMessage: null,
  );
}
