import 'dart:async';

import 'package:cloud_gallery/pages/BottomNav.dart';
import 'package:cloud_gallery/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    if (auth.currentUser != null) {
      Timer(Duration(seconds: 4), () async {
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return BottomHome();
        }));
      });
    } else {
      Timer(Duration(seconds: 4), () async {
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          Center(
            child: Image(height: 150, image: AssetImage("assets/icon.png")),
          ),
          Expanded(child: SizedBox()),
          Text(
            "Cloud Gallery",
            style: GoogleFonts.oswald(
                textStyle: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }
}
