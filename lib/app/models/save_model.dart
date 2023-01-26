class SaveThoughtModel {
  String? mediaLink;
  String? uId;
  String? videoThumbnail;

  SaveThoughtModel({
    required this.mediaLink,
    required this.videoThumbnail,
    required this.uId,
  });

  SaveThoughtModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json['mediaLink'];
    videoThumbnail = json['videoThumbnail'];
    uId = json["uId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaLink'] = this.mediaLink;
    data['uId'] = this.uId;
    data['videoThumbnail'] = this.videoThumbnail;
    return data;
  }
}
