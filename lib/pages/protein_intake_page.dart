import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ProteinIntakePage extends StatefulWidget {
  @override
  _ProteinIntakePageState createState() => _ProteinIntakePageState();
}

class _ProteinIntakePageState extends State<ProteinIntakePage> {
  int _proteinIntake = 0; // in grams
  int _goal = 150; // default goal in grams
  String? _selectedFood; // Selected food item

  final TextEditingController _customProteinController = TextEditingController();
  Timer? _dailyResetTimer;

  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'Egg (1)', 'protein': 6},
    {'name': 'Chicken Breast (100g)', 'protein': 31},
    {'name': 'Rice (100g)', 'protein': 3},
    {'name': 'Milk (1 cup)', 'protein': 8},
    {'name': 'Lentils (100g)', 'protein': 9},
    {'name': 'Tofu (100g)', 'protein': 8},
    {'name': 'Greek Yogurt (100g)', 'protein': 10},
    {'name': 'Almonds (28g)', 'protein': 6},
    {'name': 'Peanuts (28g)', 'protein': 7},
    {'name': 'Cottage Cheese (100g)', 'protein': 11},
    {'name': 'Fish (Salmon, 100g)', 'protein': 25},
    {'name': 'Beef (100g)', 'protein': 26},
    {'name': 'Pumpkin Seeds (28g)', 'protein': 7},
    {'name': 'Edamame (100g)', 'protein': 11},
    {'name': 'Chickpeas (100g)', 'protein': 19},
    {'name': 'Whey Protein (1 scoop)', 'protein': 20},
    {'name': 'Quinoa (100g)', 'protein': 4.4},
    {'name': 'Tempeh (100g)', 'protein': 19},
    {'name': 'Pork Loin (100g)', 'protein': 27},
  ];

  @override
  void initState() {
    super.initState();
    _loadProteinData();
    _startDailyResetTimer();
  }

  @override
  void dispose() {
    _dailyResetTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProteinData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastDate') ?? '';
    final today = DateTime.now().toIso8601String().split('T').first;

    if (savedDate != today) {
      // If the date has changed, reset the protein intake
      await prefs.setInt('proteinIntake', 0);
      await prefs.setString('lastDate', today);
    }

    setState(() {
      _proteinIntake = prefs.getInt('proteinIntake') ?? 0;
      _goal = prefs.getInt('goal') ?? 150;
    });
  }

  Future<void> _saveProteinData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('proteinIntake', _proteinIntake);
    await prefs.setString('lastDate', DateTime.now().toIso8601String().split('T').first);
  }

  Future<void> _saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goal', goal);
  }

  void _startDailyResetTimer() {
    _dailyResetTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final savedDate = prefs.getString('lastDate') ?? '';
      final today = DateTime.now().toIso8601String().split('T').first;

      if (savedDate != today) {
        setState(() {
          _proteinIntake = 0;
        });
        await prefs.setInt('proteinIntake', 0);
        await prefs.setString('lastDate', today);
      }
    });
  }

  void _addProtein() {
    if (_selectedFood != null) {
      final selectedItem =
          _foodItems.firstWhere((item) => item['name'] == _selectedFood);
      setState(() {
        _proteinIntake += (selectedItem['protein'] as num).toInt();
      });
      _saveProteinData();
      _selectedFood = null;
    }
  }

  void _reduceProtein() {
    setState(() {
      _proteinIntake -= 10;
      if (_proteinIntake < 0) _proteinIntake = 0;
    });
    _saveProteinData();
  }

  void _editGoal() {
    _showEditGoalDialog(
      context: context,
      initialGoal: _goal,
      onSave: (newGoal) {
        setState(() {
          _goal = newGoal;
        });
        _saveGoal(newGoal);
      },
    );
  }

  void _addCustomProtein() {
    final customProteinValue = int.tryParse(_customProteinController.text) ?? 0;

    if (customProteinValue > 0) {
      setState(() {
        _proteinIntake += customProteinValue;
        _customProteinController.clear();
      });
      _saveProteinData();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isGoalAchieved = _proteinIntake >= _goal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Protein Intake Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressCard(
                title: 'Protein Intake',
                current: _proteinIntake,
                goal: _goal,
                unit: 'g',
                gradientColors: [Colors.orange, Colors.deepOrangeAccent],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFood,
                decoration: InputDecoration(
                  labelText: 'Select Food Item',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                items: _foodItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['name'],
                    child: Text('${item['name']} (${item['protein']}g)'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFood = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                        'Add Protein', Colors.blue, _addProtein),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                        'Progress Back', Colors.red, _reduceProtein),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _customProteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter custom protein (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                        'Add Custom Protein', Colors.green, _addCustomProtein),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton('Edit Goal', Colors.orange, _editGoal),
                  ),
                ],
              ),
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

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
}
