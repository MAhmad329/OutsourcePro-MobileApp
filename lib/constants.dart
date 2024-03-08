import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color primaryColor = const Color(0xFF7A43B9);

TextStyle kBasicText = TextStyle(
    color: Colors.grey.shade600, fontSize: 12.sp, fontFamily: 'Poppins');

TextStyle kHeading = TextStyle(
    fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 15.sp);
TextStyle kSubheading =
    TextStyle(fontSize: 10.sp, color: Colors.black38, fontFamily: 'Poppins');

TextStyle kText1 = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w600,
  fontSize: 20.sp,
  fontFamily: 'Poppins',
);

TextStyle kText2 = TextStyle(
  color: Colors.grey.shade600,
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
  fontFamily: 'Poppins',
);

TextStyle kText3 = TextStyle(
  color: const Color(0xff323232),
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
  fontSize: 18.sp,
);

InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: 'hint text',
  filled: true,
  fillColor: Color.fromRGBO(152, 126, 255, 0.10),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0.h, horizontal: 16.0.w),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 1.0.w),
    borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0.w),
    borderRadius: BorderRadius.all(Radius.circular(10.0.r)),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2,
      color: Colors.red,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.r)),
    borderSide: BorderSide(
      width: 2,
      color: Colors.red,
    ),
  ),
);

InputDecoration kPostTextFieldDecoration = InputDecoration(
  alignLabelWithHint: true,
  hintText: 'Write something about yourself...',
  hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
  filled: true,
  fillColor: const Color(0xFFF5F5F5),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
  ),
);
