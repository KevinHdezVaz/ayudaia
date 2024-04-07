import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/writer_details_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/responsive.dart';
import 'package:quicklai/ui/writer_screen/writer_screen/writer_screen.dart';
import 'package:selectable/selectable.dart';

class WriterDetailsScreenTwo extends StatelessWidget {
  const WriterDetailsScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WriterDetailsController>(
        init: WriterDetailsController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(backgroundColor: ConstantColors.grey01, centerTitle: false, title: Text(controller.categoryData.value.name!.tr)),
            body: Container(
              height: Responsive.height(100, context),
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.bannerAdIsLoaded.value && Constant().isAdsShow() && controller.bannerAd != null,
                        child: Center(
                          child: SizedBox(height: controller.bannerAd!.size.height.toDouble(), width: controller.bannerAd!.size.width.toDouble(), child: AdWidget(ad: controller.bannerAd!)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      chatBubble(context),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (Constant().isAdsShow() && controller.interstitialAd != null) {
                              controller.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                                onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
                                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                                  ad.dispose();
                                  controller.loadAd();
                                  Get.off(const WriterScreen(), arguments: {
                                    "category": controller.categoryData.value,
                                  });
                                },
                                onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                                  log('$ad onAdFailedToShowFullScreenContent: $error');
                                  ad.dispose();
                                  Get.off(const WriterScreen(), arguments: {
                                    "category": controller.categoryData.value,
                                  });
                                },
                              );
                              controller.interstitialAd!.show();
                              controller.interstitialAd = null;
                            } else {
                              Get.back();
                            }

                            // final isLoaded = await controller.interstitialAd.isLoaded;
                            // if (isLoaded == true && Constant().isAdsShow()) {
                            //   controller.interstitialAd.show();
                            // } else {

                            // }
                          },
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: ConstantColors.blue05, shape: const StadiumBorder()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                            child: Text('Ask to New Question'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  chatBubble(BuildContext context) {
    return GetBuilder<WriterDetailsController>(builder: (controller) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration:
                      BoxDecoration(color: ConstantColors.blue05, borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
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
                            child: Lottie.network('https://assets5.lottiefiles.com/packages/lf20_3r3rc9.json', fit: BoxFit.fill),
                          ),
                        ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        child: Text(controller.question.value.replaceFirst('\n\n', '')),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.textToSpeechAnswer.value = false;
                              controller.textToSpeechQuesion.value = true;
                              controller.update();
                              controller.speak(speechText: controller.question.value.replaceFirst('\n\n', ''));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: controller.textToSpeechQuesion.value == true
                                  ? SizedBox.fromSize(size: const Size.fromRadius(10))
                                  : SizedBox.fromSize(
                                      size: const Size.fromRadius(10), // Image radius
                                      child: const Icon(Icons.volume_up_outlined, color: Colors.white, size: 18),
                                    ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: controller.question.value));
                                ShowToastDialog.showToast('Copy!!'.tr);
                              },
                              child: const Align(alignment: Alignment.bottomRight, child: Icon(Icons.copy, color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  decoration: BoxDecoration(color: ConstantColors.background, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(15), // Image radius
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset('assets/icons/chat_gpt_icon.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: controller.answer.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    decoration: BoxDecoration(color: ConstantColors.background, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(15), // Image radius
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset('assets/icons/chat_gpt_icon.png'),
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
                        color: ConstantColors.opacityBg, borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
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
                              child: Lottie.network('https://assets5.lottiefiles.com/packages/lf20_3r3rc9.json', fit: BoxFit.fill),
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
                            child: Text(controller.answer.value.replaceFirst('\n\n', '')),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: controller.answer.value.replaceFirst('\n\n', '')));
                                  ShowToastDialog.showToast('Copy!!'.tr);
                                },
                                child: const Align(alignment: Alignment.bottomRight, child: Icon(Icons.copy, color: Colors.white))),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: controller.answer.isNotEmpty,
                              child: GestureDetector(
                                onTap: () {
                                  controller.textToSpeechQuesion.value = false;
                                  controller.textToSpeechAnswer.value = true;
                                  controller.update();
                                  controller.speak(speechText: controller.answer.value.replaceFirst('\n\n', ''));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: controller.textToSpeechAnswer.value == true
                                      ? SizedBox.fromSize(
                                          size: const Size.fromRadius(10),
                                        )
                                      : SizedBox.fromSize(
                                          size: const Size.fromRadius(10), // Image radius
                                          child: const Icon(Icons.volume_up_outlined, color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
