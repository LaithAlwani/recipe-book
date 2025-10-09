class Ingredient {
  final String name;
  final double quantity;
  final String? unit;
  final bool optional;

  Ingredient({
    required this.name,
    required this.quantity,
    this.unit,
    this.optional = false,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'],
      optional: map['optional'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      if (unit != null) 'unit': unit,
      'optional': optional,
    };
  }
}

