import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_gallery/designs/buttondesign.dart';
import 'package:cloud_gallery/designs/textfielddesigns.dart';
import 'package:cloud_gallery/designs/toast.dart';
import 'package:cloud_gallery/pages/BottomNav.dart';
import 'package:cloud_gallery/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  FirebaseAuth reg = FirebaseAuth.instance;
  FirebaseFirestore storeDetails = FirebaseFirestore.instance;

  firebaseReg(
      {required userEmail, required userPass, required userName}) async {
    try {
      UserCredential userData = await reg.createUserWithEmailAndPassword(
          email: userEmail, password: userPass);

      if (userData.user != null) {


        await storeDetails
            .collection("users")
            .doc(userData.user!.uid)
            .collection("details")
            .add({
          "name": nameCtrl.text,
          "email": emailCtrl.text,
          'dp':
              "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjHnSRXPSLrljeRy0jZvZM6mlJhbrleSFpvqBr3XQofZatDL5r0sUjxgN9N4vKpifLTds1vWlmsTt-XeN1wbIo7Kj0qSLbfeScRd5IFbel1NewpL1bX09nj9JZ3NcGLaGDtabL5VwUwfZzPca_9b_bQoxOkH3xKlB0Cg5u6PN5zHRSIJBYDmWvRHRuhNmQ/s1600/user%20%282%29.png"
        });

        myToastMessage(message: "Successfully Registered", bgClr: Colors.green);

        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return BottomHome();
          }));
        });
      }
    } on FirebaseAuthException catch (error) {


      if (error.code == "email-already-in-use") {
        myToastMessage(message: "Email already registered", bgClr: Colors.red);
      }

      if (error.code == "weak-password") {
        myToastMessage(
            message: "Password should be at least 6 characters",
            bgClr: Colors.red);
      }
      if (error.code == "invalid-email") {
        myToastMessage(
            message: "please check your email address", bgClr: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cloud Gallery",
                style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blue)),
              ),
              const Image(height: 150, image: AssetImage("assets/icon.png")),
              const SizedBox(
                height: 20,
              ),
              TextFieldDesign(
                  hintText: "Enter Your Name", controller: nameCtrl),
              const SizedBox(height: 10),
              TextFieldDesign(
                hintText: "Enter Your Email",
                controller: emailCtrl,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFieldDesign(
                hintText: "Enter Your Password",
                controller: passCtrl,
                inputType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonDesign(
                buttonText: "Create Account",
                onTap: () {
                  if (nameCtrl.text.isEmpty ||
                      emailCtrl.text.isEmpty ||
                      passCtrl.text.isEmpty) {
                    myToastMessage(message: "Please fill all fields");
                  } else {
                    firebaseReg(
                        userEmail: emailCtrl.text,
                        userPass: passCtrl.text,
                        userName: nameCtrl.text);
                  }
                },
                bgClr: Colors.blue,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account..??",
                    style: GoogleFonts.oswald(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      child: Text(
                        " Login now ",
                        style: GoogleFonts.oswald(
                            textStyle: const TextStyle(color: Colors.blue)),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
