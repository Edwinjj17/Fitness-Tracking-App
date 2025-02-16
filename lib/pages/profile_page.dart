import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;
  Map<String, dynamic>? userDetails;
  String? imageUrl;
  bool isLoading = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() => isLoading = true);
    try {
      user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user!.uid).get();

        if (userDoc.exists) {
          setState(() {
            userDetails = userDoc.data() as Map<String, dynamic>?;
            phoneController.text = userDetails?['phone'] ?? '';
            locationController.text = userDetails?['location'] ?? '';
            birthdayController.text = userDetails?['birthday'] ?? '';
            imageUrl = userDetails?['profileImage'];
          });
        }
      }
    } catch (e) {
      showCustomSnackBar('Error fetching user data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() => isLoading = true);

      // Create file from picked image
      File imageFile = File(pickedFile.path);
      String fileName = 'profile_${user!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String path = 'profile_pictures/$fileName';

      // Upload to Firebase Storage
      TaskSnapshot snapshot = await _storage.ref(path).putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await _firestore.collection('users').doc(user!.uid).update({
        'profileImage': downloadUrl,
      });

      setState(() {
        imageUrl = downloadUrl;
        isLoading = false;
      });

      showCustomSnackBar('Profile picture updated successfully!');
    } catch (e) {
      setState(() => isLoading = false);
      showCustomSnackBar('Failed to upload image: $e');
    }
  }

  Future<void> updateUserData() async {
    setState(() => isLoading = true);
    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'phone': phoneController.text.trim(),
        'location': locationController.text.trim(),
        'birthday': birthdayController.text.trim(),
      });
      showCustomSnackBar('Profile updated successfully!');
    } catch (e) {
      showCustomSnackBar('Error updating profile: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blueAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isEditable) {
                updateUserData();
              }
              setState(() => isEditable = !isEditable);
            },
            icon: Icon(isEditable ? Icons.save : Icons.edit),
            tooltip: isEditable ? 'Save Changes' : 'Edit Profile',
          ),
        ],
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue[600],
            height: 100,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  _buildBody(),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildProfileAvatar(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60, // Reduced from 75
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 120, // Reduced from 150
                      height: 120, // Reduced from 150
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Colors.grey[400],
                    ),
            ),
          ),
        ),
        if (isEditable)
          Positioned(
            bottom: 0,
            right: 0,
            child: Material(
              elevation: 4,
              shape: CircleBorder(),
              child: InkWell(
                onTap: pickAndUploadImage,
                customBorder: CircleBorder(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (userDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          _buildInfoCard(),
          SizedBox(height: 16),
          _buildEditableFields(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Name', userDetails?['name'] ?? 'N/A', Icons.person),
            Divider(),
            _buildInfoRow('Email', userDetails?['email'] ?? 'N/A', Icons.email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFields() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEditableField('Phone', phoneController, Icons.phone),
            SizedBox(height: 16),
            _buildEditableField('Location', locationController, Icons.location_on),
            SizedBox(height: 16),
            _buildEditableField('Birthday', birthdayController, Icons.cake),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      enabled: isEditable,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[600]!),
        ),
        filled: true,
        fillColor: isEditable ? Colors.white : Colors.grey[100],
      ),
    );
  }
}