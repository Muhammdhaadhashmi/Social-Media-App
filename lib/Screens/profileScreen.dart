import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData() async {
    String userId = "user_id"; // Replace with the user's ID from authentication.
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'asset/cover.jpeg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('asset/userprof.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Retrieve and display user details from Firebase
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                    'Error loading user data',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  final userData = snapshot.data?.data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?['name'] ?? 'Bilal',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        userData?['jobTitle'] ?? 'Housekeeping Supervisor',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(userData?['email'] ?? 'Broaxsaxfy@gmail.com'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(userData?['location'] ?? 'Pakistan, KPK'),
                      ),
                      Divider(height: 32, color: Colors.grey),
                      _buildPostList(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveUserProfile,
        child: Icon(Icons.save),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void saveUserProfile() async {
    try {
      String userId = "user_id"; // Replace with the user's ID from authentication.
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text,
        'jobTitle': _jobTitleController.text,
        'email': _emailController.text,
        'location': _locationController.text,
      });
      _nameController.clear();
      _jobTitleController.clear();
      _emailController.clear();
      _locationController.clear();
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  Widget _buildPostList() {
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: 5, // Replace with the actual number of posts
        itemBuilder: (context, index) {
          return _buildPost('Post $index content');
        },
      ),
    );
  }

  Widget _buildPost(String content) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('asset/userprof.png'),
        ),
        title: Text('Broaxsaxfy'), // Replace with the post author's name
        subtitle: Text(content),
        // Add more post details here, like timestamp, likes, comments, etc.
      ),
    );
  }
}
