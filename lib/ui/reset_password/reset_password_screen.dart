import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/reset_password/reset_password_screen_one.dart';
import 'package:quicklai/ui/reset_password/reset_password_screen_two.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const ResetPasswordScreenOne() : const ResetPasswordScreenTwo();
  }
}
