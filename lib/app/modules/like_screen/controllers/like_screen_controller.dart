import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayan_status/constants/sizeConstant.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
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
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  RxBool isAddShow = false.obs;
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

  initInterstitialAdAds() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
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
