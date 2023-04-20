import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';
import 'package:yodo1mas/Yodo1MasNativeAd.dart';

import '../constants/firebase_controller.dart';

class AdService {
  static const interstitialAd = "interstitialAd";
  static const bannerAd = "bannerAd";
  static const rewardsAd = "rewardsAd";
  static RxBool isVisible = false.obs;
  static RxBool isBannerVisible = false.obs;
  static RxBool isNativeVisible = false.obs;

  Future<bool> getAd({required String adType}) async {
    FireController().adsVisible().then((value) {
      isVisible.value = value;
    });
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
    FireController().adsVisible().then((value) {
      isVisible.value = value;
    });
    if (isVisible.isTrue) {
      print("object");
      return Yodo1MASBannerAd(
        size: BannerSize.Banner,
        onOpen: () {
          isBannerVisible.value = true;
        },
      );
    } else {
      return SizedBox();
    }
  }

  getNative() {
    FireController().adsVisible().then((value) {
      isVisible.value = value;
    });
    if (isVisible.isTrue) {
      return Yodo1MASNativeAd(
        size: NativeSize.NativeSmall,
      );
    } else {
      return SizedBox();
    }
  }
}
