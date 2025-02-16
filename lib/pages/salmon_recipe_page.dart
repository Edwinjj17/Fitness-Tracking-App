import 'package:flutter/material.dart';

class SalmonRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salmon Recipe"),
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
              "Grilled Salmon",
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
            Text("• 2 salmon fillets"),
            Text("• 1 tbsp olive oil"),
            Text("• 1 tsp garlic powder"),
            Text("• 1 tsp lemon juice"),
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
            Text("1. Preheat grill or pan to medium heat."),
            Text(
                "2. Brush salmon fillets with olive oil, and season with garlic powder, lemon juice, salt, and pepper."),
            Text("3. Grill or sear salmon for 4-5 minutes per side until flaky."),
            Text("4. Serve with a side of steamed vegetables or salad."),
          ],
        ),
      ),
    );
  }
}
