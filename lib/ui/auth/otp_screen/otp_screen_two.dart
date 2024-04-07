import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/otp_controller.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/theam/button_them.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/dash_board/dashboard.dart';
import 'package:quicklai/utils/Preferences.dart';

class OTPScreenTwo extends StatelessWidget {
  final Map<String, String> bodyParams;

  const OTPScreenTwo({Key? key, required this.bodyParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(
        init: OtpController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text('Verify Your Email'.tr, textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('We\'ve sent a verification link to your email. Click the link to confirm your email and unlock the full potential of Quickl.'.tr,
                            textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 40,
                        ),
                        OTPTextField(
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 50,
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          onChanged: (value) {
                            controller.otp.value = value;
                          },
                          otpFieldStyle: OtpFieldStyle(borderColor: Colors.white, disabledBorderColor: Colors.white, enabledBorderColor: Colors.white, focusBorderColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: 'Verify and Continue'.tr,
                          btnColor: ConstantColors.blue04,
                          txtColor: Colors.white,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (controller.otp.value.isEmpty) {
                              ShowToastDialog.showToast("Please enter password");
                            } else {
                              Map<String, String> finalBodyParams = bodyParams;
                              finalBodyParams.addAll({'otp': controller.otp.value});
                              await controller.signUpAPI(finalBodyParams).then((value) {
                                if (value != null) {
                                  if (value.success == "Success") {
                                    ApiServices.header['accesstoken'] = value.data!.accesstoken.toString();
                                    Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                    Preferences.setString(Preferences.user, jsonEncode(value));
                                    Preferences.setString(Preferences.accessToken, value.data!.accesstoken.toString());
                                    Preferences.setString(Preferences.customerId, value.data!.customerId.toString());
                                    Preferences.setString(Preferences.userId, value.data!.id.toString());
                                    Preferences.setBoolean(Preferences.isLogin, true);

                                    Get.offAll(const DashBoard());
                                  } else {
                                    ShowToastDialog.showToast(value.error);
                                  }
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
