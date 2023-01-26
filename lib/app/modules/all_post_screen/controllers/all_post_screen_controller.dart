import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class AllPostScreenController extends GetxController {
  List likeList = [];

  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }

    // Yodo1MAS.instance.setInterstitialListener((event, message) {
    //   switch (event) {
    //     case Yodo1MAS.AD_EVENT_OPENED:
    //       print('Interstitial AD_EVENT_OPENED');
    //       break;
    //     case Yodo1MAS.AD_EVENT_ERROR:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.offAllNamed(Routes.HOME);
    //       print('Interstitial AD_EVENT_ERROR' + message);
    //       break;
    //     case Yodo1MAS.AD_EVENT_CLOSED:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.offAllNamed(Routes.HOME);
    //       break;
    //   }
    // });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
