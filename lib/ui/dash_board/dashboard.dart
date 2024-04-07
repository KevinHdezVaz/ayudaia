import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/dash_board/dashboard_one.dart';
import 'package:quicklai/ui/dash_board/dashboard_two.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const DashBoardOne() : const DashBoardTwo();
  }
}
