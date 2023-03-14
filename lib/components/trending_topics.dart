import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/course_list_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class TrendingTopics extends StatefulWidget {
  const TrendingTopics({super.key});

  @override
  State<TrendingTopics> createState() => _TrendingTopicsState();
}

class _TrendingTopicsState extends State<TrendingTopics> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().trendingTopics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(3.25),
                    child: ActionChip(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CourseListScreen(
                              topic: item,
                            ),
                          ),
                        );
                      },
                      backgroundColor: primaryColor.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                          width: 0.0,
                          color: primaryColor.shade200,
                        ),
                      ),
                      label: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return SizedBox(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: const Tooltip(
                message: "Sorry, no trending topics found.",
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 50.0,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 55.0,
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
            height: 55.0,
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
