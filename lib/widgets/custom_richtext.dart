import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/screens/company_registration.dart';
import 'package:outsourcepro/screens/login_screen.dart';
import 'package:outsourcepro/screens/freelancer_registration.dart';

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
          ..onTap = () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen(
                        loginType: LoginType.freelancer,
                      )));
      } else if (currentScreen == 'signupcompany') {
        return TapGestureRecognizer()
          ..onTap = () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen(
                        loginType: LoginType.company,
                      )));
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
        style: kText2.copyWith(
          fontSize: 14.sp,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text2,
            recognizer: checkScreen(),
            style: kText2.copyWith(
              fontSize: 14.sp,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
