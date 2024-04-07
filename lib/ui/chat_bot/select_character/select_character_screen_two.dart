import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/controller/character_controller.dart';
import 'package:quicklai/model/characters_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/chat_bot/chat_bot_screen/chat_bot_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:quicklai/widget/custom_alert_dialog.dart';
import 'package:sizer/sizer.dart';

class SelectCharacterScreenTwo extends StatelessWidget {
  const SelectCharacterScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CharacterController>(
      init: CharacterController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: ConstantColors.grey01,
              centerTitle: false,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white)),
              automaticallyImplyLeading: false,
              title: Text('Select Character'.tr)),
          body: Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                    child: controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.14.h,
                                crossAxisCount: 3,
                                mainAxisSpacing: 2.0.w,
                                crossAxisSpacing: 2.0.w,
                              ),
                              itemCount: controller.charactesList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                CharactersData charactersData = controller.charactesList[index];
                                log("======>1 ${charactersData.toJson()}");
                                return InkWell(
                                  onTap: () async {
                                    if (charactersData.lock == "yes") {
                                      showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (context) {
                                          return CustomAlertDialog(
                                            title: "Watch Video to unlock character",
                                            onPressNegative: () {
                                              Get.back();
                                            },
                                            onPressPositive: () {
                                              Get.back();
                                              if (controller.rewardedAd == null) {
                                                log('Warning: attempt to show rewarded before loaded.');
                                                return;
                                              }
                                              controller.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                                                onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
                                                onAdDismissedFullScreenContent: (RewardedAd ad) {
                                                  log('$ad onAdDismissedFullScreenContent.');
                                                  ad.dispose();
                                                  controller.unlockCharacter(charactersData.id.toString());
                                                  controller.loadAd();
                                                },
                                                onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                                                  log('$ad onAdFailedToShowFullScreenContent: $error');
                                                  ad.dispose();
                                                  controller.loadAd();
                                                },
                                              );

                                              controller.rewardedAd!.setImmersiveMode(true);
                                              controller.rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                                                log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
                                              });
                                              controller.rewardedAd = null;
                                            },
                                          );
                                        },
                                      );
                                      //
                                    } else {
                                      controller.selectedCharacter.value = charactersData;
                                    }
                                  },
                                  child: Obx(
                                    () => Stack(
                                      children: [
                                        Center(
                                          child: ClipOval(
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(12.w), // Image radius
                                              child: CachedNetworkImage(
                                                imageUrl: charactersData.photo.toString(),
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                  child: CircularProgressIndicator(value: downloadProgress.progress),
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: ClipOval(
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(12.w),
                                              child: Container(
                                                color: Colors.black.withOpacity(0.30),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.selectedCharacter.value == charactersData,
                                            child: const Positioned(
                                                right: 10,
                                                top: 5,
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.white,
                                                ))),
                                        Visibility(
                                          visible: charactersData.lock == "yes" ? true : false,
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.lock, color: Colors.white, size: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: () async {
                            if (controller.selectedCharacter.value!.id != null && controller.selectedCharacter.value!.lock == "no") {
                              await Preferences.setString(Preferences.selectedCharacters, controller.selectedCharacter.value!.name.toString());
                              Get.off(const ChatBotScreen(), arguments: {'charactersData': controller.selectedCharacter.value});
                            } else {
                              showDialog(
                                barrierColor: Colors.black26,
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    title: "Watch Video to unlock character",
                                    onPressNegative: () {
                                      Get.back();
                                    },
                                    onPressPositive: () {
                                      Get.back();
                                      if (controller.rewardedAd == null) {
                                        log('Warning: attempt to show rewarded before loaded.');
                                        return;
                                      }
                                      controller.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                                        onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
                                        onAdDismissedFullScreenContent: (RewardedAd ad) {
                                          log('$ad onAdDismissedFullScreenContent.');
                                          ad.dispose();
                                          controller.unlockCharacter(controller.selectedCharacter.value!.id.toString());
                                          controller.loadAd();
                                        },
                                        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                                          log('$ad onAdFailedToShowFullScreenContent: $error');
                                          ad.dispose();
                                          controller.loadAd();
                                        },
                                      );

                                      controller.rewardedAd!.setImmersiveMode(true);
                                      controller.rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                                        log('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
                                      });
                                      controller.rewardedAd = null;
                                    },
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(begin: const FractionalOffset(0.8, 0.8), end: const FractionalOffset(0.8, 0.0), stops: const [
                                  0.5,
                                  1.0
                                ], colors: [
                                  const Color.fromARGB(255, 242, 140, 5),
                                  ConstantColors.orange,
                                ]),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.chat, color: Colors.black, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Start chat'.tr,
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '(Free Messages: ${controller.chatLimit.value})'.tr,
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
