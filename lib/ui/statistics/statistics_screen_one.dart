import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/statistics_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:sizer/sizer.dart';

class StatisticsScreenOne extends StatelessWidget {
  const StatisticsScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<StatisticsController>(
          init: StatisticsController(),
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  title: Text('Statistics'.tr),
                  centerTitle: true),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color(0xff221E2C),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.statisticsData.value.promsRequest == '' && controller.statisticsData.value.chatRequest == '' && controller.statisticsData.value.imageRequest == '')
                          SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("No record found".tr, style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        SizedBox(height: 2.h),
                        rowWiseShowData(
                            firstTitle: 'Proms Request'.tr,
                            firstCount: controller.statisticsData.value.promsRequest,
                            secondTitle: 'Proms Word Count'.tr,
                            secondCount: controller.statisticsData.value.promsWordCount ?? "0"),
                        rowWiseShowData(
                            firstTitle: 'Chat Request'.tr,
                            firstCount: controller.statisticsData.value.chatRequest,
                            secondTitle: 'Chat Word Count'.tr,
                            secondCount: controller.statisticsData.value.chatWordCount ?? "0"),
                        rowWiseShowData(firstTitle: 'Image Request'.tr, firstCount: controller.statisticsData.value.imageRequest ?? "0", secondTitle: '1', secondCount: ''),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget rowWiseShowData({required firstTitle, required firstCount, required secondTitle, required secondCount}) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: statisticTile(title: firstTitle, count: firstCount.toString()),
          ),
          secondTitle == "1" ? const SizedBox() : SizedBox(width: 5.w),
          secondTitle == "1"
              ? const SizedBox()
              : Expanded(
            child: statisticTile(title: secondTitle, count: secondCount.toString()),
          ),
        ],
      ),
    );
  }

  Widget statisticTile({required title, required count}) {
    return Container(
      height: 20.w,
      decoration: BoxDecoration(color: ConstantColors.grey02, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title == "1" ? '' : title,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 4.w),
            Container(
              decoration: BoxDecoration(
                color: title == '1' ? Colors.transparent : const Color(0xff04AC84),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Text(
                  count,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

