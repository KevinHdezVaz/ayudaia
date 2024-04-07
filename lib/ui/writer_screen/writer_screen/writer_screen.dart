
import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/writer_screen/writer_screen/writer_screen_one.dart';
import 'package:quicklai/ui/writer_screen/writer_screen/writer_screen_two.dart';

class WriterScreen extends StatelessWidget {
  const WriterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const WriterScreenOne() : const WriterScreenTwo();
  }
}
