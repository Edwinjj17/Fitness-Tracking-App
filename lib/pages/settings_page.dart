import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage
import 'profile_page.dart'; // Import the ProfilePage
// import 'privacy_policy.dart'; // Import the PrivacyPolicyPage

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Account Management Section
            _buildSectionTitle("Account"),

            // Manage Account
            _buildSettingsTile(
              title: "Your Profile",
              leadingIcon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
                );
              },
            ),

            const SizedBox(height: 20), // Space between tiles

            // Privacy Policy
            _buildSettingsTile(
              title: "Privacy Policy",
              leadingIcon: Icons.privacy_tip,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()), // Navigate to PrivacyPolicyPage
                );
              },
            ),

            const SizedBox(height: 20), // Space between tiles

            // Logout Button
            _buildSettingsTile(
              title: "Logout",
              leadingIcon: Icons.logout,
              iconColor: Colors.red,
              onTap: () async {
                _showLogoutConfirmation(context);
              },
            ),

            const SizedBox(height: 40), // Footer section

            // App Version
            Center(
              child: Text(
                "App Version 1.0.0",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build section titles with style
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Helper function to build each settings tile with rounded corners and elevation
  Widget _buildSettingsTile({
    required String title,
    required IconData leadingIcon,
    VoidCallback? onTap,
    Color iconColor = Colors.blueAccent,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(leadingIcon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                try {
                  await FirebaseAuth.instance.signOut(); // Sign out the user
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to LoginPage
                    (route) => false, // Remove all previous routes
                  );
                } catch (e) {
                  print("Error logging out: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logout failed: ${e.toString()}")),
                  );
                }
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
