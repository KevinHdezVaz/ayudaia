import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/signup_controller.dart';
import 'package:quicklai/theam/button_them.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_widget.dart';
import 'package:quicklai/ui/auth/otp_screen/otp_screen.dart';

class SignupScreenTwo extends StatelessWidget {
  final String? redirectType;
  final String token;

  const SignupScreenTwo({Key? key, required this.token, required this.redirectType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<SignupController>(
        init: SignupController(),
        builder: (controller) {
          return InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Platform.isIOS
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 15, top: 55),
                                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(left: 15, top: 55),
                                  child: Icon(Icons.arrow_back, color: Colors.white),
                                )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Text('Join Quickl and Unleash AI-Powered Creativity!'.tr,
                                  textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Create your Quickl account today to access a suite of AI tools. Craft images, write code, emails, and enhance productivity like never before.'.tr,
                                  textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                              const SizedBox(
                                height: 40,
                              ),

                              TextFieldWidget(
                                title: 'Full Name'.tr,
                                hintText: 'Enter Full name',
                                controller: controller.fullNameController.value,
                                onPress: () {},
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                                ),
                              ),
                              TextFieldWidget(
                                title: 'Email'.tr,
                                hintText: 'Enter Email address',
                                controller: controller.emailController.value,
                                onPress: () {},
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                                ),
                              ),
                              TextFieldWidget(
                                title: 'password'.tr,
                                hintText: 'Enter Password',
                                controller: controller.passwordController.value,
                                onPress: () {},
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset("assets/images/ic_loack.svg", width: 22, height: 22),
                                ),
                              ),
                              TextFieldWidget(
                                title: 'Referral Code (Optional)'.tr,
                                hintText: 'Referral Code',
                                controller: controller.referCodeController.value,
                                onPress: () {},
                                prefix: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                                ),
                              ),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              // Text(
                              //   'password'.tr,
                              //   style: const TextStyle(color: Colors.white),
                              // ),
                              // Padding(
                              //     padding: const EdgeInsets.only(top: 5, bottom: 10),
                              //     child: TextFieldThem.boxBuildTextField(
                              //       suffixData: IconButton(
                              //         onPressed: () {
                              //           controller.passwordVisible.value = !controller.passwordVisible.value;
                              //           // ignore: invalid_use_of_protected_member
                              //           controller.refresh();
                              //         },
                              //         icon: Icon(
                              //           controller.passwordVisible.value ? Icons.visibility_outlined : Icons.visibility_off,
                              //           size: 20,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       hintText: 'password'.tr,
                              //       obscureText: controller.passwordVisible.value,
                              //       controller: controller.passwordController.value,
                              //       validators: (String? value) {
                              //         if (value!.isNotEmpty) {
                              //           return null;
                              //         } else {
                              //           return '*required'.tr;
                              //         }
                              //       },
                              //     )),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              // Text(
                              //   'Referral Code (Optional)'.tr,
                              //   style: const TextStyle(color: Colors.white),
                              // ),
                              // Padding(
                              //     padding: const EdgeInsets.only(top: 5, bottom: 10),
                              //     child: TextFieldThem.boxBuildTextField(
                              //       hintText: 'Referral Code'.tr,
                              //       controller: controller.referCodeController.value,
                              //       validators: (String? value) {
                              //         if (value != null && value != '') {
                              //           if (value.length != 8) {
                              //             return 'Enter Valid Code';
                              //           }
                              //         }
                              //         return null;
                              //       },
                              //     )),
                              // const SizedBox(
                              //   height: 50,
                              // ),
                              ButtonThem.buildButton(
                                context,
                                title: 'Register Now'.tr,
                                btnColor: ConstantColors.blue04,
                                txtColor: Colors.white,
                                onPress: () async {
                                  FocusScope.of(context).unfocus();
                                  if (controller.emailController.value.text.isEmpty) {
                                    ShowToastDialog.showToast("Please enter email");
                                  } else if (controller.passwordController.value.text.isEmpty) {
                                    ShowToastDialog.showToast("Please enter password");
                                  } else {
                                    FocusScope.of(context).unfocus();

                                    if (controller.fullNameController.value.text.isEmpty) {
                                      ShowToastDialog.showToast("Please enter full name".tr);
                                    } else if (controller.emailController.value.text.isEmpty) {
                                      ShowToastDialog.showToast("Please enter email".tr);
                                    } else if (controller.passwordController.value.text.isEmpty) {
                                      ShowToastDialog.showToast("Please enter password".tr);
                                    } else {
                                      Map<String, String> bodyParams = {
                                        'email': controller.emailController.value.text,
                                      };

                                      await controller.sendOtp(bodyParams).then((value) {
                                        if (value != null) {
                                          if (value == true) {
                                            Map<String, String> redirectBodyParams = {
                                              'name': controller.fullNameController.value.text,
                                              'email': controller.emailController.value.text,
                                              'password': controller.passwordController.value.text,
                                              'fcmtoken': token,
                                              'join_by_referral_code': controller.referCodeController.value.text.trim()
                                            };
                                            Get.to(OTPScreen(
                                              bodyParams: redirectBodyParams,
                                            ));
                                          } else {
                                            ShowToastDialog.showToast("Something want wrong".tr);
                                          }
                                        }
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
