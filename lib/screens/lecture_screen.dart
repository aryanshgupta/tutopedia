import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/channel_model.dart';
import 'package:tutopedia/screens/lecture_preview_screen.dart';
import 'package:tutopedia/services/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureScreen extends StatefulWidget {
  final ChannelModel channel;
  const LectureScreen({super.key, required this.channel});

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  late YoutubePlayerController ytPlayerController;

  int currentLectureIndex = 0;

  bool isLoading = false;

  bool isEnrolled = false;

  @override
  void initState() {
    ytPlayerController = YoutubePlayerController(
      initialVideoId: widget.channel.link.substring(30, 41),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    ytPlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    ytPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('auth_info').listenable(),
      builder: (context, authInfoBox, child) {
        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: ytPlayerController,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  splashRadius: 25.0,
                ),
                title: Text(
                  "Details",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {
                      if (!isLoading) {
                        setState(() {
                          isLoading = true;
                        });
                        LoadingDialog(context);

                        var myCoursesBox = Hive.box('my_courses');
                        List<String> idList = myCoursesBox.get('idList') ?? [];

                        ApiService()
                            .deleteCourse(
                          id: widget.channel.id,
                          token: authInfoBox.get("authToken"),
                        )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);

                          if (value["success"] == "MyCourse Removed Successfully" || value["message"] == "Call to a member function delete() on null") {
                            if (idList.remove(widget.channel.id)) {
                              myCoursesBox.put("idList", idList);
                            }

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LecturePreviewScreen(
                                  channel: widget.channel,
                                ),
                              ),
                            );
                          }
                        }).onError((error, stackTrace) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.bookmark_added,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: FutureBuilder(
                  future: ApiService().lectureList(
                    id: widget.channel.id,
                    token: authInfoBox.get("authToken"),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return Column(
                          children: [
                            player,
                            Expanded(
                              child: ListView(
                                children: [
                                  const SizedBox(height: 15.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      snapshot.data![currentLectureIndex].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      widget.channel.channelName,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_rounded, size: 15.0),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              snapshot.data![currentLectureIndex].time,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month_rounded, size: 15.0),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              "${DateTime.parse(snapshot.data![currentLectureIndex].updatedAt).day.toString()}.${DateTime.parse(snapshot.data![currentLectureIndex].updatedAt).month.toString()}.${DateTime.parse(snapshot.data![currentLectureIndex].updatedAt).year.toString()}",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      snapshot.data![currentLectureIndex].description,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black45,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      "Lectures",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  ...snapshot.data!.map((item) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 5.0,
                                      ),
                                      color: snapshot.data![currentLectureIndex] == item
                                          ? primaryColor.shade100
                                          : Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade200,
                                      elevation: 0.0,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentLectureIndex = snapshot.data!.indexOf(item);

                                            ytPlayerController.pause();

                                            ytPlayerController.load(snapshot.data![currentLectureIndex].link.substring(30, 41));
                                          });
                                        },
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 10.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: snapshot.data![currentLectureIndex] == item ? primaryColor : primaryColor.shade100,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  snapshot.data![currentLectureIndex] == item ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                                  size: 22.0,
                                                  color: snapshot.data![currentLectureIndex] == item ? Colors.white : primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lecture ${snapshot.data!.indexOf(item) + 1}",
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? snapshot.data![currentLectureIndex] == item
                                                                ? Colors.black87
                                                                : Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2.5),
                                                    Text(
                                                      item.title,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? snapshot.data![currentLectureIndex] == item
                                                                ? Colors.black54
                                                                : Colors.white54
                                                            : Colors.black45,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ],
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
                                "Sorry, no lecture found",
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
          },
        );
      },
    );
  }
}
