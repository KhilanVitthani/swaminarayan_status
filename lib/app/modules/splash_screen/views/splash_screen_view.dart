import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetWidget<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return GetBuilder<SplashScreenController>(
        init: SplashScreenController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                height: MySize.safeHeight,
                width: MySize.safeWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath + "splash.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath + "icon.png",
                      height: MySize.getHeight(72),
                      width: MySize.getWidth(68),
                    ),
                    Spacing.height(MySize.getHeight(3)),
                    Text(
                      "Quote",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MySize.getHeight(50),
                        color: Color(0xffF8D4CE),
                      ),
                    ),
                    SizedBox(
                      height: MySize.getHeight(4),
                    ),
                    Text(
                      "with the new day",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MySize.getHeight(20),
                        color: Color(0xffF8D4CE),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
