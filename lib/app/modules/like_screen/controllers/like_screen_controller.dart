import 'dart:convert';

import 'package:swaminarayan_status/constants/sizeConstant.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class LikeScreenController extends GetxController {
  RxList likeList = RxList([]);
  RxList<dailyThoughtModel> likePost = RxList<dailyThoughtModel>([]);
  RxList<dailyThoughtModel> post = RxList<dailyThoughtModel>([]);
  HomeController? homeController;

  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList.value =
          (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
    }

    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();
    update();
    if (getIt<TimerService>().is40SecCompleted) {
      ads();
    }
    // Yodo1MAS.instance.setInterstitialListener((event, message) {
    //   switch (event) {
    //     case Yodo1MAS.AD_EVENT_OPENED:
    //       print('Interstitial AD_EVENT_OPENED');
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //       break;
    //     case Yodo1MAS.AD_EVENT_ERROR:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.back();
    //       print('Interstitial AD_EVENT_ERROR' + message);
    //       break;
    //     case Yodo1MAS.AD_EVENT_CLOSED:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       Get.back();
    //       break;
    //   }
    // });

    super.onInit();
  }

  Future<void> ads() async {
    await getIt<AdService>()
        .getAd(
      adType: AdService.interstitialAd,
    )
        .then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.back();
      }
    }).catchError((error) {
      print("Error := $error");
    });
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
