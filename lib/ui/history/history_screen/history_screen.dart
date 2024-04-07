import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/history/history_screen/history_screen_one.dart';
import 'package:quicklai/ui/history/history_screen/history_screen_two.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const HistoryScreenOne() : const HistoryScreenTwo();
  }
}
