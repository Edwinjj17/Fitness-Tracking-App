import 'package:flutter/material.dart';

class LentilsRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lentil Recipe"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Ingredients:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "• 1 cup lentils (rinsed)\n"
              "• 1 onion (diced)\n"
              "• 2 cloves garlic (minced)\n"
              "• 1 carrot (diced)\n"
              "• 2 cups vegetable broth\n"
              "• 1 tablespoon olive oil\n"
              "• 1 teaspoon cumin\n"
              "• 1 teaspoon turmeric\n"
              "• Salt and pepper to taste\n"
              "• 1 tablespoon lemon juice\n"
              "• Fresh cilantro for garnish (optional)\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Instructions:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. Heat olive oil in a large pot over medium heat.\n"
              "2. Add onions, carrots, and garlic. Cook until softened (about 5 minutes).\n"
              "3. Stir in cumin, turmeric, salt, and pepper.\n"
              "4. Add lentils and vegetable broth. Bring to a boil.\n"
              "5. Reduce heat, cover, and simmer for about 25-30 minutes until lentils are tender.\n"
              "6. Stir in lemon juice and adjust seasonings if necessary.\n"
              "7. Garnish with fresh cilantro if desired and serve with rice or bread.\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
