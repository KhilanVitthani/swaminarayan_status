import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayan_status/app/modules/home/controllers/home_controller.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class AllPostScreenController extends GetxController {
  List likeList = [];
  HomeController? homeController;
  RxBool isAddShow = false.obs;
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  @override
  void onInit() {
    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
        likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
      }
      await FireController().adsVisible().then((value) async {
        isAddShow.value = value;
        await getIt<AdService>().initBannerAds();
        getIt<TimerService>().verifyTimer();
      });
      update();
      if (getIt<TimerService>().is40SecCompleted) {
        await initInterstitialAdAds();
      }
    });
    super.onInit();
  }

  initInterstitialAdAds() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-8608272927918158/3845433861",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isAdLoaded.value = true;
            if (!isNullEmptyOrFalse(isAddShow.value)) {
              if (isAdLoaded.value) {
                interstitialAd!.show().then((value) {
                  getIt<TimerService>().verifyTimer();
                });
              }
            }
          },
          onAdFailedToLoad: (error) {
            getIt<TimerService>().verifyTimer();
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
    if (!isNullEmptyOrFalse(isAddShow.value)) {
      if (isAdLoaded.value) {
        interstitialAd!.dispose();
      }
      if (getIt<AdService>().isBannerLoaded.isTrue) {
        getIt<AdService>().bannerAd!.dispose();
      }
    }
    super.onClose();
  }
}
