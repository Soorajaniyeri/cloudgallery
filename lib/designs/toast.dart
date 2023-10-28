import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

myToastMessage({required String message, Color bgClr = Colors.red}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgClr,
      textColor: Colors.white,
      fontSize: 16.0);
}
