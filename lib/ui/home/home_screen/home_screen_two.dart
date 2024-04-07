import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/controller/home_controller.dart';
import 'package:quicklai/model/banner_model.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/ai_code/aicode_screen.dart';
import 'package:quicklai/ui/astrology/astrology_screen.dart';
import 'package:quicklai/ui/chat_bot/select_character/select_character_screen.dart';
import 'package:quicklai/ui/history/history_details/history_details_screen.dart';
import 'package:quicklai/ui/history/history_screen/history_screen.dart';
import 'package:quicklai/ui/home/category_list/category_list_screen.dart';
import 'package:quicklai/ui/writer_screen/writer_screen/writer_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../widget/custom_alert_dialog.dart';
//

class HomeScreenTwo extends StatelessWidget {
  HomeScreenTwo({Key? key}) : super(key: key);

  final PageController _controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: ConstantColors.grey01,
                  centerTitle: false,
                  title: Text('QuicklAI'.tr, style: TextStyle(fontSize: 24, color: ConstantColors.blue04, fontWeight: FontWeight.bold)),
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
                                  return;
                                }
                                controller.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                                  onAdShowedFullScreenContent: (RewardedAd ad) => log('ad onAdShowedFullScreenContent.'),
                                  onAdDismissedFullScreenContent: (RewardedAd ad) {
                                    ad.dispose();
                                    controller.increaseLimit();
                                    controller.loadRewardAd();
                                  },
                                  onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
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
                            SvgPicture.asset("assets/icons/ic_reward.svg"),
                            const Expanded(
                                child: Text(
                              "Reward ads",
                              style: TextStyle(color: Color(0xff12B669)),
                            ))
                          ],
                        ),
                      ),
                    )
                  ]),
              body: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.isBannerLoading.value == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Visibility(
                              visible: controller.bannerList.isNotEmpty,
                              child: SizedBox(
                                  height: 24.w,
                                  child: PageView.builder(
                                      padEnds: false,
                                      itemCount: controller.bannerList.length,
                                      scrollDirection: Axis.horizontal,
                                      controller: _controller,
                                      itemBuilder: (context, index) {
                                        BannerData bannerModel = controller.bannerList[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: CachedNetworkImage(
                                            imageUrl: bannerModel.photo.toString(),
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                              ),
                                            ),
                                            color: Colors.black.withOpacity(0.5),
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      })),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const SelectCharacterScreen(), transition: Transition.downToUp);
                        },
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {},
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          enabled: false,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                            hintMaxLines: 50,
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: ConstantColors.hintTextColor),
                            filled: true,
                            fillColor: ConstantColors.grey01,
                            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ConstantColors.cardViewColor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            disabledBorder: OutlineInputBorder(
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
                        height: 10,
                      ),
                      if (controller.topCategoryList.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.w),
                          child: SizedBox(
                              height: 12.w,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const AiCodeScreen());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: ShapeDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(-0.48, 0.88),
                                          end: Alignment(0.48, -0.88),
                                          colors: [Color(0xFFE31A53), Color(0xFFEAA907)],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/icons/ic_code.svg"),
                                          Text(
                                            'AI Code',
                                            style: GoogleFonts.wixMadeforText(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const AstrologyScreen());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      decoration: ShapeDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(0.00, 1.00),
                                          end: Alignment(0, -1),
                                          colors: [Color(0xFF00FFF0), Color(0xFF0083FE)],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/icons/ic_astrology.svg"),
                                          Text(
                                            'Astrology',
                                            style: GoogleFonts.wixMadeforText(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ])),
                        ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Your Quickl Assistants'.tr,
                              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const CategoryListScreen());
                            },
                            child: Text(
                              'View All'.tr,
                              style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.historyList.isEmpty
                              ? Expanded(
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: (4.h / 4.h),
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 4.0.w,
                                      crossAxisSpacing: 4.0.w,
                                    ),
                                    itemCount: controller.categoryList.length >= 9 ? 9 : controller.categoryList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      CategoryData categoryData = controller.categoryList[index];
                                      return InkWell(
                                        onTap: () async {
                                          if (Constant().isAdsShow() && controller.interstitialAd != null) {
                                            if (index % 2 == 0) {
                                              controller.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                                                onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
                                                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                                                  ad.dispose();
                                                  controller.loadAd();
                                                  Get.to(const WriterScreen(), arguments: {
                                                    "category": categoryData,
                                                  });
                                                },
                                                onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                                                  ad.dispose();
                                                  Get.to(const WriterScreen(), arguments: {
                                                    "category": categoryData,
                                                  });
                                                },
                                              );
                                              controller.interstitialAd!.show();
                                              controller.interstitialAd = null;
                                            } else {
                                              Get.to(const WriterScreen(), arguments: {
                                                "category": categoryData,
                                              });
                                            }
                                          } else {
                                            Get.to(const WriterScreen(), arguments: {
                                              "category": categoryData,
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ConstantColors.grey02,
                                            border: Border.all(color: ConstantColors.grey03),
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 36,
                                                  width: 36,
                                                  imageUrl: categoryData.photo.toString(),
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                                  ),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                                const Expanded(child: SizedBox()),
                                                Text(
                                                  categoryData.name.toString().tr,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 32.w,
                                  child: ListView.builder(
                                    itemCount: controller.categoryList.length >= 9 ? 9 : controller.categoryList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      CategoryData categoryData = controller.categoryList[index];
                                      return SizedBox(
                                        width: 32.w,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                                          child: InkWell(
                                            onTap: () async {
                                              if (Constant().isAdsShow()) {
                                                if (index % 2 == 0) {
                                                  if (controller.interstitialAd == null) {
                                                    return;
                                                  }
                                                  controller.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                                                    onAdShowedFullScreenContent: (InterstitialAd ad) => log('ad onAdShowedFullScreenContent.'),
                                                    onAdDismissedFullScreenContent: (InterstitialAd ad) {
                                                      log('$ad onAdDismissedFullScreenContent.');
                                                      ad.dispose();
                                                      controller.loadAd();
                                                      Get.to(const WriterScreen(), arguments: {
                                                        "category": categoryData,
                                                      });
                                                    },
                                                    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                                                      ad.dispose();
                                                      Get.to(const WriterScreen(), arguments: {
                                                        "category": categoryData,
                                                      });
                                                    },
                                                  );
                                                  controller.interstitialAd!.show();
                                                  controller.interstitialAd = null;
                                                } else {
                                                  Get.to(const WriterScreen(), arguments: {
                                                    "category": categoryData,
                                                  });
                                                }
                                              } else {
                                                Get.to(const WriterScreen(), arguments: {
                                                  "category": categoryData,
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ConstantColors.grey02,
                                                border: Border.all(color: ConstantColors.grey03),
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    CachedNetworkImage(
                                                      height: 32,
                                                      width: 32,
                                                      imageUrl: categoryData.photo.toString(),
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                        child: CircularProgressIndicator(value: downloadProgress.progress),
                                                      ),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                    const Expanded(child: SizedBox()),
                                                    Text(
                                                      categoryData.name.toString().tr,
                                                      maxLines: 2,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      SizedBox(
                        height: 2.w,
                      ),
                      controller.isHistoryLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.historyList.isEmpty
                              ? Container()
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Recently Prompt'.tr,
                                              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(const HistoryScreen(), arguments: {
                                                "categoryId": "0",
                                              });
                                            },
                                            child: Text(
                                              'View All'.tr,
                                              style: TextStyle(color: Colors.white, fontSize: 10.sp, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.w,
                                      ),
                                      Expanded(
                                        child: RefreshIndicator(
                                          onRefresh: () => controller.getHistoryProms(),
                                          child: ListView.builder(
                                            itemCount: controller.historyList.length >= 10 ? 10 : controller.historyList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              HistoryData historyData = controller.historyList[index];
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(HistoryDetailsScreen(historyData: historyData));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: ConstantColors.grey02,
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    width: 32,
                                                                    height: 32,
                                                                    imageUrl: historyData.categoryPhoto.toString(),
                                                                    fit: BoxFit.cover,
                                                                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                                      child: CircularProgressIndicator(value: downloadProgress.progress),
                                                                    ),
                                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    historyData.categoryName.toString().tr,
                                                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                                                  ),
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    barrierColor: Colors.black26,
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return CustomAlertDialog(
                                                                        title: "Are you sure you want to Delete?",
                                                                        onPressNegative: () {
                                                                          Get.back();
                                                                        },
                                                                        onPressPositive: () {
                                                                          Get.back();
                                                                          controller.deleteByIdProms(model: historyData);
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: const Padding(
                                                                  padding: EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.delete, size: 18, color: Colors.white),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(color: Colors.white),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                historyData.subject.toString(),
                                                                maxLines: 2,
                                                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                historyData.answer.toString().replaceFirst('\n\n', ''),
                                                                maxLines: 2,
                                                                // textDirection:
                                                                //     TextDirection
                                                                //         .ltr,
                                                                // textAlign: Preferences
                                                                //             .localLNG ==
                                                                //         'English'
                                                                //     ? TextAlign
                                                                //         .start
                                                                //     : TextAlign
                                                                //         .end,
                                                                style: TextStyle(color: ConstantColors.subTitleTextColor, letterSpacing: 1.5),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
