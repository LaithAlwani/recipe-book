import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book/recipe_book_state.dart';

class RecipeBookViewModel extends Notifier<RecipeBookState> {
  @override
  RecipeBookState build() {
    state = RecipeBookState.initial();

    return state;
  }
}
