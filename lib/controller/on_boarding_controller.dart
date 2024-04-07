import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quicklai/model/onboarding_model.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  List<OnboardingModel> onBoardingList = [
    OnboardingModel('assets/images/intro_1.gif', 'Quickl is intended to boost your productivity by quick access to information.'.tr, 'Your AI assistant'.tr),
    OnboardingModel('assets/images/intro_2.gif', 'Quickl understand and response to your messages in a natural way.'.tr, 'Human-like Conversations'.tr),
    OnboardingModel('assets/images/intro_3.gif', 'I can write your essays, emails, code, text and more.'.tr, 'I can do anything'.tr),
  ];

  List<OnboardingModel> onBoardingList2 = [
    OnboardingModel('assets/images/intro_image_1.png', 'Quickl empowers you with AI-generated Images, Code, Email Writing, Q&A assistance, and more.'.tr,
        'Welcome to Quickl: Your Multi-Functional AI Companion'.tr),
    OnboardingModel('assets/images/intro_image_2.png', 'Experience the future with Quickl - your hub for AI-crafted Images, Coding assistance, Email composition, and more. '.tr,
        'Unlock Possibilities with Quickl: AI-Generated Images and Beyond'.tr),
    OnboardingModel('assets/images/intro_image_3.png', 'Design with AI, code efficiently, compose emails magically, and get expert answers at your fingertips.'.tr,
        'Quickl Invites You: Create, Code, Communicate with AI'.tr),
  ];
}
