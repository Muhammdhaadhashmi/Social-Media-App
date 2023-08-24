import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


// Sample model class representing the favorite items
class FavoriteItem {
  final String title;
  final String description;
  final String imageUrl;

  FavoriteItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class FavItems extends StatefulWidget {
  const FavItems({Key? key}) : super(key: key);

  @override
  State<FavItems> createState() => _FavItemsState();
}

class _FavItemsState extends State<FavItems> {
  final List<FavoriteItem> favoriteItems = [];
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitItem() async {
    if (_selectedImage == null) {
      // If no image is selected, show an error or prevent submission
      return;
    }

    try {
      // Upload the image to Firebase Storage
      final String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReference = FirebaseStorage.instance.ref().child('images/$imageFileName.jpg');
      final UploadTask uploadTask = storageReference.putFile(_selectedImage!);
      await uploadTask.whenComplete(() {});

      // Get the image URL after uploading
      final imageUrl = await storageReference.getDownloadURL();

      // Create a new document in Firestore with item details
      await FirebaseFirestore.instance.collection('favorite_items').add({
        'title': favoriteItems.last.title, // Replace this with your item title
        'description': favoriteItems.last.description, // Replace this with your item description
        'imageUrl': imageUrl,
      });

      // Show a success message or navigate to another screen
      print('Item added to Firestore with image URL: $imageUrl');
    } catch (error) {
      // Handle any errors that occurred during the upload or Firestore write process
      print('Error uploading image and writing data to Firestore: $error');
    }
  }

  Future<void> _deleteItem(String documentId) async {
    try {
      // Delete the document from Firestore using its document ID
      await FirebaseFirestore.instance.collection('favorite_items').doc(documentId).delete();
      // Show a success message or update the UI
      print('Item deleted from Firestore successfully');
    } catch (error) {
      // Handle any errors that occurred during the delete process
      print('Error deleting item from Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Items'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('favorite_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final documents = snapshot.data?.docs;
          favoriteItems.clear();
          if (documents != null) {
            for (var doc in documents) {
              final data = doc.data();
              final favoriteItem = FavoriteItem(
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                imageUrl: data['imageUrl'] ?? '',
              );
              favoriteItems.add(favoriteItem);
            }
          }

          if (favoriteItems.isEmpty) {
            return Center(
              child: Text('No favorite items yet.'),
            );
          }

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              final item = favoriteItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : NetworkImage(item.imageUrl) as ImageProvider<Object>?,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(item.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: _pickImage,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteItem(documents![index].id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
