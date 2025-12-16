import 'dart:io';

import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class CreateRecipeState {
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final List<String> imageUrls;
  final List<File> selectedImages;

  // Mandatory
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final String? difficulty;
  final int servings;
  final List<String> tags;
  final List<String> categories;

  // Optional
  final Map<String, dynamic>? nutrition;
  final String? videoUrl;

  // UI
  final bool isLoading;
  final bool isSubmitting;
  final bool canSubmit;
  final String? errorMessage;

  // Edit mode
  final Recipe? editingRecipe;

  const CreateRecipeState({
    this.title = '',
    this.description = '',
    this.ingredients = const [],
    this.instructions = const [],
    this.imageUrls = const [],
    this.selectedImages = const [],
    this.prepTime = 0,
    this.cookTime = 0,
    this.totalTime = 0,
    this.difficulty,
    this.servings = 0,
    this.tags = const [],
    this.categories = const [],
    this.nutrition,
    this.videoUrl,
    this.isLoading = false,
    this.isSubmitting = false,
    this.canSubmit = false,
    this.errorMessage,
    this.editingRecipe,
  });

  CreateRecipeState copyWith({
    String? title,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    List<String>? imageUrls,
    List<File>? selectedImages,
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
    bool? isSubmitting,
    bool? canSubmit,
    String? errorMessage,
    Recipe? editingRecipe,
  }) {
    return CreateRecipeState(
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrls: imageUrls ?? this.imageUrls,
      selectedImages: selectedImages ?? this.selectedImages,
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
      isSubmitting: isSubmitting ?? this.isSubmitting,
      canSubmit: canSubmit ?? this.canSubmit,
      errorMessage: errorMessage ?? this.errorMessage,
      editingRecipe: editingRecipe ?? this.editingRecipe,
    );
  }
}
