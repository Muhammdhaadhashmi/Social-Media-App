import 'package:broaxsaxfy/Screens/profileScreen.dart';
import 'package:broaxsaxfy/Screens/searchScreen.dart';
import 'package:broaxsaxfy/Screens/videos%20Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../DashboardScreens/BroaxsaxfySettings.dart';
import '../DashboardScreens/Contact Screen.dart';
import '../DashboardScreens/Favitems.dart';
import '../DashboardScreens/Sound_Making.dart';
import '../DashboardScreens/contactus screen.dart';
import '../DashboardScreens/homepage.dart';
import '../Utils/app_colors.dart';
import '../frontend/login/login.dart';
import 'ImagesScreen.dart';
import 'UserDetails.dart';
import 'chartScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:  Color(0xFF0064e0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UsersList()),
          );
        },
        child: Icon(
          Icons.list_sharp,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color:  AppColors.appbar,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()),
                        );
                      },
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideosScreen()),
                        );
                      },
                      child: Icon(
                        Icons.video_collection_sharp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Videos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // BudgetCalculatorPage
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImagesScreen()),
                        );
                      },
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' Images',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0,right: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessagesScreen()),
                        );
                      },
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Messages',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0,right: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()),
                        );
                      },
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
          )
        ],
        title: Text('Broaxsaxfy'.toUpperCase(),style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.appbar,
        elevation: 5.5,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.appbar,),
              accountEmail: Text("broaxsaxfy@gmail.com"),
              accountName:Text("Broaxsaxfy"),
              // accountEmail: Text(widget.email.toString()),
              currentAccountPicture: CircleAvatar(
                backgroundColor:Color(0xFF0064e0),
                foregroundImage: AssetImage('asset/image.png',),
              ),

            ),
            ListTile(
              leading: Icon(
                Icons.contact_phone,
              ),
              title: Text('Broaxsaxfy Contacts'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => BroaxsaxfyContactScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
              ),
              title: Text('Broaxsaxfy Favourite'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavItems()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.music_note,
              ),
              title: Text('Sound Making'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SoundMaking()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.keyboard_voice_rounded,
              ),
              title: Text('Voice Changer'),
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => VoiceChanger()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text('Broaxsaxfy Settings'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.phone_android,
              ),
              title: Text('Broaxsaxfy Contact Us'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OwnerDetail()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.rate_review,
              ),
              title: Text('Broaxsaxfy Rate Us'),
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => RatingScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPage()));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: Text(
                'Broaxsaxfy',
                style: TextStyle(
                    color: Color(0xFF0064e0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      body: Center(
        // Centered Text Widget
        child: Text(
          'Welcome to Broaxsaxfy!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color:Color(0xFF0064e0),
          ),
        ),
      ),
    );
  }
}
