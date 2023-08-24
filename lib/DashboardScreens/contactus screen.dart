import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Owner {
  final String name;
  final String email;
  final String address;
  final String city;

  Owner({
    required this.name,
    required this.email,
    required this.address,
    required this.city,
  });
}

class OwnerDetail extends StatefulWidget {
  const OwnerDetail({Key? key}) : super(key: key);

  @override
  State<OwnerDetail> createState() => _OwnerDetailState();
}

class _OwnerDetailState extends State<OwnerDetail> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _address;
  String? _city;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save the data to Firebase Firestore
      FirebaseFirestore.instance.collection('owners').add({
        'name': _name,
        'email': _email,
        'address': _address,
        'city': _city,
      }).then((value) {
        // Data saved successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Owner details saved to Firebase!')),
        );
      }).catchError((error) {
        // Handle any errors that occurred while saving data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Owner Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  // You can add more advanced email validation if needed
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value;
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('owners').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final owners = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Owner(
                        name: data['name'],
                        email: data['email'],
                        address: data['address'],
                        city: data['city'],
                      );
                    }).toList();

                    return ListView.builder(
                      itemCount: owners.length,
                      itemBuilder: (context, index) {
                        final owner = owners[index];
                        return ListTile(
                          title: Text(owner.name),
                          subtitle: Text(owner.email),
                          // Display other details as needed
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
