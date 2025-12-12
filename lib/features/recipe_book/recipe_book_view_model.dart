import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book/recipe_book_state.dart';
import 'package:recipe_book/features/recipe_book/recipe_books_repo.dart';

class RecipeBookViewModel extends Notifier<RecipeBooksState> {
  @override
  RecipeBooksState build() {
    state = RecipeBooksState.initial();

    return state;
  }

  void setCurrentBook(String id, String title) {
    state = state.copyWith(currentBookId: id, currentBookTitle:title);
  }

  Future<void> loadBooks(String ownerId) async {
    state = state.copyWith(status: RecipeBooksStatus.loading);

    try {
      final books = await RecipeBooksRepo.fetchRecipeBooksByOwner(ownerId);
      state = state.copyWith(status: RecipeBooksStatus.loaded, books: books);
      print("image url: ${state.books[1].thumbnailUrl}");
    } catch (e) {
      state = state.copyWith(
        status: RecipeBooksStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
