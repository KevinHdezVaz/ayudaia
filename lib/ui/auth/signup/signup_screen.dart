import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/auth/signup/signup_screen_one.dart';
import 'package:quicklai/ui/auth/signup/signup_screen_two.dart';

class SignupScreen extends StatelessWidget {
  final String? redirectType;
  final String token;

  const SignupScreen({Key? key, required this.token, required this.redirectType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? SignupScreenOne(token: token, redirectType: redirectType) : SignupScreenTwo(token: token, redirectType: redirectType);
  }
}
