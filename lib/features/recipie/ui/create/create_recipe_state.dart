import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class CreateRecipeState {
  final String title;
  final String discription;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final List<String> imageUrls;

  // Mandatory
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final String difficulty;
  final int servings;
  final List<String> tags;
  final List<String> categories;

  // Optional
  final Map<String, dynamic>? nutrition;
  final String? videoUrl;

  // UI
  final bool isLoading;
  final String? errorMessage;

  // Edit mode
  final Recipe? editingRecipe;

  const CreateRecipeState({
    this.title = '',
    this.discription = '',
    this.ingredients = const [],
    this.instructions = const [],
    this.imageUrls = const [],
    this.prepTime = 0,
    this.cookTime = 0,
    this.totalTime = 0,
    this.difficulty = 'Medium',
    this.servings = 1,
    this.tags = const [],
    this.categories = const [],
    this.nutrition,
    this.videoUrl,
    this.isLoading = false,
    this.errorMessage,
    this.editingRecipe,
  });

  CreateRecipeState copyWith({
    String? title,
    String? discription,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    List<String>? imageUrls,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    String? difficulty,
    int? servings,
    List<String>? tags,
    List<String>? categories,
    Map<String, dynamic>? nutrition,
    String? videoUrl,
    bool? isLoading,
    String? errorMessage,
    Recipe? editingRecipe,
  }) {
    return CreateRecipeState(
      title: title ?? this.title,
      discription:discription?? this.discription,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrls: imageUrls ?? this.imageUrls,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      categories: categories ?? this.categories,
      nutrition: nutrition ?? this.nutrition,
      videoUrl: videoUrl ?? this.videoUrl,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      editingRecipe: editingRecipe ?? this.editingRecipe,
    );
  }
}
