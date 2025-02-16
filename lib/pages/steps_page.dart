import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutRecord {
  final int steps;
  final double distance;
  final double calories;
  final int duration;
  final DateTime date;
  String? id; // Added for Firebase document ID

  WorkoutRecord({
    required this.steps,
    required this.distance,
    required this.calories,
    required this.duration,
    required this.date,
    this.id,
  });

  Map<String, dynamic> toJson() => {
    'steps': steps,
    'distance': distance,
    'calories': calories,
    'duration': duration,
    'date': date.toIso8601String(),
  };

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) => WorkoutRecord(
    steps: json['steps'],
    distance: json['distance'],
    calories: json['calories'],
    duration: json['duration'],
    date: DateTime.parse(json['date']),
    id: json['id'],
  );
}

class WorkoutFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> saveWorkout(WorkoutRecord workout) async {
    if (currentUserId == null) {
      throw Exception('No authenticated user found');
    }

    try {
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .add({
        'steps': workout.steps,
        'distance': workout.distance,
        'calories': workout.calories,
        'duration': workout.duration,
        'date': workout.date.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      workout.id = docRef.id;
    } catch (e) {
      throw Exception('Failed to save workout: $e');
    }
  }

  Stream<List<WorkoutRecord>> getWorkoutHistory() {
    if (currentUserId == null) {
      throw Exception('No authenticated user found');
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return WorkoutRecord(
                steps: data['steps'],
                distance: data['distance'],
                calories: data['calories'],
                duration: data['duration'],
                date: DateTime.parse(data['date']),
                id: doc.id,
              );
            }).toList());
  }

  Future<void> deleteWorkout(String workoutId) async {
    if (currentUserId == null) {
      throw Exception('No authenticated user found');
    }

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .doc(workoutId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete workout: $e');
    }
  }
}

class StepsPage extends StatefulWidget {
  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  final WorkoutFirebaseService _firebaseService = WorkoutFirebaseService();
  StreamSubscription<StepCount>? _stepCountSubscription;
  Timer? _timer;
  StreamSubscription<List<WorkoutRecord>>? _workoutSubscription;

  int _steps = 0;
  double _distance = 0.0;
  double _calories = 0.0;
  int _seconds = 0;

  bool _isTracking = false;
  bool _isPaused = false;

  List<WorkoutRecord> _workoutHistory = [];

  final double stepLength = 0.78;
  final double caloriesPerStep = 0.04;

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    try {
      _workoutSubscription = _firebaseService.getWorkoutHistory().listen(
        (workouts) {
          setState(() {
            _workoutHistory = workouts;
          });
        },
        onError: (error) {
          _showErrorDialog('Error', 'Failed to load workout history: $error');
        },
      );
    } catch (e) {
      _showErrorDialog('Error', 'Failed to load workout history: $e');
    }
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _isPaused = false;
      _steps = 0;
      _seconds = 0;
      _distance = 0.0;
      _calories = 0.0;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _seconds++;
        });
      }
    });

    _stepCountSubscription = Pedometer.stepCountStream.listen(
      (StepCount event) {
        if (!_isPaused) {
          setState(() {
            _steps = event.steps;
            _distance = _steps * stepLength;
            _calories = _steps * caloriesPerStep;
          });
        }
      },
      onError: (error) {
        print('Error: $error');
        _showErrorDialog('Pedometer Error', 'Failed to access step counter: $error');
      },
    );
  }

  void _pauseTracking() {
    setState(() {
      _isPaused = true;
    });
    _showSnackBar('Tracking paused');
  }

  void _resumeTracking() {
    setState(() {
      _isPaused = false;
    });
    _showSnackBar('Tracking resumed');
  }

  void _stopTracking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stop Tracking'),
          content: Text('Are you sure you want to stop tracking? Current progress will be saved.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Stop'),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmStopTracking();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmStopTracking() async {
    final newRecord = WorkoutRecord(
      steps: _steps,
      distance: _distance,
      calories: _calories,
      duration: _seconds,
      date: DateTime.now(),
    );

    try {
      // Save to Firebase
      await _firebaseService.saveWorkout(newRecord);
      
      setState(() {
        _isTracking = false;
        _isPaused = false;
        _timer?.cancel();
        _stepCountSubscription?.cancel();
      });

      _showSnackBar('Workout saved successfully');
    } catch (e) {
      _showErrorDialog('Error', 'Failed to save workout: $e');
    }
  }

  void _deleteWorkout(WorkoutRecord record) async {
    if (record.id == null) return;

    try {
      await _firebaseService.deleteWorkout(record.id!);
      _showSnackBar('Workout deleted successfully');
    } catch (e) {
      _showErrorDialog('Error', 'Failed to delete workout: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stepCountSubscription?.cancel();
    _workoutSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Step Tracker'),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildCurrentWorkout(),
            if (_workoutHistory.isNotEmpty) ...[
              SizedBox(height: 30),
              Text(
                'Previous Workouts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 16),
              ..._workoutHistory.map((record) => _buildHistoryCard(record)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWorkout() {
    return Column(
      children: [
        _buildInfoCard('Steps Taken', _steps.toString(), Icons.directions_walk),
        SizedBox(height: 20),
        _buildInfoCard(
          'Distance Covered',
          '${(_distance / 1000).toStringAsFixed(2)} km',
          Icons.map,
        ),
        SizedBox(height: 20),
        _buildInfoCard(
          'Calories Burned',
          '${_calories.toStringAsFixed(2)} kcal',
          Icons.local_fire_department,
        ),
        SizedBox(height: 20),
        _buildInfoCard(
          'Time Spent Running',
          _formatDuration(_seconds),
          Icons.timer,
        ),
        SizedBox(height: 40),
        if (!_isTracking)
          _buildActionButton(
            'Start Tracking',
            Colors.green,
            _startTracking,
            Icons.play_arrow,
          ),
        if (_isTracking)
          Column(
            children: [
              if (!_isPaused)
                _buildActionButton(
                  'Pause Tracking',
                  Colors.orange,
                  _pauseTracking,
                  Icons.pause,
                ),
              if (_isPaused)
                _buildActionButton(
                  'Resume Tracking',
                  Colors.blue,
                  _resumeTracking,
                  Icons.play_arrow,
                ),
              SizedBox(height: 10),
              _buildActionButton(
                'Stop Tracking',
                Colors.red,
                _stopTracking,
                Icons.stop,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHistoryCard(WorkoutRecord record) {
    return Dismissible(
      key: Key(record.id ?? DateTime.now().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteWorkout(record);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(record.date),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Text(
                    _formatDuration(record.duration),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHistoryItem(
                    Icons.directions_walk,
                    '${record.steps}',
                    'Steps',
                  ),
                  _buildHistoryItem(
                    Icons.map,
                    '${(record.distance / 1000).toStringAsFixed(2)}',
                    'km',
                  ),
                  _buildHistoryItem(
                    Icons.local_fire_department,
                    '${record.calories.toStringAsFixed(2)}',
                    'kcal',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 Widget _buildHistoryItem(IconData icon, String value, String unit) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              label,
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