import 'package:swaminarayan_status/constants/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../models/daily_thought_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/like_screen_controller.dart';

class LikeScreenView extends GetView<LikeScreenController> {
  const LikeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.toNamed(Routes.HOME);

        return await true;
      },
      child: GetBuilder<LikeScreenController>(
          init: LikeScreenController(),
          builder: (controller) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'My Favorite Quotes',
                    style: TextStyle(
                      fontSize: MySize.getHeight(26),
                      fontWeight: FontWeight.w700,
                      color: appTheme.primaryTheme,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () async {
                      Get.toNamed(Routes.HOME);
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: MySize.getWidth(10)),
                      child:
                          Icon(Icons.arrow_back, color: appTheme.primaryTheme),
                    ),
                  ),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(8)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return Container(
                            child: (controller.homeController!.post
                                        .where((e) => e.isLiked!.isTrue)
                                        .toList()
                                        .length ==
                                    0)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Image.asset(
                                        imagePath + "nodata.png",
                                        height: 100,
                                        width: 100,
                                      )),
                                      Text(
                                        "No Data Found",
                                        style: TextStyle(
                                            color: appTheme.primaryTheme,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: MySize.getHeight(2),
                                      mainAxisSpacing: MySize.getHeight(2),
                                    ),
                                    itemBuilder: (context, index) {
                                      // if (controller.likeList.contains(controller.homeController!.post.where((e) => e.isLiked!.isTrue).toList()[index].uId)) {
                                      //   controller.homeController!.post.where((e) => e.isLiked!.isTrue).toList()[index]
                                      //       .isLiked!.value = true;
                                      // }
                                      print(DateTime.now()
                                          .microsecondsSinceEpoch);
                                      return GestureDetector(
                                        onTap: () {
                                          int i = 0;
                                          int Index = 0;
                                          controller.homeController!.post
                                              .forEach((element) {
                                            if (element.dateTime ==
                                                controller.homeController!.post
                                                    .where((e) =>
                                                        e.isLiked!.isTrue)
                                                    .toList()[index]
                                                    .dateTime) {
                                              Index = i;
                                            }
                                            i++;
                                          });
                                          Get.toNamed(Routes.SHOW_POST_PAGE,
                                              arguments: {
                                                ArgumentConstant.index: Index,
                                                ArgumentConstant.isFromHome:
                                                    false,
                                                ArgumentConstant.isFromLike:
                                                    true,
                                              });
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                                height: MySize.safeHeight,
                                                width: MySize.safeWidth,
                                                color: Colors.black,
                                                child: getImageByLink(
                                                    url: (!isNullEmptyOrFalse(
                                                            controller
                                                                .homeController!
                                                                .post
                                                                .where((e) => e
                                                                    .isLiked!
                                                                    .isTrue)
                                                                .toList()[index]
                                                                .videoThumbnail))
                                                        ? controller
                                                            .homeController!
                                                            .post
                                                            .where((e) => e
                                                                .isLiked!
                                                                .isTrue)
                                                            .toList()[index]
                                                            .videoThumbnail
                                                            .toString()
                                                        : controller
                                                            .homeController!
                                                            .post
                                                            .where((e) => e.isLiked!.isTrue)
                                                            .toList()[index]
                                                            .mediaLink
                                                            .toString(),
                                                    height: MySize.getHeight(25),
                                                    width: MySize.getWidth(25),
                                                    boxFit: BoxFit.cover)),
                                            (!isNullEmptyOrFalse(controller
                                                    .homeController!.post
                                                    .where((e) =>
                                                        e.isLiked!.isTrue)
                                                    .toList()[index]
                                                    .videoThumbnail))
                                                ? Positioned(
                                                    top: MySize.getHeight(10),
                                                    right: MySize.getHeight(10),
                                                    child: Container(
                                                      child: SvgPicture.asset(
                                                          imagePath +
                                                              "video.svg",
                                                          color: Colors.white),
                                                      height:
                                                          MySize.getHeight(25),
                                                      width:
                                                          MySize.getWidth(25),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            // Obx(() {
                                            //   return (!isNullEmptyOrFalse(controller.homeController!.post.where((e) => e.isLiked!.isTrue).toList()[index]
                                            //       .isLiked!
                                            //       .value))
                                            //       ? Positioned(
                                            //     bottom: MySize.getHeight(10),
                                            //     right: MySize.getHeight(10),
                                            //     child: Container(
                                            //       child: SvgPicture.asset(
                                            //           imagePath +
                                            //               "likeFill.svg",
                                            //           color: Colors.white),
                                            //       height: MySize.getHeight(15),
                                            //       width: MySize.getWidth(15),
                                            //     ),
                                            //   )
                                            //       : SizedBox();
                                            // })
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: controller.homeController!.post
                                        .where((e) => e.isLiked!.isTrue)
                                        .toList()
                                        .length),
                          );
                        }),
                      ),
                      // getIt<AdService>().getBanners(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
