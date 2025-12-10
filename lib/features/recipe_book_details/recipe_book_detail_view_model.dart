import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipe_book_details/recipe_book_detail_state.dart';

class RecipeBookDetailViewModel extends Notifier<RecipeBookDetailState> {
@override
  RecipeBookDetailState build() {
    state = RecipeBookDetailState.initial();

    return state;
  }
}