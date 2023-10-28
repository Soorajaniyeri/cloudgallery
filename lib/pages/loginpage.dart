
import 'package:cloud_gallery/pages/BottomNav.dart';
import 'package:cloud_gallery/pages/registrationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../designs/buttondesign.dart';
import '../designs/textfielddesigns.dart';
import '../designs/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  FirebaseAuth login = FirebaseAuth.instance;

  firebaseLogin({required userEmail, required userPassword}) async {
    try {
      UserCredential userData = await login.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);

      if (userData.user != null) {

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return BottomHome();
        }));
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "INVALID_LOGIN_CREDENTIALS") {
        myToastMessage(message: "Invalid Login Details");
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



              Text("Cloud Gallery",style: GoogleFonts.oswald(textStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.blue)),),


              const SizedBox(
                height: 20,
              ),



              const Image(height: 150, image: AssetImage("assets/icon.png")),
              const SizedBox(
                height: 20,
              ),
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
                buttonText: "Login",
                onTap: () {
                  if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
                    myToastMessage(message: "Please fill all fields");
                  } else {
                    firebaseLogin(
                      userEmail: emailCtrl.text,
                      userPassword: passCtrl.text,
                    );
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
                    "Don't have an account..??",
                    style: GoogleFonts.oswald(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Registration();
                        }));
                      },
                      child: Text(
                        " Register now ",
                        style: GoogleFonts.oswald(
                            textStyle: const TextStyle(color: Colors.blue)),
                      )),


                  
                  



                ],
              ),


              const SizedBox(

                height: 30,
              ),



            ],
          ),
        ),
      ),
    );
  }
}
