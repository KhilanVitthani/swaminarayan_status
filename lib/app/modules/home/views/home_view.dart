import 'package:buddha_mindfulness/app/models/daily_thought_model.dart';
import 'package:buddha_mindfulness/app/models/data_model.dart';
import 'package:buddha_mindfulness/app/models/save_model.dart';
import 'package:buddha_mindfulness/app/routes/app_pages.dart';
import 'package:buddha_mindfulness/constants/api_constants.dart';
import 'package:buddha_mindfulness/constants/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
// import 'package:yodo1mas/Yodo1MasBannerAd.dart';

import '../../../../constants/firebase_controller.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Today’s Quote",
            style: TextStyle(
                color: appTheme.primaryTheme,
                fontWeight: FontWeight.w700,
                fontSize: MySize.getHeight(26)),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // FireController().addData();
                Get.offAndToNamed(Routes.LIKE_SCREEN);
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: MySize.getHeight(22.5)),
                child: SvgPicture.asset(
                  imagePath + "like.svg",
                  height: MySize.getHeight(22.94),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: MySize.getWidth(4),
              right: MySize.getWidth(4),
              top: MySize.getHeight(20)),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  builder: (context, data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      print("object");
                      return Center(child: CircularProgressIndicator());
                    } else if (data.hasError) {
                      print("object");
                      return Text(
                        "Error",
                        style: TextStyle(color: Colors.amber),
                      );
                    } else {
                      return Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: MySize.getHeight(10.0),
                                      mainAxisSpacing: MySize.getHeight(10.0)),
                              itemBuilder: (context, index) {
                                dailyThoughtModel dailyThought =
                                    dailyThoughtModel.fromJson(
                                  data.data!
                                      .docs[data.data!.docs.length - index - 1]
                                      .data() as Map<String, dynamic>,
                                );
                                if (controller.likeList
                                    .contains(dailyThought.uId)) {
                                  dailyThought.isLiked!.value = true;
                                }
                                print(DateTime.now());
                                print(dailyThought.mediaLink);
                                if (!isNullEmptyOrFalse(
                                    dailyThought.videoThumbnail)) {
                                  controller.mediaLink!.value =
                                      dailyThought.mediaLink!;
                                  controller.getVideo(
                                      mediaLink: controller.mediaLink!.value);
                                  controller.isVideo.value = true;
                                }
                                if (controller.isTaped.isTrue) {
                                  controller.hide();
                                }

                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: MySize.getWidth(15)),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: (!isNullEmptyOrFalse(
                                                  dailyThought.videoThumbnail))
                                              ? Obx(() {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      controller.isTaped
                                                          .toggle();

                                                      if (controller
                                                          .isTaped.isTrue) {
                                                        controller.hide();
                                                      }
                                                    },
                                                    child: Container(
                                                      child: (controller
                                                                  .flickManager ==
                                                              null)
                                                          ? Visibility(
                                                              visible:
                                                                  controller
                                                                      .isTaped
                                                                      .value,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: MySize
                                                                  .getHeight(
                                                                      610),
                                                              width: MySize
                                                                  .getWidth(
                                                                      320),
                                                              child:
                                                                  FlickVideoPlayer(
                                                                      flickVideoWithControls:
                                                                          FlickVideoWithControls(
                                                                        controls:
                                                                            Visibility(
                                                                          visible: controller
                                                                              .isTaped
                                                                              .value,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                FlickPlayToggle(size: MySize.getHeight(35)),
                                                                          ),
                                                                        ),
                                                                        videoFit:
                                                                            BoxFit.fitHeight,
                                                                      ),
                                                                      flickManager: controller
                                                                          .flickManager!
                                                                          .value),
                                                            ),
                                                    ),
                                                  );
                                                })
                                              : getImageByLink(
                                                  url: dailyThought.mediaLink!,
                                                  height: MySize.getHeight(325),
                                                  width: MySize.getWidth(320),
                                                  boxFit: BoxFit.contain),
                                        ),
                                        SizedBox(
                                          height: MySize.getHeight(9),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MySize.getWidth(14),
                                            ),
                                            Obx(() {
                                              return GestureDetector(
                                                onTap: () {
                                                  dailyThought.isLiked!
                                                      .toggle();
                                                  if (dailyThought
                                                      .isLiked!.isTrue) {
                                                    controller.addDataToLike(
                                                        data: dailyThought.uId
                                                            .toString()
                                                            .trim());
                                                  } else {
                                                    controller.removeDataToLike(
                                                        data: dailyThought.uId
                                                            .toString()
                                                            .trim());
                                                  }
                                                },
                                                child: (dailyThought
                                                        .isLiked!.isTrue)
                                                    ? SvgPicture.asset(
                                                        imagePath +
                                                            "likeFill.svg",
                                                        height:
                                                            MySize.getHeight(
                                                                22.94),
                                                      )
                                                    : SvgPicture.asset(
                                                        imagePath + "like.svg",
                                                        height:
                                                            MySize.getHeight(
                                                                22.94),
                                                      ),
                                              );
                                            }),
                                            SizedBox(
                                              width: MySize.getWidth(25),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                // controller.ads();
                                                if (isNullEmptyOrFalse(
                                                    dailyThought
                                                        .videoThumbnail)) {
                                                  String path = dailyThought
                                                      .mediaLink
                                                      .toString();
                                                  print(path);
                                                  GallerySaver.saveImage(path)
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg: "Success!",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  });
                                                } else {
                                                  String path = dailyThought
                                                      .mediaLink
                                                      .toString();
                                                  print(path);
                                                  GallerySaver.saveVideo(path)
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                        msg: "Success!",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  }).catchError((error) {
                                                    print(error);
                                                  });
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                imagePath + "down.svg",
                                                height: MySize.getHeight(22.94),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MySize.getWidth(25),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Share.share(
                                                    dailyThought.mediaLink!);
                                              },
                                              child: SvgPicture.asset(
                                                imagePath + "share.svg",
                                                height: MySize.getHeight(22.94),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: 1,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                  stream: FireController().getDailyThought(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MySize.getWidth(10),
                    right: MySize.getWidth(10),
                    top: MySize.getHeight(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recent",
                          style: TextStyle(
                              fontSize: MySize.getHeight(18),
                              color: appTheme.textGrayColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.offAndToNamed(Routes.ALL_POST_SCREEN);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Text(
                                  "view all",
                                  style: TextStyle(
                                    fontSize: MySize.getHeight(15),
                                    fontWeight: FontWeight.w400,
                                    color: appTheme.textGrayColor,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: appTheme.textGrayColor,
                                  size: MySize.getHeight(15),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacing.height(
                      MySize.getHeight(10),
                    ),
                    Container(
                      height: MySize.getHeight(268),
                      child: StreamBuilder<QuerySnapshot>(
                        builder: (context, data) {
                          if (data.connectionState == ConnectionState.waiting) {
                            print("object");
                            return Center(child: CircularProgressIndicator());
                          } else if (data.hasError) {
                            print("object");
                            return Text(
                              "Error",
                              style: TextStyle(color: Colors.amber),
                            );
                          } else {
                            return Column(
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

                                        controller.post.add(dataModel);
                                        if (controller.likeList
                                            .contains(dataModel.uId)) {
                                          dataModel.isLiked!.value = true;
                                        }
                                        print(DateTime.now()
                                            .microsecondsSinceEpoch);
                                        return GestureDetector(
                                          onTap: () {
                                            Get.offAndToNamed(
                                                Routes.SHOW_POST_PAGE,
                                                arguments: {
                                                  ArgumentConstant.post:
                                                      dataModel,
                                                  ArgumentConstant.isFromHome:
                                                      true,
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
                                                      width:
                                                          MySize.getWidth(25),
                                                      boxFit: BoxFit.cover)),
                                              (!isNullEmptyOrFalse(
                                                      dataModel.videoThumbnail))
                                                  ? Positioned(
                                                      top: MySize.getHeight(10),
                                                      right:
                                                          MySize.getHeight(10),
                                                      child: Container(
                                                        child: SvgPicture.asset(
                                                            imagePath +
                                                                "video.svg",
                                                            color:
                                                                Colors.white),
                                                        height:
                                                            MySize.getHeight(
                                                                25),
                                                        width:
                                                            MySize.getWidth(25),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                              (!isNullEmptyOrFalse(
                                                      dataModel.isLiked!.value))
                                                  ? Positioned(
                                                      bottom:
                                                          MySize.getHeight(10),
                                                      right:
                                                          MySize.getHeight(10),
                                                      child: Container(
                                                        child: SvgPicture.asset(
                                                            imagePath +
                                                                "likeFill.svg",
                                                            color:
                                                                Colors.white),
                                                        height:
                                                            MySize.getHeight(
                                                                15),
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
                            );
                          }
                        },
                        stream: FireController().getPost(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MySize.getHeight(10),
              )
            ],
          ),
        ),
      ),
    );
  }
}