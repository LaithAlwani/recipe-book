import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'create_recipe_state.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class CreateRecipeNotifier extends Notifier<CreateRecipeState> {
  @override
  CreateRecipeState build() {
    return const CreateRecipeState();
  }

  void setTitle(String value) => state = state.copyWith(title: value);
  void setIngredients(List<Ingredient> value) =>
      state = state.copyWith(ingredients: value);
  void setInstructions(List<String> value) =>
      state = state.copyWith(instructions: value);
  void setImageUrls(List<String> value) => state = state.copyWith(imageUrls: value);
  void setPrepTime(int value) => state = state.copyWith(prepTime: value);
  void setCookTime(int value) => state = state.copyWith(cookTime: value);
  void setTotalTime(int value) => state = state.copyWith(totalTime: value);
  void setDifficulty(String? value) => state = state.copyWith(difficulty: value);
  void setServings(int value) => state = state.copyWith(servings: value);
  void setTags(List<String> value) => state = state.copyWith(tags: value);
  void setCategories(List<String> value) => state = state.copyWith(categories: value);
  void setNutrition(Map<String, dynamic> value) => state = state.copyWith(nutrition: value);
  void setVideoUrl(String? value) => state = state.copyWith(videoUrl: value);
  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? message) => state = state.copyWith(errorMessage: message);
  void setEditingRecipe(Recipe recipe) => state = state.copyWith(editingRecipe: recipe);

  bool _validate() {
    if (state.title.isEmpty ||
        state.ingredients.isEmpty ||
        state.instructions.isEmpty ||
        state.imageUrls.isEmpty ||
        state.prepTime <= 0 ||
        state.cookTime < 0 ||
        state.totalTime <= 0 ||
        state.difficulty.isEmpty ||
        state.servings <= 0 ||
        state.tags.isEmpty ||
        state.categories.isEmpty) {
      setError("Please fill all mandatory fields.");
      return false;
    }
    setError(null);
    return true;
  }

  Future<void> saveRecipe(WidgetRef ref) async {
    if (!_validate()) return;

    setLoading(true);

    try {
      final appUser = ref.read(authNotifierProvider).appUser!;

      final recipe = Recipe(
        id: state.editingRecipe?.id ?? '',
        ownerId: appUser.uid, // ownerId from current user
        bookIds: [], // will be set later
        title: state.title,
        description: state.editingRecipe?.description ?? '',
        instructions: state.instructions,
        prepTime: state.prepTime,
        cookTime: state.cookTime,
        totalTime: state.totalTime,
        difficulty: state.difficulty,
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
      
      await _saveRecipeToFirestore(recipe);

    } catch (e) {
      setError(e.toString());
    }

    setLoading(false);
  }

  Future<void> _saveRecipeToFirestore(Recipe recipe) async {
    // Implement Firestore saving logic
  }
}
