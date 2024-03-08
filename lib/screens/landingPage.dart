import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/widgets/button.dart';
import 'package:outsourcepro/constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 175.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image(
                      height: 200.h,
                      width: 400.w,
                      fit: BoxFit.contain,
                      image: const AssetImage('assets/landingpage.png'),
                    ),
                  ),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'OutsourcePro',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 175.h,
              ),
              MyButton(
                  onTap: () {
                    Navigator.pushNamed(context, 'selection_screen');
                  },
                  buttonText: 'Get Started',
                  buttonColor: primaryColor,
                  buttonWidth: 300,
                  buttonHeight: 50)
            ],
          ),
        ),
      ),
    );
  }
}
