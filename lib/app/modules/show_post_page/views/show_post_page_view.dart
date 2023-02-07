import 'package:photo_view/photo_view_gallery.dart';
import 'package:swaminarayan_status/constants/color_constant.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/show_post_page_controller.dart';

class ShowPostPageView extends GetWidget<ShowPostPageController> {
  const ShowPostPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        (controller.isFromLike.isTrue)
            ? Get.offAndToNamed(Routes.LIKE_SCREEN)
            : (controller.isFromHome.isTrue)
                ? Get.offAllNamed(Routes.HOME)
                : Get.offAndToNamed(Routes.ALL_POST_SCREEN);
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Quotes',
                style: TextStyle(
                  color: appTheme.primaryTheme,
                  fontSize: MySize.getHeight(26),
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
              leading: GestureDetector(
                onTap: () async {
                  (controller.isFromLike.isTrue)
                      ? Get.offAndToNamed(Routes.LIKE_SCREEN)
                      : (controller.isFromHome.isTrue)
                          ? Get.offAllNamed(Routes.HOME)
                          : Get.offAndToNamed(Routes.ALL_POST_SCREEN);
                },
                child: Container(
                  padding: EdgeInsets.only(left: MySize.getWidth(10)),
                  child: Icon(Icons.arrow_back, color: appTheme.primaryTheme),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.offAndToNamed(Routes.LIKE_SCREEN);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MySize.getHeight(22.5)),
                    child: SvgPicture.asset(
                      imagePath + "like.svg",
                      height: MySize.getHeight(22.94),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: (isNullEmptyOrFalse(controller.postData!.videoThumbnail))
                ? Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.getWidth(20)),
                        child: Container(
                          child: PhotoView.customChild(
                            child: getImageByLink(
                                url: controller.postData!.mediaLink.toString(),
                                boxFit: BoxFit.contain),
                            initialScale: 1.0,
                            backgroundDecoration:
                                BoxDecoration(color: Colors.white),
                            enableRotation: false,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MySize.getHeight(160),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getWidth(20)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MySize.getWidth(14),
                              ),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.postData!.isLiked!.toggle();
                                    if (controller.postData!.isLiked!.isTrue) {
                                      controller.addDataToLike(
                                          data: controller.postData!.uId
                                              .toString()
                                              .trim());
                                    } else {
                                      controller.removeDataToLike(
                                          data: controller.postData!.uId
                                              .toString()
                                              .trim());
                                    }
                                  },
                                  child: (controller.postData!.isLiked!.isTrue)
                                      ? SvgPicture.asset(
                                          imagePath + "likeFill.svg",
                                          height: MySize.getHeight(22.94),
                                        )
                                      : SvgPicture.asset(
                                          imagePath + "like.svg",
                                          height: MySize.getHeight(22.94),
                                        ),
                                );
                              }),
                              SizedBox(
                                width: MySize.getWidth(25),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.isFromDownload.value = true;
                                  controller.ads();
                                  if (isNullEmptyOrFalse(
                                      controller.postData!.videoThumbnail)) {
                                    String path = controller.postData!.mediaLink
                                        .toString();
                                    print(path);
                                    GallerySaver.saveImage(path).then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Success!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  } else {
                                    String path = controller.postData!.mediaLink
                                        .toString();
                                    print(path);
                                    GallerySaver.saveVideo(path).then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Success!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
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
                                  Share.share(controller.postData!.mediaLink!);
                                },
                                child: SvgPicture.asset(
                                  imagePath + "share.svg",
                                  height: MySize.getHeight(22.94),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //   left: MySize.getWidth(20),
                      //   right: MySize.getWidth(20),
                      //   top: MySize.getHeight(185),
                      //   child: Container(
                      //     height: MySize.getHeight(400),
                      //     width: MySize.getWidth(320),
                      //     decoration: BoxDecoration(
                      //       color: Colors.transparent,
                      //       borderRadius: BorderRadius.circular(12),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Color.fromRGBO(24, 24, 24, 0.12),
                      //             spreadRadius: 2,
                      //             blurRadius: 12,
                      //             offset: Offset(
                      //                 0, 12) // changes position of shadow
                      //             ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: (controller.flickManager == null)
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  height: MySize.getHeight(610),
                                  width: MySize.getWidth(320),
                                  child: FlickVideoPlayer(
                                      flickVideoWithControls:
                                          FlickVideoWithControls(
                                        controls: FlickPortraitControls(),
                                      ),
                                      flickManager:
                                          controller.flickManager!.value),
                                ),
                        ),
                        SizedBox(
                          height: MySize.getHeight(25),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getWidth(10)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MySize.getWidth(14),
                              ),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.postData!.isLiked!.toggle();
                                    if (controller.postData!.isLiked!.isTrue) {
                                      controller.addDataToLike(
                                          data: controller.postData!.uId
                                              .toString()
                                              .trim());
                                    } else {
                                      controller.removeDataToLike(
                                          data: controller.postData!.uId
                                              .toString()
                                              .trim());
                                    }
                                  },
                                  child: (controller.postData!.isLiked!.isTrue)
                                      ? SvgPicture.asset(
                                          imagePath + "likeFill.svg",
                                          height: MySize.getHeight(22.94),
                                        )
                                      : SvgPicture.asset(
                                          imagePath + "like.svg",
                                          height: MySize.getHeight(22.94),
                                        ),
                                );
                              }),
                              SizedBox(
                                width: MySize.getWidth(25),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.isFromDownload.value = true;
                                  controller.ads();
                                  if (isNullEmptyOrFalse(
                                      controller.postData!.videoThumbnail)) {
                                    String path = controller.postData!.mediaLink
                                        .toString();
                                    print(path);
                                    GallerySaver.saveImage(path).then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Success!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    });
                                  } else {
                                    String path = controller.postData!.mediaLink
                                        .toString();
                                    print(path);
                                    GallerySaver.saveVideo(path).then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Success!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
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
                                  Share.share(controller.postData!.mediaLink!);
                                },
                                child: SvgPicture.asset(
                                  imagePath + "share.svg",
                                  height: MySize.getHeight(22.94),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
      ),
    );
  }
}
