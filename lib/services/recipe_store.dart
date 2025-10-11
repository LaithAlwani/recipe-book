import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/services/firestore_services.dart';

class RecipeStore extends ChangeNotifier {
  final List<Recipe> _recipes = [];

  get recipes => _recipes;

  
}
