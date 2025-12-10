import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipie/ui/recipe_card.dart';
import 'package:recipe_book/features/recipie/recipe_viewmodel.dart';

class RecipeBookDetailsScreen extends ConsumerStatefulWidget {
  const RecipeBookDetailsScreen({super.key});

  @override
  ConsumerState<RecipeBookDetailsScreen> createState() =>
      _RecipeBookDetailsScreenState();
}

class _RecipeBookDetailsScreenState
    extends ConsumerState<RecipeBookDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Delay fetch until after the first frame so ref is available
    Future.microtask(() async {
      final authState = ref.read(authNotifierProvider);
      final appUser = authState.appUser;
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
          return const Scaffold(body: Center(child: Text('No recipes found.')));
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
