import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/controller/history_controller.dart';
import 'package:quicklai/model/history_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/history/history_details/history_details_screen.dart';
import 'package:quicklai/widget/custom_alert_dialog.dart';

class HistoryScreenTwo extends StatelessWidget {
  const HistoryScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<HistoryController>(
        init: HistoryController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(backgroundColor: ConstantColors.grey01, centerTitle: false,title: Text('History'.tr)),
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.historyList.isEmpty
                        ? Center(
                            child: Text("No record found".tr, style: TextStyle(color: ConstantColors.subTitleTextColor)),
                          )
                        : ListView.builder(
                            itemCount: controller.historyList.length,
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
          );
        });
  }
}
