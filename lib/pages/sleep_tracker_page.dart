import 'dart:async';
import 'package:fitness_app/pages/sleeping_tips_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SleepTrackerPage extends StatefulWidget {
  @override
  _SleepTrackerPageState createState() => _SleepTrackerPageState();
}

class _SleepTrackerPageState extends State<SleepTrackerPage> {
  double _sleepHours = 0.0; // in hours
  double _goal = 8.0; // default goal in hours
  late String _currentDate; // To store the current date
  bool _isTracking = false; // To track if the timer is running
  late Timer _timer; // Timer for sleep tracking
  int _elapsedTimeInSeconds = 0; // Time in seconds

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _loadData(); // Load saved data when the app starts
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sleepHours = prefs.getDouble('sleepHours_$_currentDate') ?? 0.0;
      _goal = prefs.getDouble('sleepGoal') ?? 8.0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sleepHours_$_currentDate', _sleepHours);
    await prefs.setDouble('sleepGoal', _goal);
  }

  void _startTimer() {
    setState(() {
      _isTracking = true;
    });

    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTimeInSeconds++;
        _sleepHours = _elapsedTimeInSeconds / 3600; // Convert seconds to hours
      });
      _saveData(); // Save data periodically
    });
  }

  void _stopTimer() {
    setState(() {
      _isTracking = false;
    });

    // Stop the timer
    _timer.cancel();
    _saveData(); // Save the data when timer stops

    // Check if sleep time is less than 5 hours and show a warning message
    if (_sleepHours < 5) {
      _showSleepTipsSnackbar();
    }
  }

  void _resetTimer() {
    setState(() {
      _elapsedTimeInSeconds = 0;
      _sleepHours = 0.0;
    });
    _saveData(); // Reset data
  }

  void _editGoal() {
    _showEditGoalDialog(
      context: context,
      initialGoal: _goal.toInt(),
      onSave: (newGoal) {
        setState(() {
          _goal = newGoal.toDouble();
        });
        _saveData();
      },
    );
  }

  String _formatTime(int seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = (seconds % 3600) ~/ 60;
    int secondsLeft = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Tracker'),
      ),
      body: SingleChildScrollView( // Make the page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressCard(
                title: 'Sleep Hours',
                current: _sleepHours.toInt(),
                goal: _goal.toInt(),
                unit: 'hours',
                gradientColors: [Colors.purple, Colors.purpleAccent],
              ),
            SizedBox(height: 20),
              // Circular Timer
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(_elapsedTimeInSeconds),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildActionButton(
                _isTracking ? 'Stop Sleep Tracker' : 'Start Sleep Tracker',
                _isTracking ? Colors.red : Colors.green,
                _isTracking ? _stopTimer : _startTimer,
              ),
              SizedBox(height: 10),
              _buildActionButton('Reset Sleep', Colors.orange, _resetTimer),
              SizedBox(height: 10),
              _buildActionButton('Edit Goal', Colors.blue, _editGoal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required int current,
    required int goal,
    required String unit,
    required List<Color> gradientColors,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            'Current: ${_sleepHours.toStringAsFixed(2)} $unit',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            'Goal: $goal $unit',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: _sleepHours / goal,
            backgroundColor: Colors.white.withOpacity(0.2),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        minimumSize: Size(double.infinity, 50), // Make buttons equal width
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  void _showEditGoalDialog({
    required BuildContext context,
    required int initialGoal,
    required Function(int) onSave,
  }) {
    TextEditingController _goalController =
        TextEditingController(text: initialGoal.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Goal'),
          content: TextField(
            controller: _goalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter new goal'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(int.tryParse(_goalController.text) ?? initialGoal);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSleepTipsSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your sleep time is less than 5 hours. Consider improving your sleep habits. Check out our sleep tips!',
          style: TextStyle(fontSize: 16),
        ),
        action: SnackBarAction(
          label: 'Check Tips',
          onPressed: () {
            // Navigate to sleep tips page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SleepingTipsPage()),
            );
          },
        ),
        duration: Duration(seconds: 5), // Display for 5 seconds
      ),
    );
  }
}
