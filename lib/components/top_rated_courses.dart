import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class TopRatedCourses extends StatefulWidget {
  const TopRatedCourses({super.key});

  @override
  State<TopRatedCourses> createState() => _TopRatedCoursesState();
}

class _TopRatedCoursesState extends State<TopRatedCourses> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().topRatedCourseList(),
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
          } else {
            return SizedBox(
              height: 127.0,
              width: MediaQuery.of(context).size.width,
              child: const Tooltip(
                message: "Sorry, no courses found.",
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
