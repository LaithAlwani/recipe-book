import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book/recipe_book_state.dart';
import 'package:recipe_book/features/recipe_book/recipe_book_view_model.dart';

final recipeBookNotifierProvider =
    NotifierProvider<RecipeBookViewModel, RecipeBookState>(
      () => RecipeBookViewModel(),
    );
