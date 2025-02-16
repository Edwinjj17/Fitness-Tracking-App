import 'package:flutter/material.dart';

class LeanBeefRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lean Beef Recipe"),
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
              "• 1 lb lean beef steak (sirloin, flank, or tenderloin)\n"
              "• 1 tablespoon olive oil\n"
              "• 2 cloves garlic (minced)\n"
              "• 1 tablespoon fresh rosemary (chopped)\n"
              "• 1 tablespoon balsamic vinegar\n"
              "• Salt and pepper to taste\n"
              "• 1 lemon (zested and juiced)\n",
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
              "1. Preheat a grill or skillet over medium-high heat.\n"
              "2. Season the beef with salt, pepper, rosemary, and lemon zest.\n"
              "3. Heat olive oil in the skillet or brush the grill with oil.\n"
              "4. Add garlic to the skillet for 1-2 minutes until fragrant.\n"
              "5. Grill or pan-sear the beef for about 4-5 minutes on each side for medium-rare (adjust to your preference).\n"
              "6. Drizzle balsamic vinegar over the beef just before serving.\n"
              "7. Serve with your favorite vegetables or a fresh salad.\n",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
