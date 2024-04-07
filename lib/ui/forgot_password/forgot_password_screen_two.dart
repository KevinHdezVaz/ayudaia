import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/controller/forgot_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/theam/text_field_widget.dart';

class ForgotPasswordScreenTwo extends StatelessWidget {
  const ForgotPasswordScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ForgotController>(
        init: ForgotController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Stack(
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Platform.isIOS
                          ? const Padding(
                              padding: EdgeInsets.only(left: 15, top: 55),
                              child:
                                  Icon(Icons.arrow_back_ios, color: Colors.white),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(left: 15, top: 40),
                              child: Icon(Icons.arrow_back, color: Colors.white),
                            )),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Form(
                      key: controller.formKey.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text('Secure Your Account'.tr,
                              textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Complete your profile by adding your full name. This will personalize your Quickl experience and help us assist you more effectively.'.tr,
                              textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 40,
                          ),

                          TextFieldWidget(
                            title: 'Email address'.tr,
                            hintText: 'Enter Email address',
                            controller: controller.emailController.value,
                            onPress: () {},
                            prefix: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                if (controller.formKey.value.currentState!
                                    .validate()) {
                                  Map<String, String> bodyParams = {
                                    'email':
                                        controller.emailController.value.text,
                                  };
                                  await controller
                                      .forgotPassword(bodyParams)
                                      .then((value) {
                                    if (value == true) {
                                      Get.back();
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: ConstantColors.blue05,
                                  shape: const StadiumBorder()),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12),
                                child: Text('Forgot Password'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
