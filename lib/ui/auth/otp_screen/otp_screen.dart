import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/auth/otp_screen/otp_screen_one.dart';
import 'package:quicklai/ui/auth/otp_screen/otp_screen_two.dart';

class OTPScreen extends StatelessWidget {
  final Map<String, String> bodyParams;

  const OTPScreen({Key? key, required this.bodyParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? OTPScreenOne(bodyParams: bodyParams) : OTPScreenTwo(bodyParams: bodyParams);
  }
}
