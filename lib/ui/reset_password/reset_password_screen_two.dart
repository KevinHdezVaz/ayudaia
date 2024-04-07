import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/controller/reset_password_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/theam/text_field_them.dart';
import 'package:quicklai/theam/text_field_widget.dart';
import 'package:quicklai/utils/Preferences.dart';

class ResetPasswordScreenTwo extends StatelessWidget {
  const ResetPasswordScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ResetPasswordController>(
        init: ResetPasswordController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(title: Text('Change Password'.tr), backgroundColor: ConstantColors.grey01, centerTitle: false),
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Form(
                  key: controller.formKey.value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        title: 'New Password',
                        hintText: 'Enter New Password',
                        controller: controller.passwordController.value,
                        onPress: () {},
                        prefix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset("assets/images/ic_loack.svg", width: 22, height: 22),
                        ),
                      ),
                      TextFieldWidget(
                        title: 'Confirm new password',
                        hintText: 'Confirm new password',
                        controller: controller.conformPasswordController.value,
                        onPress: () {},
                        prefix: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset("assets/images/ic_loack.svg", width: 22, height: 22),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.formKey.value.currentState!.validate()) {
                              if (controller.passwordController.value.text == controller.conformPasswordController.value.text) {
                                Map<String, String> bodyParams = {
                                  'user_id': Preferences.getString(Preferences.userId),
                                  'password': controller.passwordController.value.text,
                                };
                                await controller.resetPassword(bodyParams).then((value) {
                                  if (value != null) {
                                    if (value == true) {
                                      Get.back(result: true);
                                    } else {
                                      ShowToastDialog.showToast('Something want wrong...'.tr);
                                    }
                                  }
                                });
                              } else {
                                ShowToastDialog.showToast("Password doesn't match".tr);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: ConstantColors.primary, shape: const StadiumBorder()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                            child: Text('Login'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
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
