import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/home/home_screen/home_screen_one.dart';
import 'package:quicklai/ui/home/home_screen/home_screen_two.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? HomeScreenOne() : HomeScreenTwo();
  }
}
