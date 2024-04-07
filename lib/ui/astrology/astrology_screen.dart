import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/astrology/astrology_screen_one.dart';
import 'package:quicklai/ui/astrology/astrology_screen_two.dart';

class AstrologyScreen extends StatelessWidget {
  const AstrologyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const AstrologyScreenOne() : const AstrologyScreenTwo();
  }
}
