import 'package:flutter/material.dart';
import 'package:tutopedia/components/course_slide_view.dart';
import 'package:tutopedia/components/shimmer_box.dart';
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
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CourseSlideView(snapshot.data!);
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.filled(5, 0).map((item) {
                return const ShimmerBox(
                  height: 112.5,
                  width: 200.0,
                  borderRadius: 10.0,
                  margin: 7.5,
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
