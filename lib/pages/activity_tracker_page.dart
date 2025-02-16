import 'package:fitness_app/pages/steps_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/pages/protein_intake_page.dart';
import 'package:fitness_app/pages/sleep_tracker_page.dart';
import 'package:fitness_app/pages/water_intake_page.dart';

void main() {
  runApp(ActivityTrackerApp());
}

class ActivityTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity Tracker',
      home: ActivityTrackerPage(),
    );
  }
}

class ActivityTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/img/Frame (2).png', // Ensure correct image path
              height: 450,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            _buildActivityCard(
              context,
              title: 'Steps Tracker',
              icon: Icons.directions_walk,
              gradientColors: [Colors.blue, Colors.blueAccent],
              page: StepsPage(),
            ),
            SizedBox(height: 16),
            _buildActivityCard(
              context,
              title: 'Water Intake',
              icon: Icons.local_drink,
              gradientColors: [Colors.teal, Colors.tealAccent],
              page: WaterIntakePage(),
            ),
            SizedBox(height: 16),
            _buildActivityCard(
              context,
              title: 'Sleep Tracker',
              icon: Icons.bedtime,
              gradientColors: [Colors.purple, Colors.purpleAccent],
              page: SleepTrackerPage(),
            ),
            SizedBox(height: 16),
            _buildActivityCard(
              context,
              title: 'Protein Intake',
              icon: Icons.fitness_center,
              gradientColors: [Colors.orange, Colors.deepOrangeAccent],
              page: ProteinIntakePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
