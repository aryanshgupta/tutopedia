import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/course_view.dart';
import 'package:tutopedia/services/api_service.dart';

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService().courseList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return CourseView(
              courseList: snapshot.data!,
              shrinkWrap: true,
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/no_data.svg',
                    width: MediaQuery.of(context).size.width * 0.70,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, no category found",
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
            height: MediaQuery.of(context).size.height - 305.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/error.svg',
                  width: MediaQuery.of(context).size.width * 0.80,
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
          return SizedBox(
            height: MediaQuery.of(context).size.height - 305.0,
            child: const SpinKitThreeInOut(
              color: Colors.indigo,
              size: 50.0,
            ),
          );
        }
      },
    );
  }
}
