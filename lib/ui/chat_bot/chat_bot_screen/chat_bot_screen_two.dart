import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/chat_bot_controller.dart';
import 'package:quicklai/controller/setting_controller.dart';
import 'package:quicklai/model/chat.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/widget/custom_alert_dialog.dart';
import 'package:selectable/selectable.dart';

class ChatBotScreenTwo extends StatefulWidget {
  const ChatBotScreenTwo({Key? key}) : super(key: key);

  @override
  State<ChatBotScreenTwo> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return GetX<ChatBotController>(
      init: ChatBotController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              backgroundColor: ConstantColors.grey01,
              centerTitle: false,
              title: Text('Quickl AI Chat'.tr),
              leadingWidth: 30,
              actions: [
                InkWell(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.black26,
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          title: "Watch Video to increase your limit",
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
                                controller.increaseLimit();
                                controller.loadRewardAd();
                              },
                              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                                log('$ad onAdFailedToShowFullScreenContent: $error');
                                ad.dispose();
                                controller.loadRewardAd();
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Icon(
                          Icons.slow_motion_video_outlined,
                          color: ConstantColors.primary,
                        ),
                        const Expanded(child: Text("Reward ads"))
                      ],
                    ),
                  ),
                ),
                PopupMenuButton(
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      if (value == 0) {
                        showDialog(
                          barrierColor: Colors.black26,
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: "Are you sure you want to delete the Chat History?",
                              onPressNegative: () {
                                Get.back();
                              },
                              onPressPositive: () {
                                Get.back();
                                controller.deleteChatHistory();
                              },
                            );
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                    padding: const EdgeInsets.all(2.0),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          const PopupMenuItem(
                              height: 25,
                              value: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Clear All",
                                  ),
                                  Icon(Icons.delete, color: Colors.black, size: 18)
                                ],
                              )),
                        ])
              ]),
          body: Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        Visibility(
                          visible: controller.bannerAdIsLoaded.value && Constant().isAdsShow() && controller.bannerAd != null,
                          child: Center(
                            child: SizedBox(height: controller.bannerAd!.size.height.toDouble(), width: controller.bannerAd!.size.width.toDouble(), child: AdWidget(ad: controller.bannerAd!)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListView.builder(
                              controller: controller.scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller.chatList.length,
                              itemBuilder: (context, index) {
                                return chatBubble(index: index, context: context);
                              },
                            ),
                          ),
                        ),
                        GetBuilder<ChatBotController>(builder: (controller) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.messageController.value,
                                        style: const TextStyle(color: Colors.white),
                                        onChanged: (value) {},
                                        textInputAction: TextInputAction.done,
                                        readOnly: controller.speech.value.isListening,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              controller.speechDown();
                                            },
                                            icon: controller.speech.value.isListening
                                                ? const Icon(
                                                    Icons.mic,
                                                    color: Colors.greenAccent,
                                                  )
                                                : const Icon(
                                                    Icons.mic,
                                                    color: Colors.white,
                                                  ),
                                          ),
                                          hintMaxLines: 50,
                                          hintText: controller.speech.value.isListening ? 'Listening...' : 'Type your message...',
                                          hintStyle: TextStyle(color: controller.speech.value.isListening ? Colors.greenAccent : ConstantColors.hintTextColor),
                                          filled: true,
                                          fillColor: ConstantColors.grey01,
                                          contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: ConstantColors.cardViewColor),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: ConstantColors.cardViewColor),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        FocusScope.of(context).unfocus();

                                        if (controller.chatLimit.value == "0" && Constant.isActiveSubscription == false) {
                                          ShowToastDialog.showToast("Your free limit is over.Please subscribe to package to get unlimited limit".tr);
                                          Get.to(const SubscriptionScreen());
                                        } else {
                                          if (controller.messageController.value.text.isNotEmpty) {
                                            Chat chat = Chat(msg: controller.messageController.value.text, chat: "0");
                                            controller.chatList.add(chat);

                                            controller.sendResponse(controller.messageController.value.text);
                                          } else {
                                            ShowToastDialog.showToast("Please enter message".tr);
                                          }
                                        }
                                      }),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: ConstantColors.blue05),
                                        child: const Icon(
                                          Icons.send_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (controller.speech.value.isListening) const SizedBox(height: 20),

                                Visibility(
                                  visible: controller.speech.value.isListening,
                                  child: SizedBox(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: List<Widget>.generate(
                                            controller.duration.length,
                                            (index) => AnimationShow(
                                                  color: controller.color[index],
                                                  duration: controller.duration[index % 5],
                                                ))),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20),
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(10),
                                //     child: LinearProgressIndicator(
                                //       backgroundColor: Colors.green,
                                //       color: ConstantColors.cardViewColor,
                                //       minHeight: 2,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }),
                        Visibility(
                          visible: Constant.isActiveSubscription == true ? false : true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${'You have'.tr} ${controller.chatLimit} ${'free messages left'.tr}', style: const TextStyle(color: Colors.white)),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset('assets/icons/ic_subscription_icon.png', width: 18, color: ConstantColors.blue04),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(const SubscriptionScreen());
                                    },
                                    child: Text('Subscribe Now'.tr, style: TextStyle(color: ConstantColors.blue04))),
                              ],
                            ),
                          ),
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

