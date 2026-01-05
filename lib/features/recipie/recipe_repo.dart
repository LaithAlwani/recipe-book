import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:recipe_book/features/recipie/recipe_model.dart';

class RecipeRepo {
  static final recipeRef = FirebaseFirestore.instance
      .collection("recipes")
      .withConverter(
        fromFirestore: Recipe.fromFirestore,
        toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
      );

  static Future<List<Recipe>> getRecipesByCreatedBy(String uid) async {
    print(uid);
    final snapshot = await recipeRef
        .where('created_by', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> createRecpie(
    String recipeId,
    Map<String, dynamic> data,
  ) async {
    final FirebaseFunctions functions = FirebaseFunctions.instance;
    final HttpsCallable callable = functions.httpsCallable('createRecipe');
    await callable.call({'recipeId': recipeId, 'recipe': data});
  }

  static Future<void> updateRecipe(
    String recipeId,
    Map<String, dynamic> data,
  ) async {
    print("Editing Recipe ${recipeId}");
  }
}
