import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/login_controller.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/theam/button_them.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/ui/auth/signup/signup_screen.dart';
import 'package:quicklai/ui/dash_board/dashboard.dart';
import 'package:quicklai/ui/forgot_password/forgot_password_screen.dart';
import 'package:quicklai/ui/subscription/subscription_screen.dart';
import 'package:quicklai/utils/Preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreenUiOne extends StatelessWidget {
  final String redirectType;

  const LoginScreenUiOne({Key? key, required this.redirectType}) : super(key: key);

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
              backgroundColor: ConstantColors.background,
              body: Sizer(builder: (context, orientation, deviceType) {
                return Stack(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          width: 40.w,
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5.h),
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text('Welcome Back'.tr, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                            Text('Login to you existing account.'.tr, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w400)),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              'Email Id'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: TextFieldThem.boxBuildTextField(
                                  hintText: 'Email Id'.tr,
                                  controller: controller.emailController.value,
                                  validators: (p0) => Constant().validateEmail(p0),
                                )),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'password'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                                child: TextFieldThem.boxBuildTextField(
                                  suffixData: IconButton(
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
                                  hintText: 'password'.tr,
                                  controller: controller.passwordController.value,
                                  obscureText: controller.passwordVisible.value,
                                  validators: (String? value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return '*required'.tr;
                                    }
                                  },
                                )),
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
                                    style: TextStyle(color: ConstantColors.orange),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            ButtonThem.buildBorderButton(
                              context,
                              title: 'Login'.tr,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              iconVisibility: false,
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
                              btnBorderColor: ConstantColors.primary,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: Platform.isAndroid,
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: "Login with google",
                                btnColor: Colors.white,
                                txtColor: Colors.black,
                                iconVisibility: true,
                                iconAssetImage: 'assets/icons/ic_google.png',
                                onPress: () async {
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
                                btnBorderColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                                visible: Platform.isIOS,
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: "Login with apple",
                                  btnColor: Colors.black,
                                  txtColor: Colors.white,
                                  iconVisibility: true,
                                  iconAssetImage: 'assets/icons/ic_apple.png',
                                  onPress: () async {
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
                                  btnBorderColor: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.h, right: 2.h),
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            await Constant().getDeviceId().then((value) async {
                              log("------>$value");
                              Map<String, String> bodyParams = {'device_id': value.toString(), 'fcmtoken': controller.notificationToken.value};
                              await controller.guestAPI(bodyParams).then((value) {
                                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                Preferences.setString(Preferences.gustUser, jsonEncode(value));
                                Preferences.setString(Preferences.deviceId, value!.data!.deviceId.toString());
                                Preferences.setBoolean(Preferences.isLogin, false);
                                Get.off(const DashBoard());
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: ConstantColors.primary, shape: const StadiumBorder()),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 2.w),
                            child: Text('skip'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.all(2.w),
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
              ),
            ),
          );
        });
  }
}
