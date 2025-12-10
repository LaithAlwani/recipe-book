import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_provider.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_state.dart';
import 'package:recipe_book/features/recipe_books/recipe_book_provider.dart';
import 'package:recipe_book/features/recipie/ui/recipe_card.dart';

class RecipeBookDetailsScreen extends ConsumerWidget {
  const RecipeBookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookDetailState = ref.watch(recipeBookDetailProvider);
    final bookDetailVM = ref.watch(recipeBookDetailProvider.notifier);
    final bookId = ref.watch(recipeBooksNotifierProvider).currentBookId;
    final bookTitle = ref.watch(recipeBooksNotifierProvider).currentBookTitle;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (bookDetailState.status == RecipeBookDetailStatus.initial) {
        if (bookId != null) {
          await bookDetailVM.loadRecipes(bookId);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(bookTitle ?? ""), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          if (bookId != null) {
            await bookDetailVM.loadRecipes(bookId);
          }
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // Adjust height ratio (smaller = taller)
          ),
          itemCount: bookDetailState.recipes.length,
          itemBuilder: (context, index) {
            final recipe = bookDetailState.recipes[index];
            return RecipeCard(recipe: recipe);
          },
        ),
      ),
    );
  }
}
