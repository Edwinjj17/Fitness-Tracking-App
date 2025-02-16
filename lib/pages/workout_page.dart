import 'package:flutter/material.dart';
import 'chest_page.dart';
import 'back_page.dart';
import 'legs_page.dart';
import 'arms_page.dart';
import 'shoulders_page.dart';
import 'core_page.dart';

class WorkoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> bodyParts = [
    {"name": "Chest", "image": "assets/img/chest.png", "page": ChestPage(), "color": Colors.blue[100]},
    {"name": "Back", "image": "assets/img/back.png", "page": BackPage(), "color": Colors.green[100]},
    {"name": "Legs", "image": "assets/img/legs.png", "page": LegsPage(), "color": Colors.orange[100]},
    {"name": "Arms", "image": "assets/img/arms.png", "page": ArmsPage(), "color": Colors.purple[100]},
    {"name": "Shoulders", "image": "assets/img/shoulders.png", "page": ShouldersPage(), "color": Colors.red[100]},
    {"name": "Core", "image": "assets/img/core.png", "page": CorePage(), "color": Colors.teal[100]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Workout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
              Colors.blue[500]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Container(
                height: 400,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/img/Vector-Section.png',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose Your",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "Workout Focus",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Body Parts Grid
              Container(
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: bodyParts.length,
                  itemBuilder: (context, index) {
                    return _buildBodyPartCard(
                      context,
                      bodyParts[index]["name"]!,
                      bodyParts[index]["image"]!,
                      bodyParts[index]["page"],
                      bodyParts[index]["color"] as Color?,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyPartCard(BuildContext context, String name, String imagePath, Widget navigateTo, Color? backgroundColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: backgroundColor ?? Colors.blue[100]!,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (backgroundColor ?? Colors.blue[100]!).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: backgroundColor ?? Colors.blue[100],
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "View Exercises",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}