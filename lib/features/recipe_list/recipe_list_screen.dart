import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_state.dart';
import 'package:recipe_book/features/recipe_book/recipe_book_provider.dart';
import 'package:recipe_book/features/recipie/ui/recipe_card.dart';

class RecipeListScreen extends ConsumerWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(authNotifierProvider).appUser!;
    final bookId = ref
        .watch(recipeBooksNotifierProvider(appUser.uid))
        .currentBookId!;
    final bookTitle =
        ref.watch(recipeBooksNotifierProvider(appUser.uid)).currentBookTitle ??
        "Book Title";
    final bookDetailState = ref.watch(recipeListProvider(bookId));
    final bookDetailVM = ref.watch(recipeListProvider(bookId).notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (bookDetailState.status == RecipeBookDetailStatus.initial) {
        await bookDetailVM.loadRecipesByBook(bookId);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(bookTitle), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await bookDetailVM.loadRecipesByBook(bookId);
        },
        child: bookDetailState.isLoadingRecipes
            ? const Center(child: CircularProgressIndicator())
            : bookDetailState.recipes.isEmpty
            ? const Center(child: Text("Start adding recipes"))
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio:
                      0.75, // Adjust height ratio (smaller = taller)
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
