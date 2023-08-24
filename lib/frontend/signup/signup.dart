import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Screens/homeScreen.dart';
import '../../components/common_dropdown.dart';
import '../../components/common_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String day = "1";
  String month = "Jan";
  String year = "1995";
  String firstName = "";
  String surname = "";
  String email = "";
  String password = "";
  String selectedGender = "Male";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List dayList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    // Rest of the day options...
  ];

  List monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
    // Rest of the month options...
  ];

  List yearList = [
    "1995",
    "1996",
    "1997",
    "1998",
    "1999",
    "2000",
    "2001",
    "2002",
    "2003",
    "2004",
    "2005",
    "2006",
    "2007",
    "2008",
    "2009",
    "2010",
    "2011",
    "2012",
    "2013",
    "2014",
    "2015",
    "2016",
    "2017",
    // Rest of the year options...
  ];

  Future<void> signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'surname': surname,
        'email': email,
        'password':password,
        'dob': '$day $month $year',
        'gender': selectedGender,
      });

    } catch (e) {
      print('Error signing up: $e');
    }
    Fluttertoast.showToast(
        msg: 'Account Created  Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:Color(0xFF0064e0),
        textColor: Colors.white,
        fontSize: 10.0);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF112724),
                Color(0xFF0e202e),
                Color(0xFF1c1e2b),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Broaxsaxfy",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.white30,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextfieldConst(
                          hintText: "First name",
                          padding: false,
                          obscureText: null,
                          onChanged: (value) {
                            setState(() {
                              firstName = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonTextfieldConst(
                          hintText: "Surname",
                          padding: false,
                          obscureText: null,
                          onChanged: (value) {
                            setState(() {
                              surname = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CommonTextfieldConst(
                    hintText: "Email Address",
                    padding: false,
                    obscureText: null,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  CommonTextfieldConst(
                    hintText: "New Password",
                    padding: false,
                    obscureText: null,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Date of birth",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CommonDropdownButton(
                          items: dayList,
                          hintText: day,
                          onSaved: (e) {},
                          onChange: (v) {
                            setState(() {
                              day = v;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonDropdownButton(
                          hintText: month,
                          items: monthList,
                          onSaved: (e) {},
                          onChange: (v) {
                            setState(() {
                              month = v;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonDropdownButton(
                          hintText: year,
                          items: yearList,
                          onSaved: (e) {},
                          onChange: (v) {
                            setState(() {
                              year = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Gender",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CommonBulletConst(
                          label: "Male",
                          showBullet: selectedGender == "Male",
                          onTap: () {
                            setState(() {
                              selectedGender = "Male";
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonBulletConst(
                          label: "Female",
                          showBullet: selectedGender == "Female",
                          onTap: () {
                            setState(() {
                              selectedGender = "Female";
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CommonBulletConst(
                          label: "Custom",
                          showBullet: selectedGender == "Custom",
                          onTap: () {
                            setState(() {
                              selectedGender = "Custom";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "People who use our service may have uploaded your contact information to Broaxsaxfy. Learn more.",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "By clicking signup you agree our Terms, Privacy Policy and Broaxsaxfy Policy. You may receive SMS notification from us and cannot opt out at any time",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: signUpWithEmailAndPassword,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: const Color(0xFF0064e0),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommonBulletConst extends StatelessWidget {
  String label;
  bool showBullet;
  VoidCallback onTap;
  CommonBulletConst({
    required this.label,
    required this.showBullet,
    required this.onTap,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1c2a33),
          border: Border.all(
            width: 0.0,
            color: const Color(0xFF495967),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: const Color(0xFF495967),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor:
                  showBullet ? const Color(0xFF0064e0) : const Color(0xFF1c2a33),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
