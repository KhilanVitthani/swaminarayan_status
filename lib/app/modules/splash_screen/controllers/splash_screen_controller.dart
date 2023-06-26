import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:swaminarayan_status/app/routes/app_pages.dart';
import 'package:swaminarayan_status/constants/api_constants.dart';
import 'package:swaminarayan_status/main.dart';
import 'package:swaminarayan_status/utilities/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../utilities/ad_service.dart';

class SplashScreenController extends GetxController {
  RxBool isFirstTime = true.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FireController().adsVisible().then((value) {
        print(value);
      });
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.isFirstTime))) {
        isFirstTime.value = box.read(ArgumentConstant.isFirstTime);
      }
      if (isNullEmptyOrFalse(isFirstTime)) {
        Timer(Duration(seconds: 3), () {
          Get.offAllNamed(Routes.HOME);
        });
      } else {
        if (!kDebugMode) {
          await ads();
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      }
      Yodo1MAS.instance.setInterstitialListener((event, message) {
        switch (event) {
          case Yodo1MAS.AD_EVENT_OPENED:
            print('Interstitial AD_EVENT_OPENED');
            break;
          case Yodo1MAS.AD_EVENT_ERROR:
            getIt<TimerService>().verifyTimer();
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            Get.offAndToNamed(Routes.HOME);
            print('Interstitial AD_EVENT_ERROR' + message);
            break;
          case Yodo1MAS.AD_EVENT_CLOSED:
            getIt<TimerService>().verifyTimer();
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            Get.offAndToNamed(Routes.HOME);
            break;
        }
      });
    });

    super.onInit();
  }

  time() async {
    (AdService.isVisible.isTrue)
        ? await Timer(Duration(seconds: 8), () async {
            if (!kDebugMode) {
              ads();
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          })
        : await Timer(Duration(seconds: 5), () async {
            Get.offAllNamed(Routes.HOME);
          });
  }

  ads() async {
    await getIt<AdService>()
        .getAd(adType: AdService.interstitialAd)
        .then((value) {
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.offAndToNamed(Routes.HOME);
      } else {
        Future.delayed(Duration(seconds: 5)).then((value) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.offAndToNamed(Routes.HOME);
        });
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
