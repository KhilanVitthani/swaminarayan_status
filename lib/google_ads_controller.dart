import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdsController extends GetxController with WidgetsBindingObserver {
  AppOpenAd? appOpenAd;
  bool isPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      loadAppOpenAd();
      // getIt<AdService>().loadInterstitialAd();
      isPaused = false;
    }
  }

  loadAppOpenAd() {
    AppOpenAd.load(
        adUnitId: "ca-app-pub-8608272927918158/5429978279",
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              appOpenAd = ad;
              appOpenAd!.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }

  @override
  void onInit() async {
    await loadAppOpenAd();
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
