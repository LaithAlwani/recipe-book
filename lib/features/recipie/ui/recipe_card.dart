import 'package:flutter/material.dart';
import 'package:recipe_book/features/recipie/recipe.dart';
import 'package:recipe_book/features/recipie/ui/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)),
        // );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Image (half height)
            // Top: Image (fixed height)
            SizedBox(
              height: 120, // adjust to taste
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  recipe.imageUrls[0],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom: Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Categories list
                    Wrap(
                      spacing: 4,
                      runSpacing: -4,
                      children: recipe.categories
                          .map(
                            (cat) => Chip(
                              label: Text(
                                cat,
                                style: const TextStyle(fontSize: 10),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const Spacer(),

                    // Cook time
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.cookTime} mins',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
