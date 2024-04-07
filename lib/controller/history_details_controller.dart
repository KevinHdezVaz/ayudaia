import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicklai/constant/constant.dart';

class HistoryDetailsController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    loadAd();
    super.onInit();
  }

  InterstitialAd? interstitialAd;

  loadAd() {
    InterstitialAd.load(
        adUnitId: Constant().getInterstitialAdUnitId().toString(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            log('$ad loaded');
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('InterstitialAd failed to load: $error.');
            interstitialAd = null;
          },
        ));
  }

  Rx<FlutterTts> flutterTts = FlutterTts().obs;
  RxBool textToSpeechQuesion = false.obs;
  RxBool textToSpeechAnswer = false.obs;
  Future speak({required String speechText}) async {
    flutterTts.value = FlutterTts();
    flutterTts.value.setSpeechRate(0.5);
    flutterTts.value.setVolume(1.0);
    flutterTts.value.setPitch(0.1);
    await flutterTts.value.speak(speechText);
    flutterTts.value.setCompletionHandler(() {
      textToSpeechQuesion.value = false;
      textToSpeechAnswer.value = false;
      update();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    flutterTts.value.stop();
    flutterTts.value = FlutterTts();
  }
}
