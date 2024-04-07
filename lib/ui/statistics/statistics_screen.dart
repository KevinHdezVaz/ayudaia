import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/statistics/statistics_screen_one.dart';
import 'package:quicklai/ui/statistics/statistics_screen_two.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const StatisticsScreenOne() : const StatisticsScreenTwo();
  }
}
