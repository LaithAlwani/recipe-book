import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_provider.dart';
import 'package:recipe_book/features/recipe_list/recipe_list_state.dart';
import 'package:recipe_book/features/recipie/create/ui/create_recipe_screen.dart';
import 'package:recipe_book/features/recipie/recipe_provider.dart';
import 'package:recipe_book/features/recipie/ui/recipe_card.dart';
import 'package:recipe_book/features/settings/settings_screen.dart';
import 'package:recipe_book/theme.dart';

class RecipeListScreen extends ConsumerWidget {
  final RecipeListQuery query;
  final String title;

  const RecipeListScreen({super.key, required this.query, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.read(authNotifierProvider.notifier);

    final state = ref.watch(recipeListProvider(query));
    final viewmodel = ref.read(recipeListProvider(query).notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (state.status == RecipeListStatus.initial) {
        await viewmodel.loadRecipes(query);
      }
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigate to Create Recipe screen
          final recipeVM = ref.read(recipeProvider.notifier);
          recipeVM.resetForm();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecipeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      // appBar: AppBar(title: Text(title), centerTitle: true),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigate to Settings on top of current page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await authVM.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Logout succesfully, See you later!"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
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
