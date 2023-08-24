import 'dart:async';
import 'package:flutter/material.dart';
import 'Utils/app_colors.dart';
import 'frontend/login/login.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 10), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          "asset/logo.png",
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
