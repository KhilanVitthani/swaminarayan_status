import 'dart:convert';

import 'package:buddha_mindfulness/constants/sizeConstant.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';

class LikeScreenController extends GetxController {
  RxList likeList = RxList([]);
  RxList<dailyThoughtModel> likePost = RxList<dailyThoughtModel>([]);
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList.value =
          (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }
    // Yodo1MAS.instance.setInterstitialListener((event, message) {
    //   switch (event) {
    //     case Yodo1MAS.AD_EVENT_OPENED:
    //       print('Interstitial AD_EVENT_OPENED');
    //       break;
    //     case Yodo1MAS.AD_EVENT_ERROR:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.offAndToNamed(Routes.HOME);
    //       print('Interstitial AD_EVENT_ERROR' + message);
    //       break;
    //     case Yodo1MAS.AD_EVENT_CLOSED:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.offAndToNamed(Routes.HOME);
    //
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
