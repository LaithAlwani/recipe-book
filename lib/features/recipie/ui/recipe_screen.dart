import 'package:flutter/material.dart';
import 'package:recipe_book/features/recipie/recipe.dart';
import 'package:recipe_book/theme.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ IMAGE + BACK BUTTON ------------------
            Stack(
              children: [
                Image.network(
                  recipe.imageUrls[0],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    child: const Icon(Icons.broken_image, size: 300),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            // ------------------ MAIN CONTENT (With one Padding) ------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Title ----------
                  Text(
                    recipe.title,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---------- Description ----------
                  Text(
                    recipe.description,
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------- Metadata Row ----------
                  // ------------------ Metadata Grid ------------------
                  const SizedBox(height: 16),

                  const Text(
                    "Recipe Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      int columns = constraints.maxWidth > 500 ? 3 : 2;

                      return GridView.count(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: columns,
                        childAspectRatio: 3.2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _metaItem(
                            Icons.timer_outlined,
                            "Prep Time",
                            "${recipe.prepTime} min",
                          ),
                          _metaItem(
                            Icons.local_fire_department,
                            "Cook Time",
                            "${recipe.cookTime} min",
                          ),
                          _metaItem(
                            Icons.av_timer,
                            "Total Time",
                            "${recipe.prepTime + recipe.cookTime} min",
                          ),
                          _difficultyTag(recipe.difficulty),
                          _metaItem(
                            Icons.person,
                            "Servings",
                            "${recipe.servings}",
                          ),
                          _metaItem(
                            Icons.star,
                            "Rating",
                            recipe.rating?.toStringAsFixed(1) ?? "N/A",
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ------------------ TAGS ------------------
                  const Text(
                    "Tags",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // ---------- Ingredients ----------
                  const Text(
                    "Ingredients:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (_, index) {
                      final item = recipe.ingredients[index];

                      return Row(
                        children: [
                          Text("${item.name} - ${item.quantity} ${item.unit}"),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              print("Added ${item.name} to shopping cart");
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // ---------- Instructions ----------
                  const Text(
                    "Instructions:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.instructions.length,
                    itemBuilder: (_, index) {
                      return Container(
                        height: 48,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.amber,
                              child: Text("${index + 1}"),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recipe.instructions[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _metaItem(
  IconData icon,
  String label,
  String value, {
  Color? color,
  Color? iconColor,
}) {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: color ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _difficultyTag(String difficulty) {
  Color color;

  switch (difficulty.toLowerCase()) {
    case "easy":
      color = Colors.green.shade300;
      break;
    case "medium":
      color = Colors.orange.shade300;
      break;
    case "hard":
      color = Colors.red.shade300;
      break;
    default:
      color = Colors.grey.shade300;
  }

  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: _metaItem(Icons.tune, "Difficulty", difficulty, color: color),
  );
}
