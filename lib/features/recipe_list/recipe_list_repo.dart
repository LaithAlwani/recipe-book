import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class RecipeListRepo {
  static final _firestore = FirebaseFirestore.instance;

  static final _recipeBookDetailRef = _firestore
      .collection("recipes")
      .withConverter(
        fromFirestore: Recipe.fromFirestore,
        toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
      );

  static Future<List<Recipe>> fetchRecipiesByBook(String bookId) async {
    try {
      final querySnapshot = await _recipeBookDetailRef
          .where('bookId', isEqualTo: bookId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No recipe books found for ownerId: $bookId");
        return [];
      }
      final recipes = querySnapshot.docs.map((doc) {
        print("Doc ID: ${doc.id} | Data: ${doc.data()}");
        return doc.data();
      }).toList();
      return recipes;
    } catch (err, stacktrace) {
      debugPrint("Failed to fetch recipe books: $err");
      debugPrint(stacktrace.toString());
      return [];
    }
  }
}
