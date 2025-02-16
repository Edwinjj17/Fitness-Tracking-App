import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chicken_recipe_page.dart';
import 'salmon_recipe_page.dart';
import 'quinoa_recipe_page.dart';
import 'eggs_recipe_page.dart';
import 'tofu_recipe_page.dart';
import 'LeenBeefRecipeePage.dart';
import 'cottage_cheese_recipe_page.dart';
import 'lentils_recipe_page.dart';

class DietPage extends StatefulWidget {
  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> presetFoodItems = [
    {
      "name": "Grilled Chicken",
      "description": "High-protein and low-fat",
      "imagePath": "assets/img/chicken.png",
      "page": ChickenRecipePage()
    },
    {
      "name": "Salmon",
      "description": "Rich in omega-3 fatty acids",
      "imagePath": "assets/img/salmon.png",
      "page": SalmonRecipePage()
    },
    {
      "name": "Quinoa Salad",
      "description": "Complete plant-based protein",
      "imagePath": "assets/img/quinoa.png",
      "page": QuinoaRecipePage()
    },
    {
      "name": "Boiled Eggs",
      "description": "Quick and nutritious snack",
      "imagePath": "assets/img/eggs.png",
      "page": EggsRecipePage()
    },
    {
      "name": "Tofu Stir Fry",
      "description": "Protein-packed vegan meal",
      "imagePath": "assets/img/tofu.png",
      "page": TofuRecipePage()
    },
    {
      "name": "Lean Beef",
      "description": "Excellent source of protein and iron",
      "imagePath": "assets/img/leenbeef.png",
      "page": LeanBeefRecipePage()
    },
    {
      "name": "Lentils",
      "description": "Rich in fiber and plant-based protein",
      "imagePath": "assets/img/lentils.png",
      "page": LentilsRecipePage()
    },
    {
      "name": "Cottage Cheese",
      "description": "High in protein and low in fat",
      "imagePath": "assets/img/cottage.png",
      "page": CottageCheeseRecipePage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Healthy High-Protein Foods",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                'assets/img/Frame (3).png',
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: presetFoodItems.length,
                itemBuilder: (context, index) {
                  final food = presetFoodItems[index];
                  return _buildFoodCard(
                    context,
                    name: food["name"],
                    description: food["description"],
                    imagePath: food["imagePath"],
                    navigateTo: food["page"],
                  );
                },
              ),
              StreamBuilder(
                stream: _firestore.collection('dietItems').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final items = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var food = items[index];
                      return _buildFoodCard(
                        context,
                        name: food["name"],
                        description: food["description"],
                        imagePath: food["imagePath"],
                        navigateTo: null, // No specific page for Firebase items
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context,
      {required String name,
      required String description,
      required String imagePath,
      required Widget? navigateTo}) {
    return GestureDetector(
      onTap: navigateTo != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateTo),
              );
            }
          : null,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.only(bottom: 20),
        color: Colors.blue[50],
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
