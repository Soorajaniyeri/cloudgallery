import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_gallery/designs/buttondesign.dart';
import 'package:cloud_gallery/pages/loginpage.dart';
import 'package:cloud_gallery/pages/splashscreen.dart';
import 'package:cloud_gallery/pages/updateprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseStorage Profile = FirebaseStorage.instance;
  FirebaseFirestore storeImage = FirebaseFirestore.instance;
  FirebaseAuth fetch = FirebaseAuth.instance;
  CollectionReference userInfo = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("details");

  ImagePicker picker = ImagePicker();
  File? selectedImg;

  logout() async {
    await fetch.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const SplashScreen();
    }));
  }

  uploadImage({required docid}) async {
    XFile? store = await picker.pickImage(source: ImageSource.gallery);
    if (store != null) {
      setState(() {
        selectedImg = File(store.path);

        Reference ref = Profile.ref().child("images/${selectedImg!.path}");
        UploadTask task = ref.putFile(selectedImg!);
        task.whenComplete(() async {
          var downloadUrl = await ref.getDownloadURL();

          storeImage
              .collection("users")
              .doc(fetch.currentUser!.uid)
              .collection("details")
              .doc(docid)
              .update({"dp": downloadUrl});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: userInfo.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data!.docs[0]['dp']),
                        radius: 60,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        snapshot.data!.docs[0]["name"],
                        style: GoogleFonts.oswald(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      Text(
                        snapshot.data!.docs[0]["email"],
                        style: GoogleFonts.oswald(
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ButtonDesign(
                          buttonText: "Update Profile",
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return UpdateProfile(
                                imgUrl: snapshot.data!.docs[0]['dp'],
                                docId: snapshot.data!.docs[0].id,
                                name: snapshot.data!.docs[0]['name'],
                              );
                            }));
                          },
                          bgClr: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ButtonDesign(
                          buttonText: "Logout",
                          onTap: () {
                            logout();
                          },
                          bgClr: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            })



    );
  }
}
