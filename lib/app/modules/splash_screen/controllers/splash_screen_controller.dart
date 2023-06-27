import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayan_status/app/routes/app_pages.dart';
import 'package:swaminarayan_status/constants/api_constants.dart';
import 'package:swaminarayan_status/main.dart';
import 'package:swaminarayan_status/utilities/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../utilities/ad_service.dart';

class SplashScreenController extends GetxController {
  RxBool isFirstTime = true.obs;
  RxBool isAddShow = false.obs;
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FireController().adsVisible().then((value) {
        isAddShow.value = value;
      });
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.isFirstTime))) {
        isFirstTime.value = box.read(ArgumentConstant.isFirstTime);
      }
      if (isNullEmptyOrFalse(isFirstTime)) {
        Timer(Duration(seconds: 3), () {
          Get.offAllNamed(Routes.HOME);
        });
      } else {
        await initInterstitialAdAds();
      }
    });

    super.onInit();
  }

  time() async {
    (!isAddShow.isTrue)
        ? await Timer(Duration(seconds: 8), () async {
            await initInterstitialAdAds();
          })
        : await Timer(Duration(seconds: 5), () async {
            Get.offAllNamed(Routes.HOME);
          });
  }

  // ads() async {
  //   await getIt<AdService>()
  //       .getAd(adType: AdService.interstitialAd)
  //       .then((value) {
  //     if (!value) {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //       Get.offAndToNamed(Routes.HOME);
  //     } else {
  //       Future.delayed(Duration(seconds: 5)).then((value) {
  //         SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //         Get.offAndToNamed(Routes.HOME);
  //       });
  //     }
  //   }).catchError((error) {
  //     print("Error := $error");
  //   });
  // }

  initInterstitialAdAds() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) async {
            interstitialAd = ad;
            isAdLoaded.value = true;
            if (!isNullEmptyOrFalse(isAddShow.value)) {
              if (isAdLoaded.value) {
                interstitialAd!.show().then((value) {
                  Get.offAllNamed(Routes.HOME);
                });
              } else {
                Get.offAllNamed(Routes.HOME);
              }
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          },
          onAdFailedToLoad: (error) {
            Get.offAllNamed(Routes.HOME);
            interstitialAd!.dispose();
          },
        ));
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
