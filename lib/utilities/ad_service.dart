import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';

import '../constants/firebase_controller.dart';

class AdService {
  static const interstitialAd = "interstitialAd";
  static const bannerAd = "bannerAd";
  static const rewardsAd = "rewardsAd";
  static RxBool isVisible = true.obs;

  Future<bool> getAd({required String adType}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (isVisible.isTrue) {
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        if (adType == AdService.interstitialAd) {
          Yodo1MAS.instance.showInterstitialAd();
        } else if (adType == AdService.bannerAd) {
          Yodo1MAS.instance.showBannerAd();
        } else {
          Yodo1MAS.instance.showRewardAd();
        }
        return true;
      }
      return true;
    } else {
      return false;
    }
  }

  getBanners() {
    if (isVisible.isTrue) {
      return Yodo1MASBannerAd(
        size: BannerSize.Banner,
      );
    } else {
      return SizedBox();
    }
  }
}
