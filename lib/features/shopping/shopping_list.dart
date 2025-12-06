import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';

class ShoppingList {
  final String id;
  final String title;
  final List<Ingredient> shopingList;
  final bool completed;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ShoppingList({
    required this.id,
    required this.title,
    required this.shopingList,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ShoppingList(
      id: doc.id,
      title: data['title'] ?? "",
      shopingList: List<Ingredient>.from(data['shoping_list'] ?? []),
      completed: data['completed'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'shopping_list': shopingList,
      'completed': completed,
      'create_at': createdAt,
      'update_at': updatedAt,
    };
  }
}
