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

          Get.offAllNamed(Routes.HOME);

        return await true;
      },
      child: SafeArea(
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

                  Get.offAllNamed(Routes.HOME);

              },
              child: Container(
                padding: EdgeInsets.only(left: MySize.getWidth(10)),
                child: Icon(Icons.arrow_back, color: appTheme.primaryTheme),
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(8)),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print("object");
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print("object");
                        return Text(
                          "Error",
                          style: TextStyle(color: Colors.amber),
                        );
                      } else {
                        controller.likePost.clear();
                        controller.post.clear();
                        var data = snapshot.data!.docs;
                        if (!isNullEmptyOrFalse(data)) {
                          data.forEach((element) {
                            if (controller.likeList.contains(element.id)) {
                              controller.post.add(dailyThoughtModel.fromJson(
                                  element.data() as Map<String, dynamic>));
                            }
                          });
                        }

                        return StreamBuilder<QuerySnapshot>(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print("object");
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print("object");
                              return Text(
                                "Error",
                                style: TextStyle(color: Colors.amber),
                              );
                            } else {
                              var data = snapshot.data!.docs;
                              if (!isNullEmptyOrFalse(data)) {
                                data.forEach((element) {
                                  if (controller.likeList
                                      .contains(element.id)) {
                                    controller.post.add(dailyThoughtModel
                                        .fromJson(element.data()
                                            as Map<String, dynamic>));
                                  }
                                });
                              }
                              controller.likePost.value =
                                  controller.post.reversed.toList();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (isNullEmptyOrFalse(controller.likePost))
                                      ? Column(
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
                                      : Expanded(
                                          child: GridView.builder(
                                          itemCount: controller.likePost.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing:
                                                MySize.getHeight(2),
                                            mainAxisSpacing:
                                                MySize.getHeight(2),
                                          ),
                                          itemBuilder: (context, index) {
                                            controller.likePost
                                                .forEach((element) {
                                              element.isLiked!.value = true;
                                            });
                                            return GestureDetector(
                                              onTap: () {
                                                Get.offAndToNamed(
                                                    Routes.SHOW_POST_PAGE,
                                                    arguments: {
                                                      ArgumentConstant.post:
                                                          controller
                                                              .likePost[index],
                                                      ArgumentConstant
                                                          .isFromHome: false,
                                                      ArgumentConstant
                                                          .isFromLike: true,
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
                                                                      .likePost[
                                                                          index]
                                                                      .videoThumbnail))
                                                              ? controller
                                                                  .likePost[
                                                                      index]
                                                                  .videoThumbnail
                                                                  .toString()
                                                              : controller
                                                                  .likePost[
                                                                      index]
                                                                  .mediaLink
                                                                  .toString(),
                                                          height:
                                                              MySize.getHeight(
                                                                  25),
                                                          width:
                                                              MySize.getWidth(
                                                                  25),
                                                          boxFit:
                                                              BoxFit.cover)),
                                                  (!isNullEmptyOrFalse(
                                                          controller
                                                              .likePost[index]
                                                              .videoThumbnail))
                                                      ? Positioned(
                                                          top: MySize.getHeight(
                                                              10),
                                                          right:
                                                              MySize.getHeight(
                                                                  10),
                                                          child: Container(
                                                            child: SvgPicture.asset(
                                                                imagePath +
                                                                    "video.svg",
                                                                color: Colors
                                                                    .white),
                                                            height: 25,
                                                            width: 25,
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            );
                                          },
                                        )),
                                ],
                              );
                            }
                          },
                          stream: FireController().getPost(),
                        );
                      }
                    },
                    stream: FireController().getDailyThought(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
