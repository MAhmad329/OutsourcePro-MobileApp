import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.buttonText, // Make this nullable
    required this.buttonColor,
    required this.buttonWidth,
    required this.buttonHeight,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderRadius = 8.0,
    this.onTap,
    this.child,
    // Add this line
  });

  final String? buttonText; // Make this nullable
  final Color buttonColor;
  final double buttonHeight;
  final double buttonWidth;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final Function()? onTap;
  final Widget? child; // Add this line

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2.w),
          borderRadius: BorderRadius.circular(borderRadius.r),
          color: buttonColor,
        ),
        child: Center(
          // Change this to Center
          child: child ??
              Text(
                // Use child if provided, otherwise use buttonText
                buttonText ?? '', // Use empty string if buttonText is null
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
        ),
      ),
    );
  }
}
