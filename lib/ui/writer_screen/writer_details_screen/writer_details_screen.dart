import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/writer_screen/writer_details_screen/writer_details_screen_one.dart';
import 'package:quicklai/ui/writer_screen/writer_details_screen/writer_details_screen_two.dart';

class WriterDetailsScreen extends StatelessWidget {
  const WriterDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1" ? const WriterDetailsScreenOne() : const WriterDetailsScreenTwo();
  }

}
