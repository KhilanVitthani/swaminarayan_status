import 'package:get/get.dart';

import '../app/routes/app_pages.dart';

const imagePath = "assets/images/";
const feedBackEmail = "mobileappxperts3@gmail.com";

class ArgumentConstant {
  static const post = "post";
  static const index = "index";
  static const likeList = "likeList";
  static const isFromHome = "isFromHome";
  static const isFromLike = "isFromLike";
  static const isFromSplash = "isFromSplash";
  static const isFirstTime = "isFirstTime";
  static const date = "date";
  static const shareLink =
      "Experience the divine with Swaminarayan Video Status! Share your devotion with loved ones and spread the message of peace and harmony. Download now https://play.google.com/store/apps/details?id=com.mobileappxperts.swaminarayanvideostatus";
}

getLogOut() {
  Get.offAllNamed(Routes.HOME);
}
