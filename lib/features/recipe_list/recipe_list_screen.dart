import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_state.dart';
import 'package:recipe_book/features/recipie/ui/recipe_card.dart';

class RecipeListScreen extends ConsumerWidget {
  final RecipeListQuery query;
  final String title;

  const RecipeListScreen({super.key, required this.query, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeListProvider(query));
    final viewmodel = ref.read(recipeListProvider(query).notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (state.status == RecipeListStatus.initial) {
        await viewmodel.loadRecipes(query);
      }
    });

    return Scaffold(
      // appBar: AppBar(title: Text(title), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewmodel.loadRecipes(query);
        },
        child: state.status == RecipeListStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : state.recipes.isEmpty
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
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
      ),
    );
  }
}
