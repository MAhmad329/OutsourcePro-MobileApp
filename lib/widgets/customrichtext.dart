import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/companyLogin.dart';
import 'package:outsourcepro/screens/companyRegistration.dart';
import 'package:outsourcepro/screens/freelancerLogin.dart';
import 'package:outsourcepro/screens/freelancerRegistration.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.text1,
    required this.text2,
    required this.clickable,
    this.currentScreen,
  });
  final String text1;
  final String text2;
  final String? currentScreen;
  final bool clickable;

  @override
  Widget build(BuildContext context) {
    TapGestureRecognizer checkScreen() {
      if (currentScreen == 'loginfreelancer') {
        return TapGestureRecognizer()
          ..onTap = () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const FreelancerRegistration()));
      } else if (currentScreen == 'signupfreelancer') {
        return TapGestureRecognizer()
          ..onTap = () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const FreelancerLogin()));
      } else if (currentScreen == 'signupcompany') {
        return TapGestureRecognizer()
          ..onTap = () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const CompanyLogin()));
      } else if (currentScreen == 'logincompany') {
        return TapGestureRecognizer()
          ..onTap = () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const CompanyRegistration()));
      } else {
        return TapGestureRecognizer();
      }
    }

    return RichText(
      text: TextSpan(
        text: text1,
        style: clickable
            ? kText2.copyWith(fontSize: 14.sp)
            : kText1.copyWith(fontSize: 20.sp),
        children: <TextSpan>[
          TextSpan(
              text: text2,
              recognizer: checkScreen(),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: clickable ? 16.sp : 20.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              )),
        ],
      ),
    );
  }
}
