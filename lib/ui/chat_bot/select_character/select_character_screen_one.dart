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

class SelectCharacterScreenOne extends StatelessWidget {
  const SelectCharacterScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CharacterController>(
      init: CharacterController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: AppBar(actions: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0, right: 16, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/ic_close.svg', width: 5.w, semanticsLabel: 'Acme Logo'),
                  ],
                ),
              ),
            ),
          ], automaticallyImplyLeading: false, title: Text('Select Character'.tr), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        childAspectRatio: 0.12.h,
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
                            () => Container(
                              decoration: BoxDecoration(
                                color: controller.selectedCharacter.value == charactersData ? ConstantColors.primary : ConstantColors.cardViewColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipOval(
                                          child: SizedBox.fromSize(
                                            size: Size.fromRadius(8.w), // Image radius
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          charactersData.name.toString(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: charactersData.lock == "yes" ? true : false,
                                    child: const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.lock, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
          ),
        );
      },
    );
  }
}
