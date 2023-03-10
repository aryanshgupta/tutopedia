class CourseModel {
  final String id;
  final String title;
  final String image;
  CourseModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? "",
      title: json['name'] ?? "",
      image: "assets/images/${json['name'].toString().toLowerCase()}.png",
    );
  }
}
