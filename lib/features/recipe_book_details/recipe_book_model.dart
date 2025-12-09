import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class RecipeBook {
  final String id;
  final String ownerId;
  final String title;
  final List<Recipe> recipies;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String? thumbnailUrl;

  RecipeBook({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.recipies,
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
      recipies: (data['recipies'] as List<dynamic>? ?? [])
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
      'recipies': recipies.map((element) => element.toMap()),
      'thumbnailUrl': thumbnailUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  RecipeBook copyWith({
    String? title,
    List<Recipe>? recipies,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? thumbnailUrl,
  }) {
    return RecipeBook(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      recipies: recipies ?? this.recipies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  String toString() {
    return 'RecipeBook(id: $id, ownerId: $ownerId, title: $title, '
        'recipesCount: ${recipies.length}, createdAt: $createdAt, '
        'updatedAt: $updatedAt, thumbnailUrl: $thumbnailUrl)';
  }
}
