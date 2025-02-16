import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  final String bodyPart;

  ExercisesPage({required this.bodyPart});

  final Map<String, List<Map<String, String>>> exercises = {
    "Chest": [
      {"name": "Push-ups", "description": "3 sets of 12 reps"},
      {"name": "Bench Press", "description": "4 sets of 10 reps"},
      {"name": "Chest Fly", "description": "3 sets of 15 reps"},
    ],
    "Back": [
      {"name": "Pull-ups", "description": "3 sets to failure"},
      {"name": "Deadlifts", "description": "4 sets of 8 reps"},
      {"name": "Bent-over Rows", "description": "3 sets of 12 reps"},
    ],
    // Add more body parts and exercises here...
  };

  @override
  Widget build(BuildContext context) {
    final bodyPartExercises = exercises[bodyPart] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("$bodyPart Exercises"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: bodyPartExercises.length,
          itemBuilder: (context, index) {
            return _buildExerciseCard(
              bodyPartExercises[index]["name"]!,
              bodyPartExercises[index]["description"]!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String name, String description) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
