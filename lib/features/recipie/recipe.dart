import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';

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
  final int viewCount;
  final int favoriteCount;

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
    this.viewCount = 0,
    this.favoriteCount = 0,
  });

  factory Recipe.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return Recipe(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      instructions: List<String>.from(data['instructions'] ?? []),
      prepTime: (data['prep_time'] ?? 0) as int,
      cookTime: (data['cook_time'] ?? 0) as int,
      totalTime: (data['total_time'] ?? 0) as int,
      viewCount: (data['view_count'] ?? 0) as int,
      favoriteCount: (data['favorite_count'] ?? 0) as int,
      difficulty: data['difficulty'] ?? 'Medium',
      servings: (data['servings'] ?? 1) as int,
      tags: List<String>.from(data['tags'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      ingredients: (data['ingredients'] as List<dynamic>? ?? [])
          .map((e) => Ingredient.fromFirestore(Map<String, dynamic>.from(e)))
          .toList(),
      imageUrls: List<String>.from(data['image_urls'] ?? []),
      createdBy: data['created_by'] ?? '',
      createdAt: data['created_at'] is Timestamp
          ? data['created_at']
          : Timestamp.now(),
      updatedAt: data['updated_at'] is Timestamp
          ? data['updated_at']
          : Timestamp.now(),
      nutrition: data['nutrition'] != null
          ? Map<String, dynamic>.from(data['nutrition'])
          : null,
      ratings: data['ratings'] != null
          ? Map<String, int>.from(data['ratings'])
          : null,
      videoUrl: data['video_url'],
      metadata: data['metadata'] != null
          ? Map<String, dynamic>.from(data['metadata'])
          : null,
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
      'read_count': viewCount,
      'favorite_count': favoriteCount,
      if (nutrition != null) 'nutrition': nutrition,
      if (ratings != null) 'ratings': ratings,
      if (videoUrl != null) 'video_url': videoUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }

  Recipe copyWith({
    String? title,
    String? description,
    List<String>? instructions,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    int? viewCount,
    int? favoriteCount,
    String? difficulty,
    int? servings,
    List<String>? tags,
    List<String>? categories,
    List<Ingredient>? ingredients,
    List<String>? imageUrls,
    String? createdBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Map<String, dynamic>? nutrition,
    Map<String, int>? ratings,
    String? videoUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Recipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      categories: categories ?? this.categories,
      ingredients: ingredients ?? this.ingredients,
      imageUrls: imageUrls ?? this.imageUrls,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      nutrition: nutrition ?? this.nutrition,
      ratings: ratings ?? this.ratings,
      videoUrl: videoUrl ?? this.videoUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
