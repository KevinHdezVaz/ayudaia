import 'dart:async';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/utils/Preferences.dart';

class ReferCodeController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;

  @override
  Future<void> onInit() async {
    getUser();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      isLoading.value = false;
    }
  }

  Future<void> share() async {
    ShowToastDialog.closeLoader();
    await FlutterShare.share(
      title: 'QuicklAi',
      text:
          'Hey there, thanks for choosing QuicklAi. Hope you love our product. If you do, share it with your friends using code ${userModel.value.data?.referralCode.toString()} and get more ${userModel.value.data?.refferedLimit.toString()} search limite when SignUp completed',
    );
  }
}
