import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For handling dates

class WaterIntakePage extends StatefulWidget {
  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  int _waterIntake = 0; // in milliliters
  int _goal = 3000; // default goal in milliliters
  String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Today's date

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load saved data when the app starts
    _initializeNotifications();
    _scheduleHydrationReminder();
  }

  Future<void> _initializeNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;
  }

  Future<void> _showHydrationReminderNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'hydration_channel',
      'Hydration Notifications',
      channelDescription: 'Notifications for water intake reminder',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Hydration Reminder',
      'Time to hydrate! Drink some water.',
      platformChannelSpecifics,
    );
  }

  void _scheduleHydrationReminder() {
    const Duration interval = Duration(minutes: 30);

    Future.delayed(interval, () {
      _showHydrationReminderNotification();
      _scheduleHydrationReminder(); // Reschedule for next interval
    });
  }

  // Load water intake and goal from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String savedDate = prefs.getString('date') ?? _currentDate;

    if (savedDate == _currentDate) {
      setState(() {
        _waterIntake = prefs.getInt('waterIntake') ?? 0;
        _goal = prefs.getInt('goal') ?? 3000;
      });
    } else {
      // If it's a new day, reset the intake
      setState(() {
        _waterIntake = 0;
        _goal = prefs.getInt('goal') ?? 3000;
      });
      _saveData(); // Save the new date and reset intake
    }
  }

  // Save water intake, goal, and date to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterIntake', _waterIntake);
    await prefs.setInt('goal', _goal);
    await prefs.setString('date', _currentDate);
  }

  void _addWater(int amount) {
    setState(() {
      _waterIntake += amount;
    });
    _saveData();
  }

  void _removeWater(int amount) {
    setState(() {
      _waterIntake = (_waterIntake - amount).clamp(0, _waterIntake); // Prevent negative values
    });
    _saveData();
  }

  void _editGoal() {
    _showEditGoalDialog(
      context: context,
      initialGoal: _goal,
      onSave: (newGoal) {
        setState(() {
          _goal = newGoal;
        });
        _saveData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isGoalAchieved = _waterIntake >= _goal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProgressCard(
              title: 'Water Intake',
              current: _waterIntake,
              goal: _goal,
              unit: 'ml',
              gradientColors: [Colors.teal, Colors.tealAccent],
            ),
            SizedBox(height: 30),
            Column(
              children: [
                _buildStretchedButton('Add 250ml', Colors.blue, () => _addWater(250)),
                SizedBox(height: 10),
                _buildStretchedButton('Add 500ml', Colors.blueAccent, () => _addWater(500)),
                SizedBox(height: 10),
                _buildStretchedButton('Progress Back', Colors.red, () => _removeWater(250)),
                SizedBox(height: 10),
                if (isGoalAchieved)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Goal Achieved!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                _buildStretchedButton('Edit Goal', Colors.orange, _editGoal),
              ],
            ),
          ],
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
            'Current: $current $unit',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            'Goal: $goal $unit',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: current / goal,
            backgroundColor: Colors.white.withOpacity(0.2),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStretchedButton(String label, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
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
}
