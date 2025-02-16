import 'package:flutter/material.dart';

class CottageCheeseRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cottage Cheese Recipe"),
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
              "• 1 cup cottage cheese\n"
              "• 1 tablespoon honey\n"
              "• 1/2 teaspoon vanilla extract\n"
              "• 1/4 cup mixed berries (blueberries, strawberries, raspberries)\n"
              "• 1 tablespoon chia seeds (optional)\n"
              "• A pinch of cinnamon (optional)\n",
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
              "1. In a bowl, combine cottage cheese, honey, and vanilla extract.\n"
              "2. Stir well to mix all ingredients.\n"
              "3. Top with mixed berries, chia seeds, and a sprinkle of cinnamon if desired.\n"
              "4. Enjoy this nutritious and protein-packed snack!\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
