import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_gallery/designs/buttondesign.dart';
import 'package:cloud_gallery/designs/textfielddesigns.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  final String docId;
  final String imgUrl;
  final String name;
  const UpdateProfile(
      {super.key,
      required this.docId,
      required this.name,
      required this.imgUrl});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameCtrl = TextEditingController();
  ImagePicker picker = ImagePicker();
  FirebaseStorage Profile = FirebaseStorage.instance;
  FirebaseFirestore storeImage = FirebaseFirestore.instance;
  FirebaseAuth fetch = FirebaseAuth.instance;

  File? selectedImg;
  var imgUrl;

  uploadImage({required docid}) async {
    XFile? store = await picker.pickImage(source: ImageSource.gallery);
    if (store != null) {
      setState(() {
        selectedImg = File(store.path);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "PLease wait...",
                      style: GoogleFonts.oswald(textStyle: const TextStyle()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CircularProgressIndicator()
                  ],
                ),
              );
            });

        Reference ref = Profile.ref().child("images/${selectedImg!.path}");
        UploadTask task = ref.putFile(selectedImg!);

        task.whenComplete(() async {
          var downloadUrl = await ref.getDownloadURL();

          Navigator.pop(context);

          setState(() {
            imgUrl = downloadUrl;
          });
          print(downloadUrl);

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

  updateName() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(fetch.currentUser!.uid)
        .collection('details')
        .doc(widget.docId)
        .update({
      "name": nameCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    nameCtrl.text = widget.name;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Update Profile",
            style: GoogleFonts.oswald(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(children: [
              CircleAvatar(
                  radius: 60,
                  backgroundImage: imgUrl == null
                      ? NetworkImage(widget.imgUrl)
                      : NetworkImage(imgUrl)),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      // color: Colors.red,
                      onPressed: () {
                        uploadImage(docid: widget.docId);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            TextFieldDesign(hintText: "Enter Your name", controller: nameCtrl),
            const SizedBox(
              height: 10,
            ),
            ButtonDesign(
                buttonText: "Update Profile",
                onTap: () {
                  updateName();

                  Navigator.pop(context);
                })
          ],
        ));
  }
}
