import 'package:swaminarayan_status/constants/sizeConstant.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class dailyThoughtModel {
  String? mediaLink;
  String? videoThumbnail;
  int? dateTime;
  RxBool? isLiked = false.obs;
  RxBool? isDaily = false.obs;
  String? uId;
  dailyThoughtModel({
    required this.mediaLink,
    required this.videoThumbnail,
    required this.dateTime,
    this.isLiked,
    this.isDaily,
    required this.uId,
  });

  dailyThoughtModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json['mediaLink'];
    videoThumbnail = json['videoThumbnail'];
    uId = json["uId"];
    dateTime = json["dateTime"];
    isLiked!.value =
        (!isNullEmptyOrFalse(json["isLiked"])) ? json["isLiked"] : false;
    isDaily!.value =
        (!isNullEmptyOrFalse(json["isLiked"])) ? json["isLiked"] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaLink'] = this.mediaLink;
    data['uId'] = this.uId;
    data['videoThumbnail'] = this.videoThumbnail;
    data['dateTime'] = this.dateTime;
    data['isLiked'] = this.isLiked;
    data['isDaily'] = this.isDaily;
    return data;
  }
}
