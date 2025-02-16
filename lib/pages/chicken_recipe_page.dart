import 'package:flutter/material.dart';

class ChickenRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grilled Chicken Recipe"),
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
              "Grilled Chicken",
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
            Text("• 2 chicken breasts"),
            Text("• 2 tbsp olive oil"),
            Text("• 1 tsp garlic powder"),
            Text("• 1 tsp paprika"),
            Text("• Salt and pepper to taste"),
            const SizedBox(height: 20),
            Text(
              "Instructions:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("1. Preheat grill to medium-high heat."),
            Text(
                "2. Brush chicken breasts with olive oil and season with garlic powder, paprika, salt, and pepper."),
            Text("3. Grill chicken for 6-7 minutes on each side or until cooked."),
            Text("4. Let rest for 5 minutes before serving."),
          ],
        ),
      ),
    );
  }
}
