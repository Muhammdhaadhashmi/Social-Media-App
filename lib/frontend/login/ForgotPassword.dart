import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/btn.dart';
import '../../Utils/dimensions.dart';
import '../../Utils/spaces.dart';
import '../../Utils/text_edit_field.dart';
import 'login.dart';



class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController controller=TextEditingController();
  bool emailvalidate = false;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddVerticalSpace(70),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Find Your Account on Broaxsaxfy",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white,),),
              ),
              AddVerticalSpace(30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Please enter your email address or mobile number to search for your account on Broaxsaxfy .",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:  Colors.white,),),
              ),
              AddVerticalSpace(20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextEditField(
                  hintText: "Email address",
                  cursorColor: Color(0xFF0064e0),
                  textCapitalization: TextCapitalization.none,
                  preffixIcon: Icon(Icons.email_outlined,color: Color(0xFF0064e0),),
                  textEditingController: controller,
                  errorText: emailvalidate ? "Email Requried" : null,
                  width: Dimensions.screenWidth(context),
                ),
              ),
              AddVerticalSpace(10),
              BTN(
                  width: Dimensions.screenWidth(context) - 100,
                  title: "Forgot Password",
                  textColor: AppColors.white,
                  color: Color(0xFF0064e0),
                  fontSize: 15,
                  onPressed: () async {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: controller.text).then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    );}
              ),
            ],
          ),
        ),
      ),
    );
  }
}