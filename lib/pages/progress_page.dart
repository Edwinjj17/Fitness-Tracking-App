import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WeeklyProgress {
  final int totalSteps;
  final double totalDistance;
  final double totalCalories;
  final DateTime weekStart;
  final DateTime weekEnd;

  static const int weeklyStepsGoal = 70000;  
  static const double weeklyCaloriesGoal = 3500.0;  
  static const double weeklyDistanceGoal = 35.0;    

  WeeklyProgress({
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCalories,
    required this.weekStart,
    required this.weekEnd,
  });

  double get stepsProgress => totalSteps / weeklyStepsGoal;
  double get caloriesProgress => totalCalories / weeklyCaloriesGoal;
  double get distanceProgress => totalDistance / weeklyDistanceGoal;
}

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  WeeklyProgress? currentWeekProgress;

  @override
  void initState() {
    super.initState();
    _loadWeeklyProgress();
  }

  Future<void> _loadWeeklyProgress() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEndDate = weekStartDate.add(Duration(days: 7));

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: weekStartDate.toIso8601String())
          .where('date', isLessThan: weekEndDate.toIso8601String())
          .get();

      int totalSteps = 0;
      double totalDistance = 0.0;
      double totalCalories = 0.0;

      for (var doc in querySnapshot.docs) {
        totalSteps += doc['steps'] as int;
        totalDistance += doc['distance'] as double;
        totalCalories += doc['calories'] as double;
      }

      setState(() {
        currentWeekProgress = WeeklyProgress(
          totalSteps: totalSteps,
          totalDistance: totalDistance,
          totalCalories: totalCalories,
          weekStart: weekStartDate,
          weekEnd: weekEndDate,
        );
      });
    } catch (e) {
      print('Error loading weekly progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Weekly Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadWeeklyProgress,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade200, Colors.blueAccent.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrinks the column to fit its content
            children: [
              SizedBox(height: 20),
              Text(
                'Your Weekly Progress',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                currentWeekProgress != null
                    ? '${DateFormat('MMM d').format(currentWeekProgress!.weekStart)} - ${DateFormat('MMM d').format(currentWeekProgress!.weekEnd)}'
                    : 'Loading...',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),

              if (currentWeekProgress != null) ...[
                _buildProgressCard(
                  'Steps',
                  currentWeekProgress!.stepsProgress,
                  '${currentWeekProgress!.totalSteps}',
                  Icons.directions_walk,
                ),
                _buildProgressCard(
                  'Distance',
                  currentWeekProgress!.distanceProgress,
                  '${(currentWeekProgress!.totalDistance / 1000).toStringAsFixed(2)} km',
                  Icons.map,
                ),
                _buildProgressCard(
                  'Calories',
                  currentWeekProgress!.caloriesProgress,
                  '${currentWeekProgress!.totalCalories.toStringAsFixed(0)} kcal',
                  Icons.local_fire_department,
                ),
              ] else ...[
                Center(child: CircularProgressIndicator(color: Colors.white)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(String label, double progress, String details, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 30),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
              minHeight: 8,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% Completed',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  details,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
