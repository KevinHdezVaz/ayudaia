import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/controller/category_controller.dart';
import 'package:quicklai/model/category_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/writer_screen/writer_screen/writer_screen.dart';
import 'package:sizer/sizer.dart';

class CategoryListScreenTwo extends StatelessWidget {
  final bool? isShowing;

  const CategoryListScreenTwo({Key? key, required this.isShowing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<CategoryController>(
          init: CategoryController(),
          builder: (controller) {
            return Scaffold(
              appBar: isShowing == true
                  ? AppBar(
                      backgroundColor: ConstantColors.grey01,
                      centerTitle: false,
                      title: Text('Category'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    )
                  : AppBar(backgroundColor: ConstantColors.grey01, title: Text('Your Quickl Assistants'.tr), centerTitle: true),
              body: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (9.h / 9.h),
                            crossAxisCount: 3,
                            mainAxisSpacing: 1.0.w,
                            crossAxisSpacing: 1.0.w,
                          ),
                          itemCount: controller.categoryList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CategoryData categoryData = controller.categoryList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.w),
                              child: InkWell(
                                onTap: () async {
                                  if (Constant().isAdsShow() && controller.interstitialAd != null) {
                                    if (index % 2 == 0) {
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
                                          log('$ad onAdFailedToShowFullScreenContent: $error');
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
                              ),
                            );
                          },
                        ),
                ),
              ),
            );
          });
    });
  }
}
