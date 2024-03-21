import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SnackBar customSnackBar(String snackBarText, Color color) {
  return SnackBar(
    content: Center(
      child: Text(
        snackBarText,
        style: TextStyle(
            color: Colors.white, fontSize: 14.sp), // Customize text style
      ),
    ),
    backgroundColor: color, // Change background color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Add rounded corners
    ),
    behavior: SnackBarBehavior.floating, // Make it floating
    duration: const Duration(seconds: 3),
  );
}
