import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/history_details_controller.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/history/history_details/history_details_screen_one.dart';
import 'package:quicklai/ui/history/history_details/history_details_screen_two.dart';
import 'package:selectable/selectable.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final HistoryData historyData;

  const HistoryDetailsScreen({Key? key, required this.historyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Constant.theme == "theme_1"
        ? HistoryDetailsScreenOne(
            historyData: historyData,
          )
        : HistoryDetailsScreenTwo(historyData: historyData);
  }
}
