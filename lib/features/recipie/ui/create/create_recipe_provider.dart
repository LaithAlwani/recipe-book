import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/features/recipie/ui/create/create_recipe_state.dart';
import 'package:recipe_book/features/recipie/ui/create/create_recipe_viewmodel.dart';

final createRecipeProvider =
    NotifierProvider<CreateRecipeNotifier, CreateRecipeState>(
      () => CreateRecipeNotifier(),
    );
