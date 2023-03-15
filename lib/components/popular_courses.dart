import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
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
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CourseSlideView(snapshot.data!);
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.filled(5, 0).map((item) {
                  return Container(
                    margin: const EdgeInsets.all(7.5),
                    width: 200.0,
                    height: 112.5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.grey.shade100,
                    ),
                    child: Icon(
                      Icons.image_rounded,
                      color: Colors.grey.shade800,
                      size: 35.0,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
