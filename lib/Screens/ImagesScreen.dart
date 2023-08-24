import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beautiful Images',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Customize the app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the widgets
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : Image.asset(
                    'asset/userprof.png', // Replace with your placeholder image asset
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectImage(ImageSource.gallery),
                    icon: Icon(Icons.photo),
                    label: Text('Gallery'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                    _imageFile != null ? _uploadImageToFirebase : null,
                    icon: Icon(Icons.cloud_upload),
                    label: Text('Upload'),
                  ),
                ],
              ),
              SizedBox(height: 16), // Add some spacing between the buttons and the GridView
              Expanded(child: _buildImageListView()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile == null) return;

    // Initialize Firebase (if not already initialized)
    await Firebase.initializeApp();

    try {
      // Upload the image to Firebase Storage
      final storage = FirebaseStorage.instance;
      final fileName = DateTime.now().toString();
      final Reference reference = storage.ref().child('images/$fileName');
      final UploadTask uploadTask = reference.putFile(_imageFile!);
      final TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL for the uploaded image
      final imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Save the image URL to the Firebase database in the 'images' collection
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('images').add({
        'url': imageUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      // Show a success message or perform any other actions
      print('Image uploaded successfully!');
    } catch (e) {
      // Handle errors, if any
      print('Error uploading image: $e');
    }
  }

  Future<void> _deleteImage(String docId, String imageUrl) async {
    // Delete the image data from Firebase Storage
    final storage = FirebaseStorage.instance;
    try {
      await storage.refFromURL(imageUrl).delete();
      print('Image deleted from Firebase Storage');
    } catch (e) {
      print('Error deleting image from Firebase Storage: $e');
    }

    // Delete the image data from Firebase Firestore
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('images').doc(docId).delete();
      print('Image reference deleted from Firestore');
    } catch (e) {
      print('Error deleting image reference from Firestore: $e');
    }
  }

  Widget _buildImageListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('images').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final documents = snapshot.data!.docs;
        return _buildGridView(documents);
      },
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> documents) {
    final crossAxisCount = _getCrossAxisCount(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final imageUrl = documents[index]['url'] as String;
        final docId = documents[index].id; // Get the document ID from the snapshot

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => _deleteImage(docId, imageUrl),
              ),
            ),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 3;
    } else if (screenWidth > 400) {
      return 2;
    } else {
      return 1;
    }
  }
}
