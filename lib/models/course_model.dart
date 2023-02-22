class CourseModel {
  final String id;
  final String title;
  final String channelName;
  final String uploadedBy;
  final String courseId;
  final String link;
  final String image;

  CourseModel({
    required this.id,
    required this.title,
    required this.channelName,
    required this.uploadedBy,
    required this.courseId,
    required this.link,
    required this.image,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'],
      title: json['title'],
      channelName: json['channel_name'],
      uploadedBy: json['uploaded_by'],
      courseId: json['course_id'],
      link: json['link'],
      image: json['image'],
    );
  }
}
