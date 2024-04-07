import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicklai/controller/on_boarding_controller.dart';
import 'package:quicklai/theam/constant_colors.dart';
import 'package:quicklai/ui/auth/login/login_screen.dart';
import 'package:quicklai/utils/Preferences.dart';

class OnBoardingScreenTwo extends StatelessWidget {
  const OnBoardingScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: controller.selectedPageIndex,
                          itemCount: controller.onBoardingList2.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      controller.onBoardingList2[index].imageAsset.toString(),
                                    ),
                                  ),
                                ),
                                Text(controller.onBoardingList2[index].heading.toString(),
                                    textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey10, fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                Text(controller.onBoardingList2[index].title.toString(),
                                    textAlign: TextAlign.center, style: GoogleFonts.wixMadeforText(color: ConstantColors.grey06, fontSize: 14, fontWeight: FontWeight.w400)),
                              ],
                            );
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onBoardingList2.length,
                      (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: controller.selectedPageIndex.value == index ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.selectedPageIndex.value == index ? ConstantColors.blue04 : const Color(0xffD4D5E0),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                        Get.off(const LoginScreen(
                          redirectType: "",
                        ));
                      },
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: ConstantColors.blue04, shape: const StadiumBorder()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                        child: Text('Skip'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
