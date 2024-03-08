import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonWidth,
    required this.buttonHeight,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.onTap,
  });

  final String buttonText;
  final Color buttonColor;
  final double buttonHeight;
  final double buttonWidth;
  final Color textColor;
  final Color borderColor;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8.0.r),
          color: buttonColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
