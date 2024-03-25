import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';
import 'package:outsourcepro/widgets/button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        height: 200.h,
                        fit: BoxFit.contain,
                        image: const AssetImage('assets/landingpage.png'),
                      ),
                    ),
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      'OutsourcePro',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150.h,
                ),
                MyButton(
                    onTap: () {
                      Navigator.pushNamed(context, 'selection_screen');
                    },
                    buttonText: 'Get Started',
                    buttonColor: primaryColor,
                    buttonWidth: 260.w,
                    buttonHeight: 45.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
