import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/shared/chips_input.dart';
import 'package:recipe_book/shared/list_input.dart';
import 'create_recipe_provider.dart';
import 'package:recipe_book/features/ingredient/ingredient.dart';

class CreateRecipeScreen extends ConsumerWidget {
  const CreateRecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRecipeProvider);
    final vm = ref.read(createRecipeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.editingRecipe != null ? 'Edit Recipe' : 'Create Recipe',
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.errorMessage != null)
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  TextField(
                    focusNode: vm.titleFocus,
                    decoration: const InputDecoration(labelText: 'Title'),
                    controller: vm.titleController,
                    onChanged: vm.setTitle,
                    onSubmitted: (_) => FocusScope.of(
                      context,
                    ).requestFocus(vm.descriptionFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: vm.descriptionFocus,
                    decoration: const InputDecoration(labelText: 'Description'),
                    controller: vm.descriptionController,
                    onChanged: vm.setDiscription,
                  ),
                  const SizedBox(height: 16),
                  ListInput<Ingredient>(
                    label: 'Ingredients',
                    items: state.ingredients,
                    onChanged: vm.setIngredients,
                    itemBuilder: (item, remove) => ListTile(
                      title: Text(
                        '${item.name} - ${item.quantity} ${item.unit}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: remove,
                      ),
                    ),
                    itemCreator: (context) async {
                      String name = '';
                      double quantity = 0;
                      String unit = '';
                      // show dialog to input these values and return an Ingredient
                      final result = await showDialog<Ingredient>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Add Ingredient'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                                onChanged: (v) => name = v,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (v) =>
                                    quantity = double.tryParse(v) ?? 0,
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Unit',
                                ),
                                onChanged: (v) => unit = v,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(
                                context,
                                Ingredient(
                                  name: name,
                                  quantity: quantity,
                                  unit: unit,
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      );
                      return result;
                    },
                  ),

                  const SizedBox(height: 16),
                  ListInput<String>(
                    label: 'Instructions',
                    items: state.instructions,
                    onChanged: vm.setInstructions,
                    itemBuilder: (item, onRemove) => ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onRemove,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListInput<String>(
                    label: 'Images',
                    items: state.imageUrls,
                    onChanged: vm.setImageUrls,
                    itemBuilder: (item, onRemove) => ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: onRemove,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: vm.prepTimeFocus,
                          decoration: const InputDecoration(
                            labelText: 'Prep Time',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              vm.setPrepTime(int.tryParse(v) ?? 0),
                          controller: vm.prepTimeController,
                           onSubmitted: (_) => FocusScope.of(context).requestFocus(vm.cookTimeFocus)
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          focusNode: vm.cookTimeFocus,
                          decoration: const InputDecoration(
                            labelText: 'Cook Time',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              vm.setCookTime(int.tryParse(v) ?? 0),
                          controller: vm.cookTimeController,
                           onSubmitted: (_) => FocusScope.of(context).requestFocus(vm.totalTimeFocus)
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          focusNode: vm.totalTimeFocus,
                          decoration: const InputDecoration(
                            labelText: 'Total Time',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              vm.setTotalTime(int.tryParse(v) ?? 0),
                          controller: vm.totalTimeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: state.difficulty,
                    items: ['Easy', 'Medium', 'Hard']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: vm.setDifficulty,
                    decoration: const InputDecoration(labelText: 'Difficulty'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Servings'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setServings(int.tryParse(v) ?? 1),
                    controller: vm.servingsController,
                  ),
                  const SizedBox(height: 16),
                  ChipsInput(
                    label: 'Tags',
                    items: state.tags,
                    onChanged: vm.setTags,
                    suggestions: const [
                      'Dessert',
                      'Breakfast',
                      'Dinner',
                      'Snack',
                    ],
                  ),
                  const SizedBox(height: 16),
                  ChipsInput(
                    label: 'Categories',
                    items: state.categories,
                    onChanged: vm.setCategories,
                    suggestions: const [
                      'Dessert',
                      'Main Course',
                      'Appetizer',
                      'Snack',
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    focusNode: vm.videoUrlFocus,
                    decoration: const InputDecoration(
                      labelText: 'Video URL (Optional)',
                    ),
                    onChanged: vm.setVideoUrl,
                    controller: vm.videoUrlController,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.saveRecipe(ref),
                    child: Text(
                      state.editingRecipe != null
                          ? 'Update Recipe'
                          : 'Create Recipe',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
