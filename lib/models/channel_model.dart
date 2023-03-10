class ChannelModel {
  final String id;
  final String title;
  final String channelName;
  final String uploadedBy;
  final String link;
  final String description;
  final String rating;
  final String studentEnrolled;

  ChannelModel({
    required this.id,
    required this.title,
    required this.channelName,
    required this.uploadedBy,
    required this.link,
    required this.description,
    required this.rating,
    required this.studentEnrolled,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      channelName: json['channel_name'] ?? "",
      uploadedBy: json['uploaded_by'] ?? "",
      link: json['link'] ?? "",
      description: json['description'] ?? "",
      rating: json['rating'].toString(),
      studentEnrolled: json['student_enrolled'].toString(),
    );
  }
}
