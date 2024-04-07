import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/profile_updation_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/theam/text_field_widget.dart';
import 'package:quicklai/utils/Preferences.dart';

class ProfileUpdateScreenTwo extends StatelessWidget {
  const ProfileUpdateScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileUpdationController>(
        init: ProfileUpdationController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile'.tr), backgroundColor: ConstantColors.grey01, centerTitle: false),
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Form(
                  key: controller.formKey.value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        title: 'Full name',
                        hintText: 'Enter Full name',
                        controller: controller.nameController.value,
                        onPress: () {},
                        prefix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                        ),
                      ),
                      TextFieldWidget(
                        title: 'Email Id',
                        hintText: 'Enter Email Id',
                        controller: controller.emailController.value,
                        enable: false,
                        onPress: () {},
                        prefix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset("assets/icons/ic_email.svg", width: 22, height: 22),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (controller.formKey.value.currentState!.validate()) {
                              Map<String, String> bodyParams = {
                                'name': controller.nameController.value.text,
                                'email': controller.emailController.value.text,
                                'user_id': Preferences.getString(Preferences.userId),
                              };
                              await controller.updateProfile(bodyParams).then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    controller.userModel.value.data!.name = controller.nameController.value.text;
                                    Preferences.setString(Preferences.user, jsonEncode(controller.userModel.value.toJson()));
                                    Get.back();
                                  } else {
                                    ShowToastDialog.showToast("Something want wrong...".tr);
                                  }
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: ConstantColors.blue05, shape: const StadiumBorder()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                            child: Text('Update Profile'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
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
