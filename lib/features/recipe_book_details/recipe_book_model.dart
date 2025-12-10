import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class RecipeBook {
  final String id;
  final String ownerId;
  final String title;
  final List<Recipe> recipes;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? thumbnailUrl;

  RecipeBook({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.recipes,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnailUrl,
  });

  factory RecipeBook.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return RecipeBook(
      id: snapshot.id,
      ownerId: data['ownerId'] ?? "",
      title: data["title"] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      recipes: (data['recipes'] as List<dynamic>? ?? [])
          .map((doc) => Recipe.fromFirestore(doc, null))
          .toList(),
      createdAt: data['created_at'] is Timestamp
          ? data['created_at']
          : Timestamp.now(),
      updatedAt: data['updated_at'] is Timestamp
          ? data['updated_at']
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'title': title,
      'recipes': recipes.map((element) => element.toFirestore()),
      'thumbnailUrl': thumbnailUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  RecipeBook copyWith({
    String? title,
    List<Recipe>? recipes,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? thumbnailUrl,
  }) {
    return RecipeBook(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      recipes: recipes ?? this.recipes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  String toString() {
    return 'RecipeBook(id: $id, ownerId: $ownerId, title: $title, '
        'recipesCount: ${recipes.length}, createdAt: $createdAt, '
        'updatedAt: $updatedAt, thumbnailUrl: $thumbnailUrl)';
  }
}
