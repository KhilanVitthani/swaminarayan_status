import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

class AdService {
  static const interstitialAd = "interstitialAd";
  static const bannerAd = "bannerAd";
  static const rewardsAd = "rewardsAd";

  Future<bool> getAd({required String adType}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
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
  }
}
