import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_model.dart';

class RecipeBooksRepo {
  static final _firestore = FirebaseFirestore.instance;

  static final _recipeBooksRef = _firestore
      .collection("recipe_books")
      .withConverter<RecipeBook>(
        fromFirestore: RecipeBook.fromFirestore,
        toFirestore: (RecipeBook book, _) => book.toFirestore(),
      );

  static Future<List<RecipeBook>> fetchRecipeBooksByOwner(
    String ownerId,
  ) async {
    try {
      print("Fetching recipe books for ownerId: $ownerId");

      final querySnapshot = await _recipeBooksRef
          .where('ownerId', isEqualTo: ownerId)
          .get();

      print(
        "Query executed. Number of docs returned: ${querySnapshot.docs.length}",
      );

      if (querySnapshot.docs.isEmpty) {
        print("No recipe books found for ownerId: $ownerId");
        return [];
      }

      final recipes = querySnapshot.docs.map((doc) {
        print("Doc ID: ${doc.id} | Data: ${doc.data()}");
        return doc.data();
      }).toList();

      return recipes;
    } catch (e, stacktrace) {
      debugPrint("Failed to fetch recipe books: $e");
      debugPrint(stacktrace.toString());
      return [];
    }
  }
}
