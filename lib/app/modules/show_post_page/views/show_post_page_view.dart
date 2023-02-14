import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/show_post_page_controller.dart';

class ShowPostPageView extends GetWidget<ShowPostPageController> {
  const ShowPostPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowPostPageController>(init: ShowPostPageController(),builder: (logic) {
      return WillPopScope(
        onWillPop: () async {
          getIt<CustomDialogs>().hideCircularDialog(context);
          (controller.isFromLike.isTrue)
              ? Get.toNamed(Routes.LIKE_SCREEN)
              : (controller.isFromHome.isTrue)
              ? Get.toNamed(Routes.HOME)
              : Get.toNamed(Routes.ALL_POST_SCREEN);
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
                    getIt<CustomDialogs>().hideCircularDialog(context);

                    (controller.isFromLike.isTrue)
                        ? Get.toNamed(Routes.LIKE_SCREEN)
                        : (controller.isFromHome.isTrue)
                        ? Get.toNamed(Routes.HOME)
                        : Get.toNamed(Routes.ALL_POST_SCREEN);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: MySize.getWidth(10)),
                    child: Icon(Icons.arrow_back,
                        color: appTheme.primaryTheme),
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
              body: (isNullEmptyOrFalse(controller.homeController!
                  .post[controller.Index.value].videoThumbnail))
                  ? Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MySize.getWidth(20)),
                    child: Container(
                      child: PhotoView.customChild(
                        child: getImageByLink(
                            url: controller
                                .homeController!
                                .post[controller.Index.value]
                                .mediaLink
                                .toString(),
                            boxFit: BoxFit.contain),
                        initialScale: 1.0,
                        backgroundDecoration:
                        BoxDecoration(color: Colors.white),
                        enableRotation: false,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MySize.getHeight(155),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MySize.getWidth(20)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MySize.getWidth(14),
                          ),
                          Obx(() {
                            return InkWell(
                              onTap: () {
                                controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .isLiked!
                                    .toggle();
                                if (controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .isLiked!
                                    .isTrue) {
                                  controller.addDataToLike(
                                      data: controller
                                          .homeController!
                                          .post[
                                      controller.Index.value]
                                          .uId
                                          .toString()
                                          .trim());
                                } else {
                                  controller.removeDataToLike(
                                      data: controller
                                          .homeController!
                                          .post[
                                      controller.Index.value]
                                          .uId
                                          .toString()
                                          .trim());
                                }
                              },
                              child: (controller
                                  .homeController!
                                  .post[controller.Index.value]
                                  .isLiked!
                                  .isTrue)
                                  ? SvgPicture.asset(
                                imagePath + "likeFill.svg",
                                height: MySize.getHeight(23),
                              )
                                  : SvgPicture.asset(
                                imagePath + "like.svg",
                                height: MySize.getHeight(23),
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
                              if (isNullEmptyOrFalse(controller
                                  .homeController!
                                  .post[controller.Index.value]
                                  .videoThumbnail)) {
                                String path = controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .mediaLink
                                    .toString();
                                print(path);
                                GallerySaver.saveImage(path)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Success!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }).catchError((error) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                ;
                              } else {
                                String path = controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .mediaLink
                                    .toString();
                                print(path);
                                GallerySaver.saveVideo(path)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Success!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }).catchError((error) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                ;
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
                            onTap: () async {
                              getIt<CustomDialogs>()
                                  .showCircularDialog(context);
                              File? file;
                              await DefaultCacheManager()
                                  .getSingleFile(
                                  controller.postData!.mediaLink!)
                                  .then((value) {
                                getIt<CustomDialogs>()
                                    .hideCircularDialog(context);
                                file = value;
                              });
                              Share.shareFiles([file!.path]);
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
                  Positioned(
                    bottom: MySize.getHeight(5),
                    left: MySize.getWidth(25),
                    child: getIt<AdService>().getBanners(),
                  )
                ],
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
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
                                controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .isLiked!
                                    .toggle();
                                if (controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .isLiked!
                                    .isTrue) {
                                  controller.addDataToLike(
                                      data: controller
                                          .homeController!
                                          .post[
                                      controller.Index.value]
                                          .uId
                                          .toString()
                                          .trim());
                                } else {
                                  controller.removeDataToLike(
                                      data: controller
                                          .homeController!
                                          .post[
                                      controller.Index.value]
                                          .uId
                                          .toString()
                                          .trim());
                                }
                              },
                              child: (controller
                                  .homeController!
                                  .post[controller.Index.value]
                                  .isLiked!
                                  .isTrue)
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
                              if (isNullEmptyOrFalse(controller
                                  .postData!.videoThumbnail)) {
                                String path = controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .mediaLink
                                    .toString();
                                print(path);
                                GallerySaver.saveImage(path)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Success!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }).catchError((error) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                ;
                              } else {
                                String path = controller
                                    .homeController!
                                    .post[controller.Index.value]
                                    .mediaLink
                                    .toString();
                                print(path);
                                GallerySaver.saveVideo(path)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Success!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }).catchError((error) {
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                                ;
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
                            onTap: () async {
                              getIt<CustomDialogs>()
                                  .showCircularDialog(context);
                              File? file;
                              await DefaultCacheManager()
                                  .getSingleFile(controller
                                  .homeController!
                                  .post[controller.Index.value]
                                  .mediaLink!)
                                  .then((value) {
                                getIt<CustomDialogs>()
                                    .hideCircularDialog(context);
                                file = value;
                              }).catchError((error) {
                                print(error);
                              });
                              Share.shareFiles([file!.path]);
                            },
                            child: SvgPicture.asset(
                              imagePath + "share.svg",
                              height: MySize.getHeight(22.94),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    getIt<AdService>().getBanners(),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )),
        ),
      );
    });
  }
}
