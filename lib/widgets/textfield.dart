import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTf extends StatelessWidget {
  const CustomTf({
    super.key,
    required this.hintText,
    this.obsText,
  });

  final String hintText;
  final bool? obsText;

  @override
  Widget build(BuildContext Scontext) {
    bool checkObscure() {
      if (obsText == true) {
        return true;
      } else {
        return false;
      }
    }

    return SizedBox(
      width: 350,
      height: 50,
      child: TextField(
        obscureText: checkObscure(),
        // decoration: kTextFieldDecoration.copyWith(hintText: hintText),
      ),
    );
  }
}
