import 'package:recipe_book/features/ingredient/ingredient.dart';

class UpdateRecipePayload {
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

  // Image updates are DIFFERENTIAL
  final List<String> keepImageUrls;
  final List<String> removeImageUrls;

  final Map<String, dynamic>? nutrition;
  final String? videoUrl;

  const UpdateRecipePayload({
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
    required this.keepImageUrls,
    required this.removeImageUrls,
    this.nutrition,
    this.videoUrl,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'instructions': instructions,
        'prep_time': prepTime,
        'cook_time': cookTime,
        'total_time': totalTime,
        'difficulty': difficulty,
        'servings': servings,
        'tags': tags,
        'categories': categories,
        'ingredients': ingredients.map((e) => e.toFirestore()).toList(),
        'keepImageUrls': keepImageUrls,
        'removeImageUrls': removeImageUrls,
        'nutrition': nutrition,
        'video_url': videoUrl,
      };
}
