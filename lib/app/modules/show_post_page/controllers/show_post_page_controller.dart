import 'dart:convert';

import 'package:swaminarayan_status/app/models/daily_thought_model.dart';
import 'package:swaminarayan_status/constants/api_constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

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

  @override
  void onInit() {
    if (Get.arguments != null) {
      postData = Get.arguments[ArgumentConstant.post];
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
      isFromLike.value = Get.arguments[ArgumentConstant.isFromLike];
      print(postData!.videoThumbnail);
    }
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.network(postData!.mediaLink!),
      ).obs;
    }
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.likeList))) {
      likeList = (jsonDecode(box.read(ArgumentConstant.likeList))).toList();
      if(likeList.contains(postData!.uId)){
        postData!.isLiked!.value = true;
      }
    }
    if (getIt<TimerService>().is40SecCompleted) {
      ads();
    }
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.back();
          print('Interstitial AD_EVENT_ERROR' + message);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.back();
          break;
      }
    });
    super.onInit();
  }
  //
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
  void dispose() {
    super.dispose();
  }

  addDataToLike({
    required String data,
  }) {
    likeList.add(data);
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    print(box.read(ArgumentConstant.likeList));
  }

  removeDataToLike({required String data}) {
    likeList.remove(data);
    box.write(ArgumentConstant.likeList, jsonEncode(likeList));
    print(box.read(ArgumentConstant.likeList));
  }

  @override
  void onClose() {
    super.onClose();
    if (!isNullEmptyOrFalse(postData!.videoThumbnail)) {
      flickManager!.value.dispose();
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
