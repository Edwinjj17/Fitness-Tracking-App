import 'package:flutter/material.dart';

class TofuRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tofu Recipe"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tofu Stir Fry",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Ingredients:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("• 1 block of firm tofu"),
            Text("• 2 tbsp soy sauce"),
            Text("• 1 tbsp sesame oil"),
            Text("• 1 cup chopped bell peppers"),
            Text("• 1/2 cup sliced carrots"),
            Text("• 2 cloves garlic, minced"),
            const SizedBox(height: 20),
            Text(
              "Instructions:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("1. Cut tofu into cubes and pat dry."),
            Text("2. Heat sesame oil in a pan and sauté garlic until fragrant."),
            Text("3. Add tofu and cook until golden brown."),
            Text("4. Toss in bell peppers and carrots, and stir-fry for 5 minutes."),
            Text("5. Add soy sauce, mix well, and serve hot."),
          ],
        ),
      ),
    );
  }
}
