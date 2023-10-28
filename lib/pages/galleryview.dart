import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class GalleryViewPage extends StatefulWidget {
  const GalleryViewPage({super.key});

  @override
  State<GalleryViewPage> createState() => _GalleryViewPageState();
}

class _GalleryViewPageState extends State<GalleryViewPage> {
  FirebaseStorage addPhoto = FirebaseStorage.instance;
  FirebaseFirestore load = FirebaseFirestore.instance;
  FirebaseAuth fetch = FirebaseAuth.instance;
  ImagePicker picker = ImagePicker();
  File? selectedImg;

  firebaseDelete({required String doc}) async {
    await load
        .collection("users")
        .doc(fetch.currentUser!.uid)
        .collection("storage")
        .doc(doc)
        .delete();
  }

  uploadImage() async {
    XFile? store = await picker.pickImage(source: ImageSource.gallery);
    if (store != null) {
      setState(() {
        selectedImg = File(store.path);

        Reference ref = addPhoto.ref().child("images/${selectedImg!.path}");
        UploadTask task = ref.putFile(selectedImg!);
        task.whenComplete(() async {
          var downloadUrl = await ref.getDownloadURL();


          load
              .collection("users")
              .doc(fetch.currentUser!.uid)
              .collection("storage")
              .add({"image": downloadUrl});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              uploadImage();
            }),
        body: StreamBuilder(
            stream: load
                .collection("users")
                .doc(fetch.currentUser!.uid)
                .collection("storage")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Image(
                          height: 100, image: AssetImage("assets/icon.png")),
                    ),
                    Text(
                      "No image Found",
                      style: GoogleFonts.oswald(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    )
                  ],
                );
              }
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              // color: Colors.yellow,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data!.docs[index]["image"]))),
                          margin: const EdgeInsets.all(10),
                        ),
                        Positioned(
                          right: 10,
                          top: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: InkWell(
                              onTap: () {
                                firebaseDelete(
                                    doc: snapshot.data!.docs[index].id);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      ]);
                    });
              } else {
                return const SizedBox();
              }
            })

        // ),,
        );
  }
}
