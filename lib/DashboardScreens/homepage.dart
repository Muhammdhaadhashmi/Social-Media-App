import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController postContentController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('post_images')
        .child(fileName);

    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Post'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: postContentController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Post Content'),
                ),
                _image != null
                    ? Image.file(_image!) // Display the selected image
                    : Container(),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Select Image'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _createPost();
                Navigator.of(context).pop();
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _createPost() async {
    String username = usernameController.text;
    String postContent = postContentController.text;

    String? imageUrl;
    if (_image != null) {
      // Upload image to Firebase Storage
      imageUrl = await _uploadImage(_image!);
    }

    firestore.collection('posts').add({
      'username': username,
      'postContent': postContent,
      'imageUrl': imageUrl, // Store the image URL in the Firestore document
      'likes': 0,
      'comments': 0,
    }).then((value) {
      print('Post created successfully!');
    }).catchError((error) {
      print('Error creating post: $error');
    });
  }

  void _likePost(DocumentReference postRef) {
    int currentLikes = 0;
    postRef.get().then((postSnapshot) {
      if (postSnapshot.exists) {
        currentLikes = postSnapshot['likes'];
      }
      postRef.update({'likes': currentLikes + 1}).then((value) {
        print('Post liked successfully!');
      }).catchError((error) {
        print('Error liking post: $error');
      });
    });
  }

  void _showCommentDialog(BuildContext context, DocumentReference postRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController commentController = TextEditingController();
        return AlertDialog(
          title: Text('Add Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Write your comment'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String comment = commentController.text;
                _addComment(postRef, comment);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _addComment(DocumentReference postRef, String comment) {
    int currentComments = 0;
    postRef.get().then((postSnapshot) {
      if (postSnapshot.exists) {
        currentComments = postSnapshot['comments'];
      }
      postRef.update({'comments': currentComments + 1}).then((value) {
        firestore.collection('comments').add({
          'postId': postRef.id,
          'comment': comment,
        }).then((commentDoc) {
          print('Comment posted successfully!');
        }).catchError((error) {
          print('Error posting comment: $error');
        });
      }).catchError((error) {
        print('Error adding comment: $error');
      });
    });
  }

  void _sharePost(String postContent) {
    // Use the share plugin to share the post content
    Share.share(postContent);
    // You can also implement custom logic for sharing, e.g., sharing a link to the post or using other sharing methods.
    print('Post shared successfully!');
  }

  void _deletePost(DocumentReference postRef) async {
    try {
      // Delete the post document from Firestore
      await postRef.delete();
      // Optionally, you can delete the associated image from Firebase Storage as well
      print('Post deleted successfully!');
    } catch (error) {
      print('Error deleting post: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Broaxsaxfy HomePage"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> posts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> post = posts[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        post['postContent'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty) ...[
                        SizedBox(height: 8.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            post['imageUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () => _likePost(posts[index].reference),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '${post['likes']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 16.0),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () => _showCommentDialog(context, posts[index].reference),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '${post['comments']}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 16.0),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () => _sharePost(post['postContent']),
                          ),
                          SizedBox(width: 16.0),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deletePost(posts[index].reference),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
