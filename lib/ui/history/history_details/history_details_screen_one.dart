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
import 'package:selectable/selectable.dart';

class HistoryDetailsScreenOne extends StatelessWidget {
  final HistoryData historyData;

  const HistoryDetailsScreenOne({Key? key, required this.historyData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryDetailsController>(
        init: HistoryDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(
                title: Text(historyData.categoryName.toString()),
                centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    chatBubble(context),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (Constant().isAdsShow() &&
                              controller.interstitialAd != null) {
                            controller
                                    .interstitialAd!.fullScreenContentCallback =
                                FullScreenContentCallback(
                              onAdShowedFullScreenContent:
                                  (InterstitialAd ad) =>
                                      log('ad onAdShowedFullScreenContent.'),
                              onAdDismissedFullScreenContent:
                                  (InterstitialAd ad) {
                                log('$ad onAdDismissedFullScreenContent.');
                                ad.dispose();
                                controller.loadAd();
                                Get.back();
                              },
                              onAdFailedToShowFullScreenContent:
                                  (InterstitialAd ad, AdError error) {
                                log('$ad onAdFailedToShowFullScreenContent: $error');
                                ad.dispose();
                                Get.back();
                              },
                            );
                            controller.interstitialAd!.show();
                            controller.interstitialAd = null;
                          } else {
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: ConstantColors.primary,
                            shape: const StadiumBorder()),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12),
                          child: Text('Ask to New Question',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  chatBubble(BuildContext context) {
    return GetBuilder<HistoryDetailsController>(builder: (controller) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  controller.textToSpeechAnswer.value = false;
                  controller.textToSpeechQuesion.value = true;
                  controller.update();
                  controller.speak(
                      speechText:
                          historyData.subject!.replaceFirst('\n\n', ''));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: controller.textToSpeechQuesion.value == true
                      ? SizedBox.fromSize(size: const Size.fromRadius(10))
                      : SizedBox.fromSize(
                          size: const Size.fromRadius(10), // Image radius
                          child: const Icon(Icons.volume_up_outlined,
                              color: Colors.grey, size: 18),
                        ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: ConstantColors.primary,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.textToSpeechQuesion.value == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: SizedBox(
                            width: 35,
                            height: 16,
                            child: Lottie.network(
                                'https://assets5.lottiefiles.com/packages/lf20_3r3rc9.json',
                                fit: BoxFit.fill),
                          ),
                        ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              speed: const Duration(milliseconds: 10),
                              historyData.subject!.replaceFirst('\n\n', ''),
                            ),
                          ],
                          repeatForever: false,
                          totalRepeatCount: 1,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: historyData.subject!
                                    .replaceFirst('\n\n', '')));
                            ShowToastDialog.showToast('Copy!!'.tr);
                          },
                          child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.copy, color: Colors.white))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: ConstantColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(15), // Image radius
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CachedNetworkImage(
                          imageUrl: historyData.categoryPhoto.toString(),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: historyData.answer!.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ConstantColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(15), // Image radius
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CachedNetworkImage(
                            imageUrl: historyData.categoryPhoto.toString(),
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: ConstantColors.cardViewColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.textToSpeechAnswer.value == true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: SizedBox(
                              width: 35,
                              height: 16,
                              child: Lottie.network(
                                  'https://assets5.lottiefiles.com/packages/lf20_3r3rc9.json',
                                  fit: BoxFit.fill),
                            ),
                          ),
                        Selectable(
                          selectWordOnLongPress: true,
                          selectWordOnDoubleTap: true,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                  speed: const Duration(milliseconds: 10),
                                  historyData.answer!.replaceFirst('\n\n', ''),
                                ),
                              ],
                              repeatForever: false,
                              totalRepeatCount: 1,
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: historyData.answer!
                                      .replaceFirst('\n\n', '')));
                              ShowToastDialog.showToast('Copy!!'.tr);
                            },
                            child: const Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(Icons.copy, color: Colors.white))),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.textToSpeechQuesion.value = false;
                    controller.textToSpeechAnswer.value = true;
                    controller.update();
                    controller.speak(
                        speechText:
                            historyData.answer!.replaceFirst('\n\n', ''));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: controller.textToSpeechAnswer.value == true
                        ? SizedBox.fromSize(size: const Size.fromRadius(10))
                        : SizedBox.fromSize(
                            size: const Size.fromRadius(10), // Image radius
                            child: const Icon(Icons.volume_up_outlined,
                                color: Colors.grey, size: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