//   TextToSpeech tts = TextToSpeech();
// chatBubble({required BuildContext context, required Chat chatItem}) {
//   return GetBuilder<ChatBotController>(builder: (controller) {
//     return Row(
//       mainAxisAlignment: chatItem.chat == "0"
//           ? MainAxisAlignment.end
//           : MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Visibility(
//           visible: chatItem.chat == "1",
//           child: Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: ConstantColors.background,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white)),
//               child: ClipOval(
//                 child: SizedBox.fromSize(
//                   size: const Size.fromRadius(15), // Image radius
//                   child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: CachedNetworkImage(
//                           imageUrl: controller.selectedCharacter.value!.photo
//                               .toString(),
//                           fit: BoxFit.cover,
//                           progressIndicatorBuilder:
//                               (context, url, downloadProgress) => Center(
//                             child: CircularProgressIndicator(
//                                 value: downloadProgress.progress),
//                           ),
//                           errorWidget: (context, url, error) =>
//                               const Icon(Icons.error),
//                         ),
//                       )),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: chatItem.chat == "0",
//           child: Padding(
//             padding: const EdgeInsets.only(right: 5),
//             child: chatItem.active == true
//                 // ignore: dead_code
//                 ? SizedBox.fromSize(
//                     size: const Size.fromRadius(15), // Image radius
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child:
//                           const Icon(Icons.wifi, size: 16, color: Colors.grey),
//                     ),
//                   )
//                 : GestureDetector(
//                     onTap: () {
//                       chatItem.active = true;
//                       controller.speak(speechText: chatItem);
//                       controller.flutterTts.value.setCompletionHandler(() {
//                         chatItem.active = false;
//                         log(chatItem.active.toString());
//                       });
//                       controller.update();
//                     },
//                     child: SizedBox.fromSize(
//                       size: const Size.fromRadius(15), // Image radius
//                       child: const Icon(Icons.volume_up_outlined,
//                           color: Colors.grey, size: 16),
//                     ),
//                   ),
//           ),
//         ),
//         Flexible(
//           child: Container(
//             margin: const EdgeInsets.only(top: 10),
//             padding: const EdgeInsets.symmetric(
//               vertical: 10,
//               horizontal: 10,
//             ),
//             decoration: BoxDecoration(
//                 color: chatItem.chat == "0"
//                     ? ConstantColors.primary
//                     : ConstantColors.cardViewColor,
//                 borderRadius: chatItem.chat == "0"
//                     ? const BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                         bottomLeft: Radius.circular(10))
//                     : const BorderRadius.only(
//                         topRight: Radius.circular(10),
//                         topLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10))),
//             child: DefaultTextStyle(
//                 style: const TextStyle(
//                   color: Colors.white,
//                 ),
//                 child: chatItem.chat == "1"
//                     ? Selectable(
//                         selectWordOnLongPress: true,
//                         selectWordOnDoubleTap: true,
//                         child: Text(chatItem.msg!.replaceFirst('\n\n', '')))
//                     : Text(chatItem.msg!.replaceFirst('\n\n', ''))),
//           ),
//         ),
//         Visibility(
//           visible: chatItem.chat == "0",
//           child: Padding(
//             padding: const EdgeInsets.only(left: 5),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: ConstantColors.background,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white)),
//               child: SizedBox.fromSize(
//                 size: const Size.fromRadius(15), // Image radius
//                 child: Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: GetBuilder<SettingController>(
//                       init: SettingController(),
//                       builder: (controllerSettings) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: controllerSettings.profileImage.isEmpty
//                               ? Image.asset(
//                                   'assets/images/profile_placeholder.png')
//                               : CachedNetworkImage(
//                                   imageUrl: controllerSettings.profileImage
//                                       .toString(),
//                                   fit: BoxFit.cover,
//                                   progressIndicatorBuilder:
//                                       (context, url, downloadProgress) =>
//                                           Center(
//                                     child: CircularProgressIndicator(
//                                         value: downloadProgress.progress),
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(Icons.error),
//                                 ),
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: chatItem.chat == "1",
//           child: Padding(
//             padding: const EdgeInsets.only(right: 4),
//             child: chatItem.active == true
//                 ? SizedBox.fromSize(
//                     size: const Size.fromRadius(15), // Image radius
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(50),
//                       child:
//                           const Icon(Icons.wifi, size: 16, color: Colors.grey),
//                     ),
//                   )
//                 : GestureDetector(
//                     onTap: () async {
//                       chatItem.active = true;
//                       controller.speak(speechText: chatItem);
//                       controller.flutterTts.value.setCompletionHandler(() {
//                         chatItem.active = false;
//                         log(chatItem.active.toString());
//                       });
//                       controller.update();
//                     },
//                     child: SizedBox.fromSize(
//                       size: const Size.fromRadius(15), // Image radius
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: const Icon(Icons.volume_up_outlined,
//                             size: 16, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//           ),
//         ),
//       ],
//     );
//   });
// }

// ignore: must_be_immutable
Widget chatBubble({required index, required context}) {
  return GetBuilder<ChatBotController>(builder: (controller) {
    var chatItem = controller.chatList[index];
    return Row(
      mainAxisAlignment: chatItem.chat == "0" ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: chatItem?.chat == "1",
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              decoration: BoxDecoration(color: ConstantColors.background, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(15), // Image radius
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: controller.selectedCharacter.value!.photo.toString(),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      )),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: chatItem?.chat == "0",
          child: GestureDetector(
            onTap: () {
              controller.updateIcon();
              if (chatItem?.active == false) {
                chatItem?.active = true;

                controller.speak(speechText: chatItem!, index: index);
              } else {
                controller.updateIcon();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: chatItem?.active == true
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22,
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22, // Image radius
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.volume_up_outlined, size: 18, color: Colors.grey),
                        ],
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
                color: chatItem?.chat == "0" ? ConstantColors.blue05 : ConstantColors.opacityBg,
                borderRadius: chatItem?.chat == "0"
                    ? const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
                    : const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chatItem?.active == true)
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
                    ),
                    child: chatItem?.chat == "1"
                        ? Selectable(selectWordOnLongPress: true, selectWordOnDoubleTap: true, child: Text(chatItem!.msg!.replaceFirst('\n\n', '')))
                        : Text(chatItem!.msg!.replaceFirst('\n\n', ''))),
              ],
            ),
          ),
        ),
        Visibility(
          visible: chatItem?.chat == "0",
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Container(
              decoration: BoxDecoration(color: ConstantColors.background, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(15), // Image radius
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GetBuilder<SettingController>(
                      init: SettingController(),
                      builder: (controllerSettings) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: controllerSettings.profileImage.isEmpty
                              ? Image.asset('assets/images/profile_placeholder.png')
                              : CachedNetworkImage(
                                  imageUrl: controllerSettings.profileImage.toString(),
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: chatItem?.chat == "1",
          child: GestureDetector(
            onTap: () async {
              if (chatItem?.active == false) {
                controller.updateIcon();

                chatItem?.active = true;

                controller.speak(speechText: chatItem!, index: index);
              } else {
                controller.updateIcon();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: chatItem?.active == true
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22,
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22, // Image radius
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.volume_up_outlined, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  });
}

// ignore: must_be_immutable
class AnimationShow extends StatefulWidget {
  int duration;
  Color color;

  AnimationShow({super.key, required this.duration, required this.color});

  @override
  State<AnimationShow> createState() => _AnimationShowState();
}

class _AnimationShowState extends State<AnimationShow> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
    final curveAnimation = CurvedAnimation(parent: animationController, curve: Curves.slowMiddle);
    animation = Tween<double>(begin: 0, end: 100).animate(curveAnimation)
      ..addListener(() {
        setState(() {});
      });
    animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: animation.value,
      decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(5)),
    );
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
