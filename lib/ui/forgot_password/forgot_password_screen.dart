import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/forgot_password/forgot_password_screen_one.dart';
import 'package:quicklai/ui/forgot_password/forgot_password_screen_two.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const ForgotPasswordScreenOne() : const ForgotPasswordScreenTwo();
  }
}
