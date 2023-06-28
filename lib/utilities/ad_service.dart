import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:yodo1mas/Yodo1MAS.dart';
// import 'package:yodo1mas/Yodo1MasBannerAd.dart';
// import 'package:yodo1mas/Yodo1MasNativeAd.dart';

import '../constants/firebase_controller.dart';

class AdService {
  static const interstitialAd = "interstitialAd";
  static const rewardsAd = "rewardsAd";
  static RxBool isVisible = false.obs;
  static RxBool isBannerVisible = false.obs;
  static RxBool isNativeVisible = false.obs;
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;

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
          // Yodo1MAS.instance.showInterstitialAd();
        } else {
          // Yodo1MAS.instance.showRewardAd();
        }
        return true;
      }
      return true;
    } else {
      return false;
    }
  }

  initBannerAds() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isBannerLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: AdRequest())
      ..load();
  }

  Widget getBannerAds() {
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }

  getNative() {
    FireController().adsVisible().then((value) {
      isVisible.value = value;
    });
    if (isVisible.isTrue) {
      // return Yodo1MASNativeAd(
      //   size: NativeSize.NativeSmall,
      // );
    } else {
      return SizedBox();
    }
  }
}
