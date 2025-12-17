import 'package:recipe_book/features/ingredient/ingredient.dart';

class CreateRecipePayload {
  final String title;
  final String description;
  final List<String> instructions;
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final String difficulty;
  final int servings;
  final List<String> tags;
  final List<String> categories;
  final List<Ingredient> ingredients;
  final List<String> imageUrls;
  final Map<String, dynamic>? nutrition;
  final String? videoUrl;

  const CreateRecipePayload({
    required this.title,
    required this.description,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.difficulty,
    required this.servings,
    required this.tags,
    required this.categories,
    required this.ingredients,
    required this.imageUrls,
    this.nutrition,
    this.videoUrl,
  });

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'instructions': instructions,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'totalTime': totalTime,
        'difficulty': difficulty,
        'servings': servings,
        'tags': tags,
        'categories': categories,
        'ingredients': ingredients.map((e) => e.toFirestore()).toList(),
        'imageUrls': imageUrls,
        'nutrition': nutrition,
        'videoUrl': videoUrl,
      };
}
