import 'package:flutter/material.dart';
import 'package:quicklai/constant/constant.dart';
import 'package:quicklai/ui/subscription/subscription_screen_two.dart';
import 'package:sizer/sizer.dart';

import 'subscription_screen_one.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Constant.theme == "theme_1" ? const SubscriptionScreenOne() : const SubscriptionScreenTwo();
    });
  }
}
