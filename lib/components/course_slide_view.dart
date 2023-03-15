import 'package:flutter/material.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';

class CourseSlideView extends StatelessWidget {
  final List<CourseModel> courseList;
  const CourseSlideView(this.courseList, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: courseList.map((item) {
          return InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            onTap: () {
              Map<dynamic, dynamic> courseList = myCoursesBox.get('courseList') ?? {};
              bool isEnrolled = false;
              if (courseList.isNotEmpty) {
                isEnrolled = courseList.containsKey(item.id);
              }
              if (isEnrolled) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseScreen(
                      course: item,
                      currentUserRating: courseList[item.id],
                    ),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CoursePreviewScreen(
                      course: item,
                    ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.all(7.5),
              width: 200.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  "https://i.ytimg.com/vi/${item.link.substring(30, 41)}/maxresdefault.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
