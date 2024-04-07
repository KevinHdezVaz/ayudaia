import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/writer_screen_controller.dart';
import 'package:quicklai/model/suggestion_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/responsive.dart';
import 'package:quicklai/ui/history/history_screen/history_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/ui/writer_screen/writer_details_screen/writer_details_screen.dart';
import 'package:quicklai/utils/Preferences.dart';

class WriterScreenTwo extends StatelessWidget {
  const WriterScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<WriterScreenController>(
        init: WriterScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(title: Text(controller.categoryData.value.name.toString()), backgroundColor: ConstantColors.grey01, centerTitle: false, actions: [
              Visibility(
                visible: Preferences.getBoolean(Preferences.isLogin),
                child: InkWell(
                  onTap: () {
                    Get.to(const HistoryScreen(), arguments: {
                      "categoryId": controller.categoryData.value.id.toString(),
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.history),
                  ),
                ),
              )
            ]),
            body: Container(
              height: Responsive.height(100, context),
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: controller.selectedSuggestion.isEmpty,
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: controller.textController.value,
                              maxLines: null,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  controller.isSelected.value = true;
                                } else {
                                  controller.isSelected.value = false;
                                }
                              },
                              onSubmitted: (value) {
                                controller.selectedSuggestion.value = value;
                              },
                              decoration: InputDecoration(hintText: 'How can I help you?'.tr, hintStyle: TextStyle(color: ConstantColors.hintTextColor, fontSize: 18), border: InputBorder.none),
                            ),
                          ),
                          textEditor(controller.selectedSuggestion.value, controller),
                          Expanded(
                            child: Visibility(
                              visible: controller.selectedSuggestion.isEmpty,
                              child: controller.isLoading.value
                                  ? const Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: controller.suggestionList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        SuggestionData suggestion = controller.suggestionList[index];
                                        List<String> newArray = suggestion.name!.split('~');
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: InkWell(
                                            onTap: () {
                                              controller.isSelected.value = true;
                                              controller.textController.value.clear();
                                              controller.selectedSuggestion.value = suggestion.name.toString();
                                              List<String> newArray = suggestion.name!.split('~');
                                              controller.stringList.addAll(newArray);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: ConstantColors.grey02,
                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Wrap(
                                                      children: List.generate(newArray.length, (index) {
                                                    return newArray[index].startsWith('#')
                                                        ? Text(
                                                            newArray[index].replaceAll('#', ""),
                                                            style: TextStyle(color: ConstantColors.hintTextColor, fontSize: 16),
                                                          )
                                                        : Text(
                                                            newArray[index],
                                                            style: const TextStyle(color: Colors.white, fontSize: 16),
                                                          );
                                                  })),
                                                )),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () async {
                                log(controller.textController.value.text);
                                log(controller.stringList.join().replaceAll('#', ''));
                                if (controller.textController.value.text.isNotEmpty) {
                                  if (controller.writerLimit.value == "0" && Constant.isActiveSubscription == false) {
                                    ShowToastDialog.showToast('Your free limit is over.Please subscribe to package to get unlimited limit'.tr);
                                    Get.to(const SubscriptionScreen());
                                  } else {
                                    Get.off(const WriterDetailsScreen(), arguments: {
                                      "pramot": controller.textController.value.text,
                                      "category": controller.categoryData.value,
                                    });
                                  }
                                } else if (controller.stringList.isNotEmpty) {
                                  if (controller.writerLimit.value == "0" && Constant.isActiveSubscription == false) {
                                    ShowToastDialog.showToast('Your free limit is over.Please subscribe to package to get unlimited limit'.tr);
                                    Get.to(const SubscriptionScreen());
                                  } else {
                                    Get.off(const WriterDetailsScreen(), arguments: {
                                      "pramot": controller.stringList.join().replaceAll('#', ''),
                                      "category": controller.categoryData.value,
                                    });
                                  }
                                } else {
                                  ShowToastDialog.showToast('Please enter or select value'.tr);
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: controller.isSelected.value == false ? Colors.grey : ConstantColors.primary,
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Center(
                                    child: Text(
                                      'Send'.tr,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: Constant.isActiveSubscription == true ? false : true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${'You have'.tr} ${controller.writerLimit} ${'free messages left.'.tr}", style: const TextStyle(color: Colors.white)),
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget textEditor(String selectedData, WriterScreenController controller) {
    List<String> newArray = selectedData.split('~');
    return Row(
      children: [
        Expanded(
          child: Wrap(
              spacing: 5,
              runSpacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(newArray.length, (index) {
                return newArray[index].startsWith('#')
                    ? IntrinsicWidth(
                        child: TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        onChanged: (value) {
                          controller.stringList.removeAt(index);
                          controller.stringList.insert(index, value);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          hintStyle: TextStyle(color: ConstantColors.subTitleTextColor),
                          hintText: newArray[index].replaceAll("#", ''),
                          fillColor: ConstantColors.cardViewColor,
                          filled: true,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent)),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent)),
                        ),
                      ))
                    : IntrinsicWidth(
                        child: Text(
                          newArray[index],
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
              })),
        ),
      ],
    );
  }
}
