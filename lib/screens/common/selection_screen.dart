import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outsourcepro/constants.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Column(
              children: [
                Text(
                  "Continue As?",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
                Text(
                  "Select a Category",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
            SizedBox(
              height: 75.h,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'freelancer_login_screen');
                  },
                  child: Container(
                    width: 250.w,
                    height: 150.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor, // Set your desired color
                        width: 1.0.h, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Image(
                            height: 75.h,
                            fit: BoxFit.contain,
                            image:
                                const AssetImage('assets/freelancerlogin.png'),
                          ),
                        ),
                        Text(
                          "Freelancer",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'company_login_screen');
                  },
                  child: Container(
                    width: 250.w,
                    height: 150.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor, // Set your desired color
                        width: 1.0.h, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Image(
                            height: 75.h,
                            fit: BoxFit.contain,
                            image: const AssetImage('assets/companylogin.png'),
                          ),
                        ),
                        Text(
                          "Company",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
