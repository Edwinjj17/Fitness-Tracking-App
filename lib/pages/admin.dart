import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Enabling Material 3 for modern UI
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages() => [
        ManageSleepingTips(),
        ManageArmsExercises(),
        ManageChestExercises(), 
        ManageBackExercises(),  
        ManageCoreExercises(), 
        ManageLegsExercises(), 
        ManageShouldersExercises(),
        ViewUsers(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.bedtime), label: "Sleep Tips"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Arms"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Chest"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Back"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Core"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Legs"),  
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Manage Shpulders"),  
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ------------------- Manage Sleeping Tips -------------------
class ManageSleepingTips extends StatefulWidget {
  @override
  _ManageSleepingTipsState createState() => _ManageSleepingTipsState();
}

class _ManageSleepingTipsState extends State<ManageSleepingTips> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference tipsCollection =
      FirebaseFirestore.instance.collection('sleeping_tips');

  void addTip() async {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await tipsCollection.add({
        'title': _titleController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tip Added Successfully!"), backgroundColor: Colors.green),
      );

      _titleController.clear();
      _descController.clear();
    }
  }

  void deleteTip(String docId) async {
    await tipsCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tip Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Sleeping Tips",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Tip Title",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Tip Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addTip,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Tip", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: tipsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading tips"));
              }

              List<DocumentSnapshot> tips = snapshot.data!.docs;

              return ListView.builder(
                itemCount: tips.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var tip = tips[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        tip["title"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        tip["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteTip(tip.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ------------------- Manage Arms Exercises -------------------
class ManageArmsExercises extends StatefulWidget {
  @override
  _ManageArmsExercisesState createState() => _ManageArmsExercisesState();
}

class _ManageArmsExercisesState extends State<ManageArmsExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference armsCollection =
      FirebaseFirestore.instance.collection('workout_exercises');

  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await armsCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    }
  }

  void deleteExercise(String docId) async {
    await armsCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Arms Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: armsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ------------------- View Users -------------------
class ViewUsers extends StatelessWidget {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users List")),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching users"));
          }

          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user["name"]),
                subtitle: Text(user["email"]),
                leading: Icon(Icons.person),
              );
            },
          );
        },
      ),
    );
  }
}
class ManageChestExercises extends StatefulWidget {
  @override
  _ManageChestExercisesState createState() => _ManageChestExercisesState();
}

class _ManageChestExercisesState extends State<ManageChestExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference chestCollection =
      FirebaseFirestore.instance.collection('chest_exercises');

  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await chestCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    }
  }

  void deleteExercise(String docId) async {
    await chestCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Chest Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: chestCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
// ------------------- Manage Back Exercises -------------------
class ManageBackExercises extends StatefulWidget {
  @override
  _ManageBackExercisesState createState() => _ManageBackExercisesState();
}

class _ManageBackExercisesState extends State<ManageBackExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference backCollection =
      FirebaseFirestore.instance.collection('back_exercises');

  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await backCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Back Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    }
  }

  void deleteExercise(String docId) async {
    await backCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Back Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: backCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ------------------- Manage Core Exercises -------------------
class ManageCoreExercises extends StatefulWidget {
  @override
  _ManageCoreExercisesState createState() => _ManageCoreExercisesState();
}

class _ManageCoreExercisesState extends State<ManageCoreExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference coreCollection =
      FirebaseFirestore.instance.collection('core_exercises');

  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await coreCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Core Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    }
  }

  void deleteExercise(String docId) async {
    await coreCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Core Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Core Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: coreCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Manage Legs Workout
class ManageLegsExercises extends StatefulWidget {
  @override
  _ManageLegsExercisesState createState() => _ManageLegsExercisesState();
}

class _ManageLegsExercisesState extends State<ManageLegsExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference legsCollection =
      FirebaseFirestore.instance.collection('legs_exercises');

  // Function to add exercise to Firestore
  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await legsCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both fields."), backgroundColor: Colors.red),
      );
    }
  }

  // Function to delete exercise from Firestore
  void deleteExercise(String docId) async {
    await legsCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Legs Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          // Fetch and display exercises from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: legsCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Manage Shoulder workouts
class ManageShouldersExercises extends StatefulWidget {
  @override
  _ManageShouldersExercisesState createState() =>
      _ManageShouldersExercisesState();
}

class _ManageShouldersExercisesState extends State<ManageShouldersExercises> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final CollectionReference shouldersCollection =
      FirebaseFirestore.instance.collection('shoulders_exercises');

  // Function to add exercise to Firestore
  void addExercise() async {
    if (_nameController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await shouldersCollection.add({
        'name': _nameController.text,
        'description': _descController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exercise Added Successfully!"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _descController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in both fields."), backgroundColor: Colors.red),
      );
    }
  }

  // Function to delete exercise from Firestore
  void deleteExercise(String docId) async {
    await shouldersCollection.doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exercise Deleted!"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Manage Shoulders Exercises",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Exercise Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Exercise Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: addExercise,
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Add Exercise", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          // Fetch and display exercises from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: shouldersCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error loading exercises"));
              }

              List<DocumentSnapshot> exercises = snapshot.data!.docs;

              return ListView.builder(
                itemCount: exercises.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var exercise = exercises[index];
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue[50],
                    child: ListTile(
                      title: Text(
                        exercise["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                      ),
                      subtitle: Text(
                        exercise["description"],
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteExercise(exercise.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}