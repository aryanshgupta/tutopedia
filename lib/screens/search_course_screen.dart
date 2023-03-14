import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:tutopedia/components/course_view.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class SearchCourseScreen extends SearchDelegate {
  String courseId = '';

  SearchCourseScreen(this.courseId);

  @override
  String? get searchFieldLabel => "Search Courses";

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: 18.0,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(
          Icons.clear_rounded,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/no_data.svg',
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Sorry, no course found",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return FutureBuilder(
        future: ApiService().coursesByTopicId(courseId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              List<CourseModel> searchResult = snapshot.data!
                  .where(
                    (element) => element.title.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
              if (searchResult.isNotEmpty) {
                return CourseView(
                  courseList: searchResult,
                  shrinkWrap: false,
                );
              } else {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/no_data.svg',
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "Sorry, no course found",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg',
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Sorry, no course found",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/error.svg',
                    width: MediaQuery.of(context).size.width * 0.90,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, something went wrong!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return const SpinKitThreeInOut(
              color: primaryColor,
              size: 50.0,
            );
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: ApiService().coursesByTopicId(courseId),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/search.svg',
                  width: MediaQuery.of(context).size.width * 0.70,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Type to search courses",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            List<CourseModel> searchResult = snapshot.data!
                .where(
                  (element) => element.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
            if (searchResult.isNotEmpty) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResult[index].title),
                    onTap: () {
                      var authInfoBox = Hive.box('auth_info');
                      if (authInfoBox.get("authToken").isEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SigninScreen(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CourseScreen(
                              course: snapshot.data![index],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchResult.length,
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg',
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Sorry, no course found",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/no_data.svg',
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, no course found",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/error.svg',
                  width: MediaQuery.of(context).size.width * 0.90,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Sorry, something went wrong!",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return const SpinKitThreeInOut(
            color: primaryColor,
            size: 50.0,
          );
        }
      },
    );
  }
}
