import 'package:flutter/material.dart';
import 'workout_page.dart';
import 'diet_page.dart';
import 'settings_page.dart';
import 'activity_tracker_page.dart';
import 'progress_page.dart';
import 'profile_page.dart';
import 'sleeping_tips_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Fitness Tracker", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Track your fitness journey and stay healthy.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/img/Frame (1).png',
                      width: media.width * 0.7,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCard(
                    context,
                    title: "Activity Tracker",
                    subtitle: "Track your daily activities",
                    imagePath: 'assets/img/Frame (2).png',
                    navigateTo: ActivityTrackerPage(),
                  ),
                  _buildCard(
                    context,
                    title: "Workout",
                    subtitle: "Body Part Exercises",
                    imagePath: 'assets/img/Vector-Section.png',
                    navigateTo: WorkoutPage(),
                  ),
                  _buildCard(
                    context,
                    title: "Diet",
                    subtitle: "Healthy Meals List",
                    imagePath: 'assets/img/Frame (3).png',
                    navigateTo: DietPage(),
                  ),
                  _buildCard(
                    context,
                    title: "Sleep",
                    subtitle: "Better Sleep Tips",
                    imagePath: 'assets/img/Frame (4).png',
                    navigateTo: SleepingTipsPage(),
                  ),
                  _buildCard(
                    context,
                    title: "Progress",
                    subtitle: "View your progress",
                    imagePath: 'assets/img/Frame.png',
                    navigateTo: ProgressPage(),
                  ),
                  _buildCard(
                    context,
                    title: "Profile",
                    subtitle: "Manage your profile",
                    imagePath: 'assets/img/Group.png',
                    navigateTo: ProfilePage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button (FAB) for Settings
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.settings, color: Colors.white, size: 28),
        elevation: 5,
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String imagePath,
      required Widget navigateTo}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => navigateTo));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]), // Navigation icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
