import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_gallery/pages/Profile.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'galleryview.dart';

class BottomHome extends StatefulWidget {
  const BottomHome({
    super.key,
  });

  @override
  State<BottomHome> createState() => _BottomHomeState();
}

class _BottomHomeState extends State<BottomHome> {
  FirebaseFirestore load = FirebaseFirestore.instance;

  int myIndex = 0;

  List<Widget> myList = [GalleryViewPage(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //
      // }),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Cloud Gallery',
          style: GoogleFonts.oswald(textStyle: const TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: myIndex,
          onTap: (value) {
            setState(() {
              myIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle,
                ),
                label: "Profile")
          ]),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     // StreamBuilder(
      //     //     stream: load
      //     //         .collection("users")
      //     //         .doc(widget.userId)
      //     //         .collection("details")
      //     //         .snapshots(),
      //     //     builder: (context, snapshot) {
      //     //       if (snapshot.hasData) {
      //     //         return Center(child: Text(snapshot.data!.docs[0]["email"]));
      //     //       } else {
      //     //         return SizedBox();
      //     //       }
      //     //     })
      //   ],
      // ),

      body: myList[myIndex],
    );
  }
}
