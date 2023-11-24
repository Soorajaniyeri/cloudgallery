import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GalleryItemView extends StatefulWidget {
  final int uid;
  const GalleryItemView({super.key, required this.uid});

  @override
  State<GalleryItemView> createState() => _GalleryItemViewState();
}

class _GalleryItemViewState extends State<GalleryItemView> {
  CollectionReference imageView = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("storage");

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Scaffold(
      body: StreamBuilder(
        stream: imageView.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Image(
                    image: NetworkImage(snapshot.data!.docs[widget.uid]['image'])),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
