import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_details_screen.dart';
import 'package:recipe_book/features/recipe_books/recipe_book_provider.dart';
import 'package:recipe_book/features/recipe_books/recipe_book_state.dart';
import 'package:recipe_book/features/recipie/ui/recipe_screen.dart';

class RecipieBookScreen extends ConsumerWidget {
  const RecipieBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(recipeBooksNotifierProvider);
    final bookVM = ref.read(recipeBooksNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (booksState.status == RecipeBooksStatus.initial) {
        final ownerId = ref.read(authNotifierProvider).appUser?.uid;
        if (ownerId != null) {
          await bookVM.loadBooks(ownerId);
        }
      }
    });
    return Scaffold(
      body: ListView.builder(
        itemCount: booksState.books.length,
        itemBuilder: (context, index) {
          final book = booksState.books[index];
          return booksState.isLoadingBooks
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipeBookDetailsScreen(),
                      ),
                    );
                  },
                  child: ListTile(
                    leading:
                        book.thumbnailUrl != null &&
                            book.thumbnailUrl!.isNotEmpty
                        ? Image.network(
                            book.thumbnailUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.book),
                    title: Text(book.title),
                    subtitle: Text("${book.recipes.length} recipes"),
                  ),
                );
        },
      ),
    );
  }
}
