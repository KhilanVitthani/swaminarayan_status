import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swaminarayan_status/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../utilities/ad_service.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetWidget<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Image.asset(imagePath + "splash.png",
                width: MySize.safeWidth,
                height: MySize.safeHeight,
                fit: BoxFit.cover),
            StreamBuilder<QuerySnapshot>(
              builder: (context, data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                } else if (data.hasError) {
                  print("object");
                  return SizedBox();
                } else {
                  AdService.isVisible.value = data.data!.docs[0]["isVisible"];
                  print(AdService.isVisible);
                  return SizedBox();
                }
              },
              stream: FireController().adsVisible(),
            ),
          ],
        ),
      ),
    );
  }
}
