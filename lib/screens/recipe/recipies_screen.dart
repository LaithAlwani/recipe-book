import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/provider/auth_provider.dart';
import 'package:recipe_book/screens/recipe/recipe_card.dart';
import 'package:recipe_book/screens/recipe/recipe_screen.dart';
import 'package:recipe_book/viewmodels/recipe_viewmodel.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  @override
  void initState() {
    super.initState();
    // Delay fetch until after the first frame so ref is available
    Future.microtask(() async {
      final authState = ref.read(authProvider);
      final appUser = authState.value;
      if (appUser != null) {
        await ref
            .read(recipeViewModelProvider.notifier)
            .fetchRecipes(appUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final recipeState = ref.watch(recipeViewModelProvider);
    final appUser = authState.appUser;

    return recipeState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (recipes) {
        if (recipes.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(recipeViewModelProvider.notifier)
                .fetchRecipes(appUser!.uid);
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, // Adjust height ratio (smaller = taller)
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(recipe: recipe);
            },
          ),
        );
      },
    );
  }
}
