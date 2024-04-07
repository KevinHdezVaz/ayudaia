import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/auth/login/login_screen_ui_one.dart';
import 'package:quicklai/ui/auth/login/login_screen_ui_two.dart';

class LoginScreen extends StatelessWidget {
  final String redirectType;

  const LoginScreen({Key? key, required this.redirectType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? LoginScreenUiOne(redirectType: redirectType) : LoginScreenUiTwo(redirectType: redirectType);
  }
}
