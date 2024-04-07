import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/on_bording_screen/on_boarding_screen_one.dart';
import 'package:quicklai/ui/on_bording_screen/on_boarding_screen_two.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const OnBoardingScreenOne() : const OnBoardingScreenTwo();
  }
}
