import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonDesign extends StatelessWidget {
  final void Function() onTap;
  final String buttonText;
  final Color bgClr;

  const ButtonDesign(
      {super.key,
      required this.buttonText,
      required this.onTap,
      this.bgClr = Colors.black});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
            color: bgClr, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(buttonText,
                style: GoogleFonts.b612(
                    textStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)))),
      ),
    );
  }
}
