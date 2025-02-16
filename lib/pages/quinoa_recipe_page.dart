import 'package:flutter/material.dart';

class QuinoaRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quinoa Salad Recipe"),
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
              "Quinoa Salad",
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
            Text("• 1 cup cooked quinoa"),
            Text("• 1/2 cup chopped cucumbers"),
            Text("• 1/2 cup chopped cherry tomatoes"),
            Text("• 1/4 cup crumbled feta cheese"),
            Text("• 2 tbsp olive oil"),
            Text("• 1 tbsp lemon juice"),
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
            Text("1. In a large bowl, combine quinoa, cucumbers, and tomatoes."),
            Text("2. Drizzle with olive oil and lemon juice."),
            Text("3. Add feta cheese, and season with salt and pepper."),
            Text("4. Toss everything together and serve chilled."),
          ],
        ),
      ),
    );
  }
}
