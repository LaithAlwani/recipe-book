import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipie/create/update_recipe_payload.dart';
import 'recipe_state.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/recipe_model.dart';

class recipeNotifier extends Notifier<RecipeState> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prepTimeController = TextEditingController();
  TextEditingController cookTimeController = TextEditingController();
  TextEditingController totalTimeController = TextEditingController();
  TextEditingController servingsController = TextEditingController();
  TextEditingController videoUrlController = TextEditingController();

  // Focus nodes
  late FocusNode titleFocus;
  late FocusNode descriptionFocus;
  late FocusNode prepTimeFocus;
  late FocusNode cookTimeFocus;
  late FocusNode totalTimeFocus;
  late FocusNode servingsFocus;
  late FocusNode videoUrlFocus;

  @override
  RecipeState build() {
    _initControllers();
    _initFocusNodes();
    return const RecipeState();
  }

  void _initControllers() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    prepTimeController = TextEditingController();
    cookTimeController = TextEditingController();
    totalTimeController = TextEditingController();
    servingsController = TextEditingController();
    videoUrlController = TextEditingController();
  }

  void _initFocusNodes() {
    titleFocus = FocusNode();
    descriptionFocus = FocusNode();
    prepTimeFocus = FocusNode();
    cookTimeFocus = FocusNode();
    totalTimeFocus = FocusNode();
    servingsFocus = FocusNode();
    videoUrlFocus = FocusNode();
  }

  void dispose() {
    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    prepTimeController.dispose();
    cookTimeController.dispose();
    totalTimeController.dispose();
    servingsController.dispose();
    videoUrlController.dispose();

    // Dispose focus nodes
    titleFocus.dispose();
    descriptionFocus.dispose();
    prepTimeFocus.dispose();
    cookTimeFocus.dispose();
    totalTimeFocus.dispose();
    servingsFocus.dispose();
    videoUrlFocus.dispose();
    // super.dispose();
  }

  void setTitle(String value) => state = state.copyWith(title: value);
  void setDescription(String value) =>
      state = state.copyWith(description: value);
  void setIngredients(List<Ingredient> value) =>
      state = state.copyWith(ingredients: value);
  void setInstructions(List<String> value) =>
      state = state.copyWith(instructions: value);
  void setImageUrls(List<String> value) =>
      state = state.copyWith(imageUrls: value);
  void setSelectedImages(List<File> images) {
    state = state.copyWith(selectedImages: List.unmodifiable(images));
  }

  void setPrepTime(String value) {
    final prep = int.tryParse(value) ?? 0;
    state = state.copyWith(prepTime: prep, totalTime: prep + state.cookTime);
    prepTimeController.text = prep.toString();
    totalTimeController.text = (prep + state.cookTime).toString();
  }

  void setCookTime(String value) {
    final cook = int.tryParse(value) ?? 0;
    state = state.copyWith(cookTime: cook, totalTime: state.prepTime + cook);
    cookTimeController.text = cook.toString();
    totalTimeController.text = (state.prepTime + cook).toString();
  }

  // void setTotalTime(int value) => state = state.copyWith(totalTime: value);
  void setDifficulty(String? value) =>
      state = state.copyWith(difficulty: value);
  void setServings(int value) => state = state.copyWith(servings: value);
  void setTags(List<String> value) => state = state.copyWith(tags: value);
  void setCategories(List<String> value) =>
      state = state.copyWith(categories: value);
  void setNutrition(Map<String, dynamic> value) =>
      state = state.copyWith(nutrition: value);
  void setVideoUrl(String? value) => state = state.copyWith(videoUrl: value);
  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? message) =>
      state = state.copyWith(errorMessage: message);
  void setEditingRecipe(Recipe recipe) =>
      state = state.copyWith(editingRecipe: recipe);

  void openForEdit(Recipe recipe) {
    state = state.copyWith(editingRecipe: recipe);
    populateFormFromRecipe(recipe);
  }

  void populateFormFromRecipe(Recipe recipe) {
    titleController.text = recipe.title.trim();
    descriptionController.text = recipe.description.trim();
    prepTimeController.text = recipe.prepTime.toString();
    cookTimeController.text = recipe.cookTime.toString();
    totalTimeController.text = recipe.totalTime.toString();
    servingsController.text = recipe.servings.toString();
    videoUrlController.text = recipe.videoUrl.toString().trim();

    state = state.copyWith(
      title: recipe.title.trim(),
      description: recipe.description.trim(),

      instructions: recipe.instructions.isNotEmpty
          ? List<String>.from(recipe.instructions)
          : <String>[],

      prepTime: recipe.prepTime > 0 ? recipe.prepTime : 0,
      cookTime: recipe.cookTime > 0 ? recipe.cookTime : 0,
      totalTime: recipe.totalTime > 0
          ? recipe.totalTime
          : (recipe.prepTime + recipe.cookTime),

      difficulty: recipe.difficulty.isNotEmpty ? recipe.difficulty : null,

      servings: recipe.servings > 0 ? recipe.servings : 0,

      tags: recipe.tags.isNotEmpty
          ? List<String>.from(recipe.tags)
          : <String>[],

      categories: recipe.categories.isNotEmpty
          ? List<String>.from(recipe.categories)
          : <String>[],

      ingredients: recipe.ingredients.isNotEmpty
          ? List<Ingredient>.from(recipe.ingredients)
          : <Ingredient>[],

      imageUrls: recipe.imageUrls.isNotEmpty
          ? List<String>.from(recipe.imageUrls)
          : <String>[],

      nutrition: recipe.nutrition ?? <String, dynamic>{},

      videoUrl: recipe.videoUrl?.isNotEmpty == true ? recipe.videoUrl : null,
    );
  }

  void resetForm() {
    state = const RecipeState(); // editingRecipe = null
  }

  //check all mandetory fields
  bool get canSubmit =>
      state.title.isNotEmpty &&
      state.ingredients.isNotEmpty &&
      state.instructions.isNotEmpty &&
      (state.selectedImages.isNotEmpty || state.imageUrls.isNotEmpty) &&
      state.prepTime > 0 &&
      state.cookTime > 0 &&
      state.totalTime > 0 &&
      state.servings > 0 &&
      state.difficulty != null &&
      !state.isSubmitting;

  Future<void> submitRecipe() async {
    // if (!_validate()) return;
    setLoading(true);
    setError(null);
    try {
      final recipeData = state.toCreatePayload().toFirestore();

      if (state.editingRecipe != null) {
        print("Editing Recipe ${state.editingRecipe?.id}");
      } else {
        print("Createing Recipe");
      }
    } catch (e) {
      setError(e.toString());
    }finally{
      setLoading(false);
    }

    
  }
}
