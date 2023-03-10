import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/components/channel_view.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/search_channel_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class ChannelListScreen extends StatelessWidget {
  final CourseModel course;
  const ChannelListScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          splashRadius: 25.0,
        ),
        backgroundColor: Colors.white,
        title: Text(
          course.title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchChannelScreen(course.id),
              );
            },
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.black,
            ),
            splashRadius: 25.0,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: ApiService().channelList(course.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ChannelView(
                  channelList: snapshot.data!,
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
                        width: MediaQuery.of(context).size.width * 0.80,
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
        ),
      ),
    );
  }
}
