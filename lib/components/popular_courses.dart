import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutopedia/components/course_slide_view.dart';
import 'package:tutopedia/constants/styling.dart';
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
            return CourseSlideView(snapshot.data!);
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
