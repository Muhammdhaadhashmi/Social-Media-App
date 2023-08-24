import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  Future<void> _pickVideoFromGallery() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadVideoToFirebase(File(pickedFile.path));
    }
  }

  Future<void> _captureVideoFromCamera() async {
    final XFile? capturedFile = await _picker.pickVideo(source: ImageSource.camera);

    if (capturedFile != null) {
      await _uploadVideoToFirebase(File(capturedFile.path));
    }
  }

  Future<void> _uploadVideoToFirebase(File videoFile) async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    final Reference storageRef = storage.ref().child('videos/${DateTime.now()}.mp4');
    final UploadTask uploadTask = storageRef.putFile(videoFile);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

    if (snapshot.state == TaskState.success) {
      final String downloadURL = await storageRef.getDownloadURL();

      // Save the video URL in the Firebase Database.
      final CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');
      await videosCollection.add({'url': downloadURL});
    }
  }

  Widget _buildVideoList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('videos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final videoDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: videoDocs.length,
            itemBuilder: (context, index) {
              final videoUrl = videoDocs[index]['url'];
              final documentId = videoDocs[index].id; // Document ID from Firestore
              return VideoListItem(videoUrl: videoUrl, documentId: documentId);
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error fetching videos');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos Screen'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickVideoFromGallery,
              child: Text(
                'Pick Video from Gallery',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureVideoFromCamera,
              child: Text(
                'Capture Video from Camera',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildVideoList(),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoListItem extends StatefulWidget {
  final String videoUrl;
  final String documentId; // Add the document ID of the video in Firestore.

  const VideoListItem({required this.videoUrl, required this.documentId});

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _controller.play();
                      });
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      size: 24,
                    ),
                    label: Text(
                      'Play',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _controller.pause();
                      });
                    },
                    icon: Icon(
                      Icons.stop,
                      size: 24,
                    ),
                    label: Text(
                      'Stop',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmationDialog();
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 24,
                    ),
                    label: Text(
                      'Delete',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Video Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Video Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this video?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteVideo();
                Navigator.of(context).pop(); // Close the dialog.
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVideo() async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      // Delete video from Firebase Storage.
      final Reference storageRef = storage.refFromURL(widget.videoUrl);
      await storageRef.delete();

      // Delete video from Firestore.
      final CollectionReference videosCollection = FirebaseFirestore.instance.collection('videos');
      await videosCollection.doc(widget.documentId).delete();
    } catch (e) {
      // Handle any errors that occur during deletion.
      print('Error deleting video: $e');
    }
  }
}
