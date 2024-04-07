import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/ai_code/aicode_screen_one.dart';
import 'package:quicklai/ui/ai_code/aicode_screen_two.dart';

class AiCodeScreen extends StatelessWidget {
  const AiCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const AiCodeScreenOne() : const AiCodeScreenTwo();
  }
}
