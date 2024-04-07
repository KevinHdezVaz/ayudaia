import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/chat_bot/select_character/select_character_screen_one.dart';
import 'package:quicklai/ui/chat_bot/select_character/select_character_screen_two.dart';

class SelectCharacterScreen extends StatelessWidget {
  const SelectCharacterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const SelectCharacterScreenOne() : const SelectCharacterScreenTwo();
  }
}
