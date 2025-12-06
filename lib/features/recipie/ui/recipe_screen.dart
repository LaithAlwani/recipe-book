import 'package:flutter/material.dart';
import 'package:recipe_book/features/recipie/recipe.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key, required this.recipe});

  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  recipe.imageUrls[0],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40.0, // Adjust as needed for desired padding
                  left: 10.0, // Adjust as needed for desired padding
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25), // shadow color
                          blurRadius: 6, // how soft the shadow is
                          offset: const Offset(2, 2), // x, y offset
                        ),
                      ],
                    ),

                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Text(recipe.title),
            Text(recipe.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.grey),
                Text('${recipe.cookTime.toString()} min'),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: recipe.ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Text("${recipe.ingredients[index].name} - "),
                    Text(
                      "${recipe.ingredients[index].quantity % 1 == 0 ? recipe.ingredients[index].quantity.toInt() : recipe.ingredients[index].quantity} ",
                    ),
                    Text("${recipe.ingredients[index].unit}"),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        print(
                          "Added to shopping cart ${recipe.ingredients[index].name.toLowerCase()}",
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                  ],
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: recipe.instructions.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.amber,
                      child: Text("${index + 1}"),
                    ),
                    const SizedBox(width: 12, height: 40),
                    Expanded(
                      child: Text(
                        recipe.instructions[index],
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
