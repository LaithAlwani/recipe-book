import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/create/create_recipe_payload.dart';
import 'package:recipe_book/features/recipie/create/update_recipe_payload.dart';
import 'package:recipe_book/features/recipie/recipe_model.dart';

class RecipeState {
  // ─────────────────────────────
  // Editable form fields
  // ─────────────────────────────
  final String title;
  final String description;
  final List<String> instructions;
  final List<Ingredient> ingredients;

  final int prepTime;
  final int cookTime;
  final int totalTime;

  final String? difficulty; // nullable to force user selection
  final int servings;

  final List<String> tags;
  final List<String> categories;

  final List<String> imageUrls; // existing images
  final List<File> selectedImages; // newly picked images

  final Map<String, dynamic>? nutrition;
  final String? videoUrl;

  // ─────────────────────────────
  // UI state
  // ─────────────────────────────
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  // ─────────────────────────────
  // Edit mode
  // ─────────────────────────────
  final Recipe? editingRecipe;

  const RecipeState({
    this.title = '',
    this.description = '',
    this.instructions = const [],
    this.ingredients = const [],
    this.prepTime = 0,
    this.cookTime = 0,
    this.totalTime = 0,
    this.difficulty,
    this.servings = 0,
    this.tags = const [],
    this.categories = const [],
    this.imageUrls = const [],
    this.selectedImages = const [],
    this.nutrition,
    this.videoUrl,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.editingRecipe,
  });

  // ─────────────────────────────
  // Derived values (IMPORTANT)
  // ─────────────────────────────

  bool get isEditing => editingRecipe != null;

  bool get canSubmit =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      difficulty != null &&
      servings > 0 &&
      prepTime > 0 &&
      cookTime >= 0 &&
      categories.isNotEmpty &&
      ingredients.isNotEmpty &&
      !isSubmitting;

  // ─────────────────────────────
  // CopyWith
  // ─────────────────────────────
  RecipeState copyWith({
    String? title,
    String? description,
    List<String>? instructions,
    List<Ingredient>? ingredients,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    String? difficulty,
    int? servings,
    List<String>? tags,
    List<String>? categories,
    List<String>? imageUrls,
    List<File>? selectedImages,
    Map<String, dynamic>? nutrition,
    String? videoUrl,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    Recipe? editingRecipe,
  }) {
    return RecipeState(
      title: title ?? this.title,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      categories: categories ?? this.categories,
      imageUrls: imageUrls ?? this.imageUrls,
      selectedImages: selectedImages ?? this.selectedImages,
      nutrition: nutrition ?? this.nutrition,
      videoUrl: videoUrl ?? this.videoUrl,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
      editingRecipe: editingRecipe ?? this.editingRecipe,
    );
  }
}



extension RecipeStateMapper on RecipeState {
  CreateRecipePayload toCreatePayload() {
    return CreateRecipePayload(
      title: title,
      description: description,
      instructions: instructions,
      prepTime: prepTime,
      cookTime: cookTime,
      totalTime: totalTime,
      difficulty: difficulty!,
      servings: servings,
      tags: tags,
      categories: categories,
      ingredients: ingredients,
      imageUrls: imageUrls,
      nutrition: nutrition,
      videoUrl: videoUrl,
    );
  }

  Recipe mergeInto(Recipe existing) {
    return existing.copyWith(
      title: title,
      description: description,
      instructions: instructions,
      prepTime: prepTime,
      cookTime: cookTime,
      totalTime: totalTime,
      difficulty: difficulty,
      servings: servings,
      tags: tags,
      categories: categories,
      ingredients: ingredients,
      imageUrls: imageUrls,
      nutrition: nutrition,
      videoUrl: videoUrl,
      updatedAt: Timestamp.now(),
    );
  }
}

extension RecipeUpdateMapper on RecipeState {
  UpdateRecipePayload toUpdatePayload(Recipe existing) {
    final removedImages =
        existing.imageUrls.where((url) => !imageUrls.contains(url)).toList();

    return UpdateRecipePayload(
      title: title,
      description: description,
      instructions: instructions,
      prepTime: prepTime,
      cookTime: cookTime,
      totalTime: totalTime,
      difficulty: difficulty!,
      servings: servings,
      tags: tags,
      categories: categories,
      ingredients: ingredients,
      keepImageUrls: imageUrls,
      removeImageUrls: removedImages,
      nutrition: nutrition,
      videoUrl: videoUrl,
    );
  }
}

