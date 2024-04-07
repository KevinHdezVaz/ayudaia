import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/login_controller.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/theam/button_them.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_widget.dart';
import 'package:quicklai/ui/auth/signup/signup_screen.dart';
import 'package:quicklai/ui/dash_board/dashboard.dart';
import 'package:quicklai/ui/forgot_password/forgot_password_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreenUiTwo extends StatelessWidget {
  final String redirectType;

  const LoginScreenUiTwo({Key? key, required this.redirectType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              body: Sizer(builder: (context, orientation, deviceType) {
                return Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 6.h, right: 3.h),
                                child: InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();

                                      await Constant().getDeviceId().then((value) async {
                                        log("------>$value");
                                        Map<String, String> bodyParams = {'device_id': value.toString(), 'fcmtoken': controller.notificationToken.value};
                                        await controller.guestAPI(bodyParams).then((value) {
                                          Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                          Preferences.setString(Preferences.gustUser, jsonEncode(value));
                                        //  Preferences.setString(Preferences.deviceId, value!.data!.deviceId.toString());
                                          Preferences.setString(Preferences.deviceId, value?.data?.deviceId?.toString() ?? '');

                                          Preferences.setBoolean(Preferences.isLogin, false);
                                          Get.off(const DashBoard());
                                        });
                                      });
                                    },
                                    child: Text('Skip'.tr, style: GoogleFonts.wixMadeforText(fontSize: 16, fontWeight: FontWeight.w400, color: ConstantColors.grey06))),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5.h),
                              child: SingleChildScrollView(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10.h),
                                    Text('Welcome Back to Quickl AI'.tr, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text('Log in to your Quickl AI account and continue exploring the world of AI-generated images, code, emails, and more..'.tr,
                                        textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 12.sp, fontWeight: FontWeight.w400)),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    TextFieldWidget(
                                      title: 'Email Id',
                                      hintText: 'Enter Email Address',
                                      controller: controller.emailController.value,
                                      onPress: () {},
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                                      ),
                                    ),
                                    TextFieldWidget(
                                      title: 'Password',
                                      hintText: 'Enter Password',
                                      controller: controller.passwordController.value,
                                      onPress: () {},
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SvgPicture.asset("assets/icons/ic_locak.svg", width: 22, height: 22),
                                      ),
                                      suffix: IconButton(
                                        onPressed: () {
                                          controller.passwordVisible.value = !controller.passwordVisible.value;
                                          // ignore: invalid_use_of_protected_member
                                          controller.refresh();
                                        },
                                        icon: Icon(
                                          controller.passwordVisible.value ? Icons.visibility_outlined : Icons.visibility_off,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(const ForgotPasswordScreen());
                                          },
                                          child: Text(
                                            'Forgot Password?'.tr,
                                            textAlign: TextAlign.end,
                                            style: GoogleFonts.wixMadeforText(color: ConstantColors.blue05),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    ButtonThem.buildButton(
                                      context,
                                      title: 'Login'.tr,
                                      btnColor: ConstantColors.blue04,
                                      txtColor: Colors.white,
                                      onPress: () async {
                                        FocusScope.of(context).unfocus();
                                        if(controller.emailController.value.text.isEmpty){
                                          ShowToastDialog.showToast("Please enter email");
                                        }else if(controller.passwordController.value.text.isEmpty){
                                          ShowToastDialog.showToast("Please enter password");
                                        }else{
                                          Map<String, String> bodyParams = {
                                            'email': controller.emailController.value.text,
                                            'password': controller.passwordController.value.text,
                                            'fcmtoken': controller.notificationToken.value
                                          };
                                          await controller.loginAPI(bodyParams).then((value) {
                                            if (value != null) {
                                              if (value.success == "Success") {
                                                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                                Preferences.setString(Preferences.user, jsonEncode(value));
                                                Preferences.setString(Preferences.accessToken, value.data!.accesstoken.toString());
                                                Preferences.setString(Preferences.customerId, value.data!.customerId.toString());
                                                Preferences.setString(Preferences.userId, value.data!.id.toString());
                                                Preferences.setBoolean(Preferences.isLogin, true);
                                                ApiServices.header['accesstoken'] = value.data!.accesstoken.toString();

                                                if (redirectType == "subscription") {
                                                  Get.off(const SubscriptionScreen());
                                                } else {
                                                  Get.offAll(const DashBoard());
                                                }
                                              } else {
                                                ShowToastDialog.showToast(value.error);
                                              }
                                            }
                                          });
                                        }

                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: ConstantColors.grey02,
                                            ),
                                          ),
                                          Text("OR SIGN IN WITH", style: TextStyle(color: ConstantColors.grey05)),
                                          Expanded(
                                            child: Divider(
                                              color: ConstantColors.grey02,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: () async {
                                              ShowToastDialog.showLoader("Please wait");
                                              await controller.signInWithApple().then((value) async {
                                                ShowToastDialog.closeLoader();
                                                // ignore: unnecessary_null_comparison
                                                if (value != null) {
                                                  Map<String, String> bodyParams = {
                                                    'name': value.user!.displayName.toString(),
                                                    'email': value.user!.email.toString(),
                                                    'photo': value.user!.photoURL.toString(),
                                                    'fcmtoken': controller.notificationToken.value
                                                  };
                                                  await controller.socialLoginAPI(bodyParams).then((value) {
                                                    if (value != null) {
                                                      if (value.success == "Success") {
                                                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                                        Preferences.setString(Preferences.user, jsonEncode(value));
                                                        Preferences.setString(Preferences.accessToken, value.data!.accesstoken.toString());
                                                        Preferences.setString(Preferences.customerId, value.data!.customerId.toString());
                                                        Preferences.setString(Preferences.userId, value.data!.id.toString());
                                                        Preferences.setBoolean(Preferences.isLogin, true);
                                                        ApiServices.header['accesstoken'] = value.data!.accesstoken.toString();

                                                        if (redirectType == "subscription") {
                                                          Get.off(const SubscriptionScreen());
                                                        } else {
                                                          Get.offAll(const DashBoard());
                                                        }
                                                      } else {
                                                        ShowToastDialog.showToast(value.error);
                                                      }
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child: SvgPicture.asset("assets/icons/ic_apple_2.svg")),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              ShowToastDialog.showLoader("Please wait");
                                              await controller.signInWithGoogle().then((value) async {
                                                ShowToastDialog.closeLoader();
                                                if (value != null) {
                                                  Map<String, String> bodyParams = {
                                                    'name': value.user!.displayName.toString(),
                                                    'email': value.user!.email.toString(),
                                                    'photo': value.user!.photoURL.toString(),
                                                    'fcmtoken': controller.notificationToken.value
                                                  };
                                                  await controller.socialLoginAPI(bodyParams).then((value) {
                                                    if (value != null) {
                                                      if (value.success == "Success") {
                                                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                                        Preferences.setString(Preferences.user, jsonEncode(value));
                                                        Preferences.setString(Preferences.accessToken, value.data!.accesstoken.toString());
                                                        Preferences.setString(Preferences.customerId, value.data!.customerId.toString());
                                                        Preferences.setString(Preferences.userId, value.data!.id.toString());
                                                        Preferences.setBoolean(Preferences.isLogin, true);
                                                        ApiServices.header['accesstoken'] = value.data!.accesstoken.toString();

                                                        if (redirectType == "subscription") {
                                                          Get.off(const SubscriptionScreen());
                                                        } else {
                                                          Get.offAll(const DashBoard());
                                                        }
                                                      } else {
                                                        ShowToastDialog.showToast(value.error);
                                                      }
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child: SvgPicture.asset("assets/icons/ic_google_2.svg")),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "${"Don't have an account?".tr} ",
                            style: const TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                text: " ${'Register now!'.tr}",
                                style: TextStyle(color: ConstantColors.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(SignupScreen(
                                        redirectType: redirectType,
                                        token: controller.notificationToken.toString(),
                                      )),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
