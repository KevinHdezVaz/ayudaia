import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/astrology_controller.dart';
import 'package:quicklai/controller/setting_controller.dart';
import 'package:quicklai/model/chat.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/responsive.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:selectable/selectable.dart';

class AstrologyScreenTwo extends StatelessWidget {
  const AstrologyScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AstrologyController>(
      init: AstrologyController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Astrology'.tr), backgroundColor: ConstantColors.grey01, centerTitle: false),
          body: Container(
            height: Responsive.height(100, context),
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Visibility(
                          visible: controller.bannerAdIsLoaded.value && Constant().isAdsShow() && controller.bannerAd != null,
                          child: Center(
                            child: SizedBox(height: controller.bannerAd!.size.height.toDouble(), width: controller.bannerAd!.size.width.toDouble(), child: AdWidget(ad: controller.bannerAd!)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: ListView.builder(
                              controller: controller.scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller.chatList.length,
                              itemBuilder: (context, index) {
                                return chatBubble(context, index);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLines: null,
                            controller: controller.messageController.value,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                controller.isClickable.value = true;
                              } else {
                                controller.isClickable.value = false;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Write your message...'.tr,
                              hintStyle: TextStyle(color: ConstantColors.hintTextColor),
                              // ignore: unnecessary_null_comparison
                              prefixIcon: controller.messageController.value.text.isEmpty
                                  ? null
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: InkWell(
                                        onTap: (() async {
                                          FocusScope.of(context).unfocus();
                                          controller.messageController.value.clear();
                                        }),
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black.withAlpha(5)),
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              suffixIcon: InkWell(
                                onTap: (() async {
                                  FocusScope.of(context).unfocus();

                                  if (controller.writerLimit.value == "0" && Constant.isActiveSubscription == false) {
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
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: controller.messageController.value.text.isEmpty ? Colors.grey : ConstantColors.primary),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: ConstantColors.grey01,
                              contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ConstantColors.cardViewColor), borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ConstantColors.cardViewColor), borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: Constant.isActiveSubscription == true ? false : true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Text('${'You have'.tr} ${controller.writerLimit} ${'free messages left'.tr} ', style: const TextStyle(color: Colors.white)),
                                Image.asset('assets/icons/ic_subscription_icon.png', width: 18,color: ConstantColors.blue04),
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
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  chatBubble(BuildContext context, int index) {
    return GetBuilder<AstrologyController>(builder: (controller) {
      var chatItem = controller.chatList[index];

      return Row(
        mainAxisAlignment: chatItem.chat == "0" ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: chatItem.chat == "1",
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: BoxDecoration(color: ConstantColors.grey01, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
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
                padding: const EdgeInsets.only(right: 5),
                child: chatItem?.active == true
                    ? SizedBox.fromSize(size: const Size.fromRadius(12))
                    : SizedBox.fromSize(
                        size: const Size.fromRadius(12), // Image radius
                        child: const Icon(Icons.volume_up_outlined, color: Colors.grey, size: 18),
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
                  color: chatItem.chat == "0" ? ConstantColors.blue04 : ConstantColors.grey01,
                  borderRadius: chatItem.chat == "0"
                      ? const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                      : const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
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
                      child: chatItem.chat == "1"
                          ? Selectable(selectWordOnLongPress: true, selectWordOnDoubleTap: true, child: Text(chatItem.msg!.replaceFirst('\n\n', '')))
                          : Text(chatItem.msg!.replaceFirst('\n\n', ''))),
                ],
              ),
            ),
          ),
          Visibility(
            visible: chatItem.chat == "0",
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ClipOval(
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
                    ? SizedBox.fromSize(
                        size: const Size.fromRadius(12),
                      )
                    : SizedBox.fromSize(
                        size: const Size.fromRadius(12), // Image radius
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: const Icon(Icons.volume_up_outlined, size: 18, color: Colors.grey),
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
