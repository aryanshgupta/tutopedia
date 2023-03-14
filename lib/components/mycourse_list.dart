import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tutopedia/components/channel_view.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class MyCourseList extends StatefulWidget {
  const MyCourseList({super.key});

  @override
  State<MyCourseList> createState() => _MyCourseListState();
}

class _MyCourseListState extends State<MyCourseList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('auth_info').listenable(),
      builder: (context, authInfoBox, child) {
        if (authInfoBox.get("authToken").isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 305.0,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SigninScreen(),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/authentication.svg',
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sigin to view my courses",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          return ValueListenableBuilder(
            valueListenable: Hive.box('my_courses').listenable(),
            builder: (context, myCoursesBox, child) {
              return FutureBuilder(
                future: ApiService().myCourses(authInfoBox.get("authToken")),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ChannelView(
                        channelList: snapshot.data!,
                        shrinkWrap: true,
                      );
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 305.0,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/no_data.svg',
                              width: MediaQuery.of(context).size.width * 0.70,
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              "Sorry, no saved courses found",
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
                      width: MediaQuery.of(context).size.width,
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
                      width: MediaQuery.of(context).size.width,
                      child: const SpinKitThreeInOut(
                        color: primaryColor,
                        size: 50.0,
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
