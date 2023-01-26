class DataModel {
  String? mediaLink;
  bool? isVideo;
  String? videoThumbnail;
  DataModel(
      {required this.mediaLink,
      required this.videoThumbnail,
      required this.isVideo});
  DataModel.fromJson(Map<String, dynamic> json) {
    mediaLink = json["mediaLink"];
    videoThumbnail = json["videoThumbnail"];
    isVideo = json["isVideo"];
  }
}
