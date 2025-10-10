import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/ingredient.dart';

class Recipe {
  final String id;
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
  final String createdBy;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final Map<String, dynamic>? nutrition; // optional
  final Map<String, int>? ratings; // optional
  final String? videoUrl; // optional
  final Map<String, dynamic>? metadata; // optional

  Recipe({
    required this.id,
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
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.nutrition,
    this.ratings,
    this.videoUrl,
    this.metadata,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      instructions: List<String>.from(data['instructions'] ?? []),
      prepTime: data['prep_time'] ?? 0,
      cookTime: data['cook_time'] ?? 0,
      totalTime: data['total_time'] ?? 0,
      difficulty: data['difficulty'] ?? 'Medium',
      servings: data['servings'] ?? 1,
      tags: List<String>.from(data['tags'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      ingredients: data['ingredients'] != null
          ? List<Map<String, dynamic>>.from(data['ingredients'])
              .map((e) => Ingredient.fromMap(e))
              .toList()
          : [],
      imageUrls: List<String>.from(data['image_urls'] ?? []),
      createdBy: data['created_by'] ?? '',
      createdAt: data['created_at'] ?? Timestamp.now() ,
      updatedAt: data['updated_at'] ?? Timestamp.now(),
      nutrition: data['nutrition'],
      ratings: data['ratings'] != null
          ? Map<String, int>.from(data['ratings'])
          : null,
      videoUrl: data['video_url'],
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'image_urls': imageUrls,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (nutrition != null) 'nutrition': nutrition,
      if (ratings != null) 'ratings': ratings,
      if (videoUrl != null) 'video_url': videoUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
