import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

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
}
