import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/text_to_image/text_to_image/text_to_image_screen_one.dart';
import 'package:quicklai/ui/text_to_image/text_to_image/text_to_image_screen_two.dart';

class TextToImageScreen extends StatelessWidget {
  const TextToImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const TextToImageScreenOne() : const TextToImageScreenTwo();
  }
}
