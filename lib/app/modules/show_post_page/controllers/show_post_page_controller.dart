import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swaminarayan_status/app/models/daily_thought_model.dart';
import 'package:swaminarayan_status/app/modules/home/controllers/home_controller.dart';
import 'package:swaminarayan_status/constants/api_constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/data_model.dart';
import '../../../routes/app_pages.dart';

class ShowPostPageController extends GetxController {
  dailyThoughtModel? postData;
  VideoPlayerController? videoPlayerController;
  Rx<FlickManager>? flickManager;
  RxBool isFromHome = false.obs;
  RxBool isFromLike = false.obs;
  RxBool isFromDownload = false.obs;
  List likeList = [];
  HomeController? homeController;
  RxInt Index = 0.obs;
  InterstitialAd? interstitialAd;
  RxBool isAdLoaded = false.obs;
  RxBool isAddShow = false.obs;
  @override
  void onInit() async {
    if (Get.arguments != null) {
      // postData = Get.arguments[ArgumentConstant.post];
      Index.value = Get.arguments[ArgumentConstant.index];
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
      isFromLike.value = Get.arguments[ArgumentConstant.isFromLike];
      print(Index);
    }
    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();
    if (!isNullEmptyOrFalse(homeController!.post[Index.value].videoThumbnail)) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            homeController!.post[Index.value].mediaLink!),
      ).obs;
    }
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
      if (likeList.contains(homeController!.post[Index.value].dateTime)) {
        homeController!.post[Index.value].isLiked!.value = true;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FireController().adsVisible().then((value) async {
        isAddShow.value = value;
        await getIt<AdService>().initBannerAds();
        getIt<TimerService>().verifyTimer();
      });
    });

    if (getIt<TimerService>().is40SecCompleted) {
      await initInterstitialAdAds();
    }
    super.onInit();
  }

  //

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
  void dispose() {
    if (!isNullEmptyOrFalse(isAddShow.value)) {
      if (isAdLoaded.value) {
        interstitialAd!.dispose();
      }
      if (getIt<AdService>().isBannerLoaded.isTrue) {
        getIt<AdService>().bannerAd!.dispose();
      }
    }
    super.dispose();
  }

  addDataToLike({
    required String data,
  }) {
    if (!likeList.contains(data)) {
      likeList.add(data);
    }
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    homeController!.post[Index.value].isLiked!.value = true;
    update();

    print(box.read(ArgumentConstant.likeList));
  }

  removeDataToLike({required String data}) {
    if (likeList.contains(data)) {
      likeList.remove(data);
    }

    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    homeController!.post[Index.value].isLiked!.value = false;
    update();
    print(box.read(ArgumentConstant.likeList));
  }

  @override
  void onClose() {
    super.onClose();
    if (!isNullEmptyOrFalse(homeController!.post[Index.value].videoThumbnail)) {
      flickManager!.value.dispose();
    }
  }
}
