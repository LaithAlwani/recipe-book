import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'create_recipe_state.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class CreateRecipeNotifier extends Notifier<CreateRecipeState> {
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
  CreateRecipeState build() {
    _initControllers();
    _initFocusNodes();
    return const CreateRecipeState();
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

  bool _validate() {
    if (state.title.isEmpty ||
        state.description.isEmpty ||
        state.ingredients.isEmpty ||
        state.instructions.isEmpty ||
        state.selectedImages.isEmpty ||
        state.prepTime <= 0 ||
        state.cookTime < 0 ||
        state.totalTime <= 0 ||
        state.difficulty == null ||
        state.servings <= 0 ||
        state.tags.isEmpty ||
        state.categories.isEmpty) {
      setError("Please fill all mandatory fields.");
      return false;
    }
    setError(null);
    return true;
  }

  //check all mandetory fields
  bool get canSubmit =>
      state.title.isNotEmpty &&
      state.ingredients.isNotEmpty &&
      state.instructions.isNotEmpty &&
      state.selectedImages.isNotEmpty &&
      state.prepTime > 0 &&
      state.cookTime > 0 &&
      state.totalTime> 0 &&
      state.servings > 0 &&
      state.difficulty != null &&
      !state.isSubmitting;

  Future<void> submitRecipe(WidgetRef ref) async {
    // if (!_validate()) return;
    
    setLoading(true);

    try {
      final appUser = ref.read(authNotifierProvider).appUser!;

      final recipe = Recipe(
        id: state.editingRecipe?.id ?? '',
        ownerId: appUser.uid, // ownerId from current user
        bookIds: [], // will be set later
        title: state.title,
        description: state.description,
        instructions: state.instructions,
        prepTime: state.prepTime,
        cookTime: state.cookTime,
        totalTime: state.totalTime,
        difficulty: state.difficulty ?? '',
        servings: state.servings,
        tags: state.tags,
        categories: state.categories,
        ingredients: state.ingredients,
        imageUrls: state.imageUrls,
        createdBy: appUser.uid,
        createdAt: state.editingRecipe?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
        nutrition: state.nutrition,
        videoUrl: state.videoUrl,
      );
      print(state.selectedImages);

      // await _saveRecipeToFirestore(recipe);
    } catch (e) {
      setError(e.toString());
    }

    setLoading(false);
  }

  Future<void> _saveRecipeToFirestore(Recipe recipe) async {
    // Implement Firestore saving logic
  }
}
