import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String name;
  final double quantity;
  final String? unit;
  final bool checked;
  final bool optional;

  Ingredient({
    required this.name,
    required this.quantity,
    this.unit,
    this.checked = false,
    this.optional = false,
  });

  factory Ingredient.fromFirestore(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'],
      checked: map['checked']?? false,
      optional: map['optional'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'quantity': quantity,
      if (unit != null) 'unit': unit,
      'optional': optional,
    };
  }

  Ingredient copywith({
    String? name,
    double? quantity,
    String? unit,
    bool? optional,
  }) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      optional: optional ?? this.optional,
    );
  }
}
