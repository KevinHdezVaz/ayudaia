import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/constant/show_toast_dialog.dart';
import 'package:quicklai/model/ai_responce_model.dart';
import 'package:quicklai/model/chat.dart';
import 'package:quicklai/model/guest_model.dart';
import 'package:quicklai/model/reset_limit_model.dart';
import 'package:quicklai/model/user_model.dart';
import 'package:quicklai/service/api_services.dart';
import 'package:quicklai/utils/Preferences.dart';

class AstrologyController extends GetxController {
  final scrollController = ScrollController();
  var lastQues = ''.obs;
  var lastAns = ''.obs;

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  BannerAd? bannerAd;
  RxBool bannerAdIsLoaded = false.obs;

  loadAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Constant().getBannerAdUnitId().toString(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            log('$BannerAd loaded.');
            bannerAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            log('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();
  }

  RxBool isLoading = true.obs;

  RxList chatList = <Chat>[].obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;

  RxBool isClickable = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    loadAd();
    // loadInterstitiaAd();
    getUser();
    if (Preferences.getBoolean(Preferences.isLogin)) {
      isLoading.value = false;
      // getChat();
    } else {
      isLoading.value = false;
    }
    messageController.value.text =
        "Act as an astrologer. You will learn about the zodiac signs and their meanings, and share insights. My first sentence is I'm a Gemini, how will my day go in terms of love, money, mood?"
            .tr;
    // writerLimit.value = '10';
    super.onInit();
  }

  // late AdmobInterstitial interstitialAd;
  //
  // loadInterstitiaAd() {
  //   interstitialAd = AdmobInterstitial(
  //     adUnitId: Constant().getInterstitialAdUnitId()!,
  //     listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
  //       if (event == AdmobAdEvent.closed) interstitialAd.load();
  //       handleEvent(event, args, 'Interstitial');
  //     },
  //   );
  //   interstitialAd.load();
  // }
  //
  // void handleEvent(
  //     AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       break;
  //     case AdmobAdEvent.opened:
  //       break;
  //     case AdmobAdEvent.closed:
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       break;
  //     default:
  //   }
  // }

  RxString writerLimit = "0".obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<GuestModel> guestUserModel = GuestModel().obs;

  getUser() {
    if (Preferences.getBoolean(Preferences.isLogin)) {
      userModel.value = Constant.getUserData();
      writerLimit.value = userModel.value.data!.writerLimit.toString();
    } else {
      guestUserModel.value = Constant.getGuestUser();
      writerLimit.value = guestUserModel.value.data!.writerLimit.toString();
    }
  }

  Future sendResponse(String message) async {
    try {
      ShowToastDialog.showLoader('Please wait'.tr);
      lastQues.value = message;

      Map<String, dynamic> bodyParams = {
        'model': Constant.modelType,
        'messages': [
          {"role": "user", "content": message}
        ],
      };

      final response = await http.post(Uri.parse(ApiServices.completions),
          headers: ApiServices.headerOpenAI, body: jsonEncode(bodyParams));
      log(response.statusCode.toString());
      log(response.body);

      Map<String, dynamic> responseBody =
          json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        // ShowToastDialog.closeLoader();

        AiResponceModel aiResponceModel =
            AiResponceModel.fromJson(responseBody);
        if (aiResponceModel.choices != null &&
            aiResponceModel.choices!.isNotEmpty) {
          Chat chat = Chat(
              msg: aiResponceModel.choices!.first.message!.content.toString(),
              chat: "1");
          lastAns.value =
              aiResponceModel.choices!.first.message!.content.toString();
          chatList.add(chat);
          messageController.value.clear();
          await promsWordCountPost(
              response:
                  aiResponceModel.choices!.first.message!.content.toString());

          if (Constant.isActiveSubscription == false) {
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await savePrompt();
              await resetWriterLimit();
            } else {
              await resetGuestWriterLimit();
            }
          } else {
            ShowToastDialog.closeLoader();
            if (Preferences.getBoolean(Preferences.isLogin)) {
              await savePrompt();
            }
          }

          Future.delayed(const Duration(milliseconds: 50))
              .then((_) => scrollDown());
        } else {
          ShowToastDialog.showToast('Resource not found.'.tr);
        }
      } else {
        Map<String, dynamic> responseBody = json.decode(response.body);

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']['message']);
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future savePrompt() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'category_id': '1',
        'category_name': 'Astrology',
        'subject': lastQues.value,
        'answer': lastAns.value,
      };
      final response = await http.post(Uri.parse(ApiServices.savePromsHistory),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        return true;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> promsWordCountPost({required String response}) async {
    var stringWordList = response.split(' ');
    var totalWord = stringWordList.length.toString();
    try {
      Map<String, dynamic> bodyParams = {
        'user_type':
            Preferences.getBoolean(Preferences.isLogin) ? "app" : "guest",
        'user_id': Preferences.getBoolean(Preferences.isLogin)
            ? Preferences.getString(Preferences.userId)
            : "",
        'device_id': Preferences.getBoolean(Preferences.isLogin) == false
            ? Preferences.getString(Preferences.deviceId)
            : "",
        'type': 'writer',
        'proms_word_count': totalWord
      };

      log(bodyParams.toString());
      final response = await http.post(Uri.parse(ApiServices.promsCountPostUrl),
          headers: ApiServices.authHeader, body: jsonEncode(bodyParams));
      log(response.request.toString());
      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ShowToastDialog.closeLoader();
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['message']);
      } else {
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        ShowToastDialog.closeLoader();
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<ResetLimitModel?> resetWriterLimit() async {
    try {
      Map<String, String> bodyParams = {
        'user_id': Preferences.getString(Preferences.userId),
        'type': 'writer',
      };
      // ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.resetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ResetLimitModel resetLimitModel =
            ResetLimitModel.fromJson(responseBody);
        await Constant().getUser();
        getUser();
        ShowToastDialog.closeLoader();
        return resetLimitModel;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<ResetLimitModel?> resetGuestWriterLimit() async {
    try {
      Map<String, String> bodyParams = {
        'device_id': Preferences.getString(Preferences.deviceId),
        'type': 'writer',
      };
      // ShowToastDialog.showLoader('Please wait'.tr);
      final response = await http.post(Uri.parse(ApiServices.guestResetLimit),
          headers: ApiServices.header, body: jsonEncode(bodyParams));

      log(response.body);
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "Success") {
        ResetLimitModel resetLimitModel =
            ResetLimitModel.fromJson(responseBody);
        await Constant().getGuestUserAPI();
        getUser();
        ShowToastDialog.closeLoader();
        return resetLimitModel;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later'.tr);
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Rx<FlutterTts> flutterTts = FlutterTts().obs;
  Rx<Chat> chatItem = Chat(msg: '', chat: '').obs;

  Future speak({required Chat speechText, required int index}) async {
    flutterTts.value = FlutterTts();
    flutterTts.value.setSpeechRate(0.5);
    flutterTts.value.setVolume(1.0);
    flutterTts.value.setPitch(0.1);
    await flutterTts.value.speak(speechText.msg.toString());
    flutterTts.value.setCompletionHandler(() {
      log(":::::::::::::SPEAK:::::::::::");
      chatList[index].active = false;
      update();
    });
  }

  updateIcon() {
    for (var element in chatList) {
      element.active = false;
    }
    flutterTts.value.stop();
    update();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    flutterTts.value.stop();
    flutterTts.value = FlutterTts();
  }
}
