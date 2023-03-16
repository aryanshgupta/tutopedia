import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tutopedia/components/shimmer_box.dart';
import 'package:tutopedia/constants/hive_boxes.dart';
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
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: 2.1,
              autoPlay: true,
              enlargeFactor: 0.19,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              return InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                onTap: () {
                  Map<dynamic, dynamic> courseList = myCoursesBox.get('courseList') ?? {};
                  bool isEnrolled = false;
                  if (courseList.isNotEmpty) {
                    isEnrolled = courseList.containsKey(snapshot.data![itemIndex].id);
                  }
                  if (isEnrolled) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CourseScreen(
                          course: snapshot.data![itemIndex],
                          currentUserRating: courseList[snapshot.data![itemIndex].id],
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CoursePreviewScreen(
                          course: snapshot.data![itemIndex],
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.5),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      imageUrl: "https://i.ytimg.com/vi/${snapshot.data![itemIndex].link.substring(30, 41)}/maxresdefault.jpg",
                      placeholder: (context, url) {
                        return const ShimmerBox(
                          height: double.infinity,
                          width: double.infinity,
                          borderRadius: 10.0,
                          margin: 0.0,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: Colors.grey.shade600,
                            size: 35.0,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return CarouselSlider.builder(
            options: CarouselOptions(
              aspectRatio: 2.1,
              autoPlay: true,
              enlargeFactor: 0.19,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: 5,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              return const ShimmerBox(
                height: double.infinity,
                width: double.infinity,
                borderRadius: 10.0,
                margin: 7.5,
              );
            },
          );
        }
      },
    );
  }
}
