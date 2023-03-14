import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class PopularCourses extends StatefulWidget {
  const PopularCourses({super.key});

  @override
  State<PopularCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<PopularCourses> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().popularCourseList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.map((item) {
                  return InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    onTap: () {
                      var myCoursesBox = Hive.box('my_courses');
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
          } else {
            return SizedBox(
              height: 127.0,
              width: MediaQuery.of(context).size.width,
              child: const Tooltip(
                message: "Sorry, no popular courses found.",
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 50.0,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 127.0,
            width: MediaQuery.of(context).size.width,
            child: const Tooltip(
              message: "Sorry, something went wrong!",
              child: Icon(
                Icons.error_outline_rounded,
                size: 50.0,
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 127.0,
            width: MediaQuery.of(context).size.width,
            child: const SpinKitThreeInOut(
              color: primaryColor,
              size: 50.0,
            ),
          );
        }
      },
    );
  }
}
