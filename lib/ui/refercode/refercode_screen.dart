import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/refercode_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:sizer/sizer.dart';

class ReferCodeScreen extends StatelessWidget {
  const ReferCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ReferCodeController>(
        init: ReferCodeController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: controller.isLoading.value == true
                ? const Center(child: CircularProgressIndicator())
                : controller.userModel.value.data?.referralCode == null
                    ? Center(
                        child: Text(
                          "Something want wrong".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/referBG.png'), fit: BoxFit.cover)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 55),
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Image.asset(
                                          'assets/images/referIcon.png',
                                          fit: BoxFit.contain,
                                          width: 30.w,
                                        ),
                                        const SizedBox(
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 18),
                                      Text(
                                        "Invite Friend & Businesses".tr,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 2.0, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      Text(
                                        "${"Invite QuicklAi to sign up using your code and you’ll get".tr} ${controller.userModel.value.data!.refferedLimit.toString()} ${"search limit".tr}",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white, //Color(0XFF666666),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 2.0),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            FlutterClipboard.copy(controller.userModel.value.data!.referralCode!.toString()).then((value) {
                                              SnackBar snackBar = SnackBar(
                                                content: Text(
                                                  "Coupon code copied".tr,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: Colors.green,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            });
                                          },
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            padding: const EdgeInsets.all(16),
                                            color: const Color(0xff807890),
                                            strokeWidth: 1.5,
                                            dashPattern: const [3],
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              child: Container(
                                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(controller.userModel.value.data!.referralCode!.toString(),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily: "Poppins",
                                                              fontWeight: FontWeight.bold,
                                                              letterSpacing: 0.5,
                                                              color: ConstantColors.primary) //ConstantColors.primary),
                                                          ),
                                                      Text('Tap to Copy'.tr,
                                                          textAlign: TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, letterSpacing: 0.5, color: Colors.white) //ConstantColors.primary),
                                                          ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Column(
                                        children: [
                                          referIconTile(icons: 'assets/images/linkIcon.png', title: 'Invite a Friend'.tr),
                                          referIconTile(icons: 'assets/images/addFriend.png', title: 'They Register'.tr),
                                          referIconTile(icons: 'assets/images/icreaseSearch.png', title: 'Increase Search Limit'.tr)
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 26.sp),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ConstantColors.primary, //ConstantColors.primary,
                                              padding: const EdgeInsets.only(top: 12, bottom: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                side: BorderSide(color: ConstantColors.primary //ConstantColors.primary,
                                                    ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              ShowToastDialog.showLoader('Please wait'.tr);
                                              controller.share();
                                            },
                                            child: Text(
                                              'Refer a Friend'.tr,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: 55.w,
                            child: Container(
                              decoration: BoxDecoration(color: ConstantColors.primary, borderRadius: BorderRadius.circular(10)),
                              width: 90.w,
                              height: 22.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Refer your friends and".tr,
                                    style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
                                  ),
                                  Text(
                                    "Increase Search Limit".tr,
                                    style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          );
        });
  }

  Widget referIconTile({required icons, required title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 14),
          child: Image.asset(
            icons,
            fit: BoxFit.contain,
            width: 13.w,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontFamily: "Poppins", fontWeight: FontWeight.w500, letterSpacing: 0.5, color: Colors.white) //ConstantColors.primary),
              ),
        ),
      ],
    );
  }
}
