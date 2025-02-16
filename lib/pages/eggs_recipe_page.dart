import 'package:flutter/material.dart';

class EggsRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Egg Recipe"),
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
              "Boiled Eggs",
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
            Text("• 4 large eggs"),
            Text("• Water"),
            Text("• Salt (optional)"),
            const SizedBox(height: 20),
            Text(
              "Instructions:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("1. Place eggs in a pot and cover with water."),
            Text("2. Bring water to a boil, then reduce heat to simmer."),
            Text("3. Cook for 6-7 minutes for soft-boiled or 10 minutes for hard-boiled."),
            Text("4. Cool eggs in ice water, peel, and enjoy."),
          ],
        ),
      ),
    );
  }
}
