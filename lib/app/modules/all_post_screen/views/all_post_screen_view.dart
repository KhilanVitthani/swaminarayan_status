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
import '../controllers/all_post_screen_controller.dart';

class AllPostScreenView extends GetWidget<AllPostScreenController> {
  const AllPostScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getIt<TimerService>().is40SecCompleted) {
          // await getIt<AdService>()
          //     .getAd(adType: AdService.interstitialAd)
          //     .then((value) {
          //   if (!value) {
          //     getIt<TimerService>().verifyTimer();
          //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          //
          //     Get.offAllNamed(Routes.HOME);
          //   }
          // });
          //
          // return await false;
        } else {
          Get.offAllNamed(Routes.HOME);
        }
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Quotes',
                style: TextStyle(
                    color: appTheme.primaryTheme,
                    fontWeight: FontWeight.w700,
                    fontSize: MySize.getHeight(26))),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () async {
                if (getIt<TimerService>().is40SecCompleted) {
                  // await getIt<AdService>()
                  //     .getAd(adType: AdService.interstitialAd)
                  //     .then((value) {
                  //   if (!value) {
                  //     getIt<TimerService>().verifyTimer();
                  //     SystemChrome.setEnabledSystemUIMode(
                  //         SystemUiMode.edgeToEdge);
                  //
                  //     Get.offAllNamed(Routes.HOME);
                  //   }
                  // });
                } else {
                  Get.offAllNamed(Routes.HOME);
                }
              },
              child: Container(
                padding: EdgeInsets.only(left: MySize.getWidth(10)),
                child: Icon(Icons.arrow_back, color: appTheme.primaryTheme),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.getWidth(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    builder: (context, data) {
                      if (data.connectionState == ConnectionState.waiting) {
                        // print("object");
                        return Center(child: CircularProgressIndicator());
                      } else if (data.hasError) {
                        // print("object");
                        return Text(
                          "Error",
                          style: TextStyle(color: Colors.amber),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: MySize.getHeight(20)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: MySize.getHeight(2),
                                      mainAxisSpacing: MySize.getHeight(2),
                                    ),
                                    itemBuilder: (context, index) {
                                      dailyThoughtModel dataModel =
                                          dailyThoughtModel.fromJson(
                                        data
                                            .data!
                                            .docs[data.data!.docs.length -
                                                index -
                                                1]
                                            .data() as Map<String, dynamic>,
                                      );
                                      if (controller.likeList
                                          .contains(dataModel.uId)) {
                                        dataModel.isLiked!.value = true;
                                      }
                                      // print(
                                      //     "Data:=============${data.data!.docs.length}");
                                      return GestureDetector(
                                        onTap: () {
                                          Get.offAndToNamed(
                                              Routes.SHOW_POST_PAGE,
                                              arguments: {
                                                ArgumentConstant.post:
                                                    dataModel,
                                                ArgumentConstant.isFromHome:
                                                    false,
                                                ArgumentConstant.isFromLike:
                                                    false,
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
                                                            dataModel
                                                                .videoThumbnail))
                                                        ? dataModel
                                                            .videoThumbnail
                                                            .toString()
                                                        : dataModel.mediaLink
                                                            .toString(),
                                                    height:
                                                        MySize.getHeight(25),
                                                    width: MySize.getWidth(25),
                                                    boxFit: BoxFit.cover)),
                                            (!isNullEmptyOrFalse(
                                                    dataModel.videoThumbnail))
                                                ? Positioned(
                                                    top: MySize.getHeight(10),
                                                    right: MySize.getHeight(10),
                                                    child: Container(
                                                      child: SvgPicture.asset(
                                                          imagePath +
                                                              "video.svg",
                                                          color: Colors.white),
                                                      height: 25,
                                                      width: 25,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            (!isNullEmptyOrFalse(
                                                    dataModel.isLiked!.value))
                                                ? Positioned(
                                                    bottom:
                                                        MySize.getHeight(10),
                                                    right: MySize.getHeight(10),
                                                    child: Container(
                                                      child: SvgPicture.asset(
                                                          imagePath +
                                                              "likeFill.svg",
                                                          color: Colors.white),
                                                      height:
                                                          MySize.getHeight(15),
                                                      width:
                                                          MySize.getWidth(15),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: data.data!.docs.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    stream: FireController().getPost(),
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
