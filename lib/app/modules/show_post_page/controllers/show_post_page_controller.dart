import 'dart:convert';

import 'package:swaminarayn_status/app/models/daily_thought_model.dart';
import 'package:swaminarayn_status/constants/api_constants.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
// import 'package:yodo1mas/Yodo1MAS.dart';

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
    }
    // Yodo1MAS.instance.setInterstitialListener((event, message) {
    //   print("object  $event");
    //   switch (event) {
    //     case Yodo1MAS.AD_EVENT_OPENED:
    //       print('Interstitial AD_EVENT_OPENED');
    //       break;
    //     case Yodo1MAS.AD_EVENT_ERROR:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       if (isFromDownload.isTrue) {
    //         Get.back();
    //         isFromDownload.value = false;
    //       } else {
    //         (isFromLike.isTrue)
    //             ? Get.offAndToNamed(Routes.LIKE_SCREEN)
    //             : (isFromHome.isTrue)
    //                 ? Get.offAllNamed(Routes.HOME)
    //                 : Get.offAndToNamed(Routes.ALL_POST_SCREEN);
    //       }
    //       print('Interstitial AD_EVENT_ERROR' + message);
    //       break;
    //     case Yodo1MAS.AD_EVENT_CLOSED:
    //       getIt<TimerService>().verifyTimer();
    //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //       if (isFromDownload.isTrue) {
    //         Get.back();
    //         isFromDownload.value = false;
    //       } else {
    //         (isFromLike.isTrue)
    //             ? Get.offAndToNamed(Routes.LIKE_SCREEN)
    //             : (isFromHome.isTrue)
    //                 ? Get.offAllNamed(Routes.HOME)
    //                 : Get.offAndToNamed(Routes.ALL_POST_SCREEN);
    //       }
    //       break;
    //   }
    // });
    super.onInit();
  }
  //
  // ads() async {
  //   await getIt<AdService>()
  //       .getAd(adType: AdService.interstitialAd)
  //       .then((value) {
  //     if (!value) {
  //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //     }
  //   }).catchError((error) {
  //     print("Error := $error");
  //   });
  // }

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
