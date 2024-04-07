import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/subscription_controller.dart';
import 'package:quicklai/model/customer_subscription_model.dart';
import 'package:quicklai/model/subscription_model.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/auth/login/login_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:quicklai/widget/gradiant_text.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreenTwo extends StatelessWidget {
  const SubscriptionScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetX<SubscriptionController>(
          init: SubscriptionController(),
          builder: (controller) {
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 55, right: 5, bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/icons/ic_close.svg', width: 5.w, semanticsLabel: 'Acme Logo'),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GradientText(
                            'Experience Quickl Without Limits',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Inter Tight',
                              fontWeight: FontWeight.w800,
                            ),
                            gradient: LinearGradient(colors: [
                              Color(0xFFE31A53),
                              Color(0xFFEAA907),
                            ]),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/high_word_limit.svg', width: 5.w, height: 5.h, semanticsLabel: 'Acme Logo'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Unlimited Questions and Answers'.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Get the unlimited questions & answers'.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/unlimited.svg', width: 5.w, height: 5.h, semanticsLabel: 'Acme Logo'.tr),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('High Word Limit '.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('For all the questions & answers'.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/no_ads.svg', width: 5.w, height: 5.h, semanticsLabel: 'Acme Logo'.tr),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Ads Free Experience'.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Get rid all those banners & Videos'.tr,
                                          textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(
                                height: 138,
                                child: ListView.builder(
                                  itemCount: controller.subscriptionList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    SubscriptionData subscriptionData = controller.subscriptionList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      child: InkWell(
                                        onTap: () {
                                          controller.selectedSubscription.value = subscriptionData;
                                        },
                                        child: Obx(
                                          () => Container(
                                            width: 163,
                                            decoration: controller.selectedSubscription.value == subscriptionData
                                                ? BoxDecoration(color: ConstantColors.blue05, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(10)))
                                                : BoxDecoration(color: ConstantColors.grey02, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Visibility(
                                                    visible: subscriptionData.discount != null && subscriptionData.discount != "0",
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                            child: Text(
                                                              "${'Save'.tr} ${subscriptionData.discount}",
                                                              style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Expanded(child: SizedBox()),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        subscriptionData.name.toString().tr,
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                      Text(
                                                        "\$${subscriptionData.price.toString()}",
                                                        style: const TextStyle(color: Colors.white, fontSize: 28),
                                                      ),
                                                    ],
                                                  ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (Preferences.getBoolean(Preferences.isLogin)) {
                              await initPlatformState(controller, controller.selectedSubscription.value);
                            } else {
                              Get.off(const LoginScreen(
                                redirectType: "subscription",
                              ));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: ConstantColors.blue05, shape: BoxShape.rectangle, borderRadius: const BorderRadius.all(Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "Continue".tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse(Constant.privacyPolicy.toString());
                                if (!await launchUrl(uri)) {
                                  throw Exception('Could not launch $uri');
                                }
                              },
                              child: Text("Privacy policy".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final uri = Uri.parse(Constant.termsAndCondition.toString());
                                if (!await launchUrl(uri)) {
                                  throw Exception('Could not launch $uri');
                                }
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  child: Text("Terms & Conditions".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          )
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${'Subscription will be charged to your payment method through your'.tr} ${Platform.isAndroid ? "Google play Belling account".tr : "iTunes Billing account".tr}. ${'your subscription will automatically renew unless canceled at least 24 hours before the end of current period.Mange your subscription in account setting after purchase'.tr}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Future<void> initPlatformState(SubscriptionController controller, SubscriptionData subscriptionData) async {
    try {
      if (Platform.isAndroid) {
        await Purchases.purchaseProduct(subscriptionData.androidSubscriptionKey.toString()).then((value) async {
          log("-------->");
          log(value.toJson().toString());
          CustomerInfo customerInfo = value;
          CustomerSubscriptionModel customerSubscriptionModel = CustomerSubscriptionModel.fromJson(customerInfo.toJson());
          Constant.isActiveSubscription = customerSubscriptionModel.entitlements!.active!.toJson().isNotEmpty;

          if (Constant.isActiveSubscription == true) {
            Map<String, String> bodyParams = {
              'user_id': Preferences.getString(Preferences.userId),
              'subscription_id': subscriptionData.id.toString(),
              'transaction_details': jsonEncode(customerSubscriptionModel.toJson()),
            };
            await controller.sendSubscriptionData(bodyParams);
          }
        });
      } else if (Platform.isIOS) {
        await Purchases.purchaseProduct(subscriptionData.iosSubscriptionKey.toString()).then((value) async {
          log("-------->");
          log(value.toJson().toString());
          CustomerInfo customerInfo = value;
          CustomerSubscriptionModel customerSubscriptionModel = CustomerSubscriptionModel.fromJson(customerInfo.toJson());
          Constant.isActiveSubscription = customerSubscriptionModel.entitlements!.active!.toJson().isNotEmpty;

          if (Constant.isActiveSubscription == true) {
            Map<String, String> bodyParams = {
              'user_id': Preferences.getString(Preferences.userId),
              'subscription_id': subscriptionData.id.toString(),
              'transaction_details': jsonEncode(customerSubscriptionModel.toJson()),
            };
            await controller.sendSubscriptionData(bodyParams);
          }
        });
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast(e.message.toString().tr);
      // Error fetching customer info
    }
  }
}
