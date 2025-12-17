import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/auth/auth_provider.dart';
import 'package:recipe_book/features/recipie/recipe_model.dart';
import 'package:recipe_book/features/recipie/recipe_viewmodel.dart';
import 'package:recipe_book/features/recipie/recipe_provider.dart';
import 'package:recipe_book/features/recipie/create/ui/create_recipe_screen.dart';
import 'package:recipe_book/theme.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  int multiplier = 1;
  @override
  Widget build(BuildContext context) {
  final appUser = ref.read(authNotifierProvider).appUser!;
  final createRecipeVM = ref.read(recipeProvider.notifier);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ IMAGE + BACK BUTTON ------------------
            Stack(
              children: [
                Image.network(
                  widget.recipe.imageUrls[0],
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
                      color: AppColors.primaryColor,
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
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                if(appUser.uid == widget.recipe.ownerId)
                Positioned(
                  top: 40,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
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
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        createRecipeVM.openForEdit(widget.recipe);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const CreateRecipeScreen()));},
                    ),
                  ),
                ),
              ],
            ),

            // ------------------ MAIN CONTENT (With one Padding) ------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Title ----------
                  Text(
                    widget.recipe.title,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ---------- Description ----------
                  Text(
                    widget.recipe.description,
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ------------------ Metadata Grid ------------------
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
                        childAspectRatio: 2.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: [
                          _metaItem(
                            Icons.timer_outlined,
                            "Prep Time",
                            "${widget.recipe.prepTime} min",
                          ),
                          _metaItem(
                            Icons.star,
                            "Rating",
                            widget.recipe.rating != 0.0
                                ? widget.recipe.rating.toStringAsFixed(1)
                                : 'N/A',
                            iconColor: Colors.amber.shade300,
                          ),

                          _metaItem(
                            Icons.av_timer,
                            "Total Time",
                            "${widget.recipe.prepTime + widget.recipe.cookTime} min",
                          ),

                          _metaItem(
                            Icons.person,
                            "Servings",
                            "${widget.recipe.servings * multiplier}",
                          ),
                          _metaItem(
                            Icons.local_fire_department,
                            "Cook Time",
                            "${widget.recipe.cookTime} min",
                            iconColor: Colors.amber.shade900,
                          ),
                          _difficultyTag(widget.recipe.difficulty),
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
                    children: widget.recipe.tags.map((tag) {
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

                  // ----------Ingredients and  Multiplier Selector ----------
                  Row(
                    children: [
                      const Text(
                        "Ingredients:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          right: 8,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (multiplier > 1)
                              setState(() {
                                multiplier -= 1;
                              });
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ),
                      Text(multiplier.toString()),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 8,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              multiplier += 1;
                            });
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.recipe.ingredients.length,
                    itemBuilder: (_, index) {
                      final item = widget.recipe.ingredients[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text("${item.name}"),
                            const Expanded(child: SizedBox()),
                            Text(
                              formatQuantity(
                                item.quantity * multiplier,
                                item.unit ?? "",
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     print("Added ${item.name} to shopping cart");
                            //   },
                            //   icon: const Icon(Icons.add_shopping_cart),
                            // ),
                          ],
                        ),
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
                    itemCount: widget.recipe.instructions.length,
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
                                widget.recipe.instructions[index],
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
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.grey.shade700, size: 32),
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

String formatQuantity(double quantity, String unit) {
  double displayQty = quantity;
  String displayUnit = unit;

  // Convert ml → L and g → kg if >= 1000
  if ((unit == "ml" || unit == "g") && quantity >= 1000) {
    displayQty = quantity / 1000;
    displayUnit = unit == "ml" ? "L" : "kg";
  }

  // Show as integer if whole number, else show 1 or 2 decimals
  String qtyString;
  if (displayQty % 1 == 0) {
    qtyString = displayQty.toInt().toString();
  } else {
    qtyString = displayQty.toStringAsFixed(2);
  }

  return "$qtyString $displayUnit";
}
