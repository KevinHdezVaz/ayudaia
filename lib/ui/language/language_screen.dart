import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/language/language_screen_one.dart';
import 'package:quicklai/ui/language/language_screen_two.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const LanguageScreenOne() : const LanguageScreenTwo();
  }
}
