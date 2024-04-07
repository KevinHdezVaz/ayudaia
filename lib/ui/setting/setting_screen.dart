
import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/setting/setting_screen_one.dart';
import 'package:quicklai/ui/setting/setting_screen_two.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? SettingScreenOne() : SettingScreenTwo();
  }

}
