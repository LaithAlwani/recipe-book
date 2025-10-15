import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/provider/auth_provider.dart';
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
    final authState = ref.watch(authProvider);
    final recipeState = ref.watch(recipeViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Auth error: $err')),
        data: (appUser) {
          if (appUser == null) {
            return const Center(child: Text('Not signed in'));
          }

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
                      .fetchRecipes(appUser.uid);
                },
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final Recipe recipe = recipes[index];
                    return ListTile(
                      title: Text(recipe.title),
                      subtitle: Text(recipe.description),
                      trailing: Text('${recipe.viewCount} views'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeScreen(recipe: recipe),
                          ),
                        );
                        // Example: open detail or edit screen
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
