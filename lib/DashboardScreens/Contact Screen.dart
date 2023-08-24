import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animations/animations.dart';

class BroaxsaxfyContactScreen extends StatefulWidget {
  const BroaxsaxfyContactScreen({Key? key}) : super(key: key);

  @override
  State<BroaxsaxfyContactScreen> createState() => _BroaxsaxfyContactScreenState();
}

class _BroaxsaxfyContactScreenState extends State<BroaxsaxfyContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Fetch contact details from Firestore
  Future<List<Map<String, dynamic>>> _getContactDetails() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('contacts').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for adding new contact details
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            ElevatedButton(
              onPressed: () => _saveContactDetails(),
              child: Text('Save Contact Details'),
            ),

            SizedBox(height: 16),

            // Display the list of contact details with animations
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getContactDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return _buildAnimatedContactList(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save contact details to Firestore
  void _saveContactDetails() {
    String contactName = _nameController.text;
    String phoneNumber = _phoneController.text;
    String emailAddress = _emailController.text;

    // Firestore collection reference for 'contacts'
    CollectionReference contactsCollection =
    FirebaseFirestore.instance.collection('contacts');

    // Create a document with a unique ID
    contactsCollection
        .add({
      'name': contactName,
      'phone': phoneNumber,
      'email': emailAddress,
    })
        .then((value) {
      // Contact details successfully stored in Firestore
      print('Contact details saved: $value');
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
    })
        .catchError((error) {
      // Error occurred while saving contact details
      print('Error saving contact details: $error');
    });
  }

  // Function to build the ListView.builder with contact details and animations
  Widget _buildAnimatedContactList(List<Map<String, dynamic>> contacts) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return OpenContainer(
          transitionType: ContainerTransitionType.fade,
          closedElevation: 0,
          openElevation: 4,
          openColor: Colors.white,
          closedColor: Colors.transparent,
          closedBuilder: (context, action) => _buildContactCard(contact),
          openBuilder: (context, action) => _buildContactDetails(contact),
        );
      },
    );
  }

  // Function to build the contact card for ListView.builder
  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          contact['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              contact['phone'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              contact['email'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the contact details page with animations
  Widget _buildContactDetails(Map<String, dynamic> contact) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${contact['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Phone Number: ${contact['phone']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email Address: ${contact['email']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
