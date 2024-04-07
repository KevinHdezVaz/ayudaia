import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/profile_update/profile_update_screen_one.dart';
import 'package:quicklai/ui/profile_update/profile_update_screen_two.dart';

class ProfileUpdateScreen extends StatelessWidget {
  const ProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const ProfileUpdateScreenOne() : const ProfileUpdateScreenTwo();
  }
}
