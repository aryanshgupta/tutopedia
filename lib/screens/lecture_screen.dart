import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/models/channel_model.dart';
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

  TextEditingController lectureController = TextEditingController();

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
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                  splashRadius: 25.0,
                ),
                backgroundColor: Colors.white,
                title: const Text(
                  "Details",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
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
                        if (isEnrolled) {
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
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black45,
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
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
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
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black87,
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
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black45,
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
                                        color: snapshot.data![currentLectureIndex] == item ? Colors.indigo.shade100 : Colors.grey.shade200,
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
                                                    color: snapshot.data![currentLectureIndex] == item ? Colors.indigo : Colors.indigo.shade100,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    snapshot.data![currentLectureIndex] == item ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                                    size: 22.0,
                                                    color: snapshot.data![currentLectureIndex] == item ? Colors.white : Colors.indigo,
                                                  ),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Lecture ${snapshot.data!.indexOf(item) + 1}",
                                                        style: const TextStyle(
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2.5),
                                                      Text(
                                                        item.title,
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black45,
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
                          return ListView(
                            children: [
                              Image.network(
                                "https://i.ytimg.com/vi/${widget.channel.link.substring(30, 41)}/maxresdefault.jpg",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                  widget.channel.title,
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
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                            ],
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
                        color: Colors.indigo,
                        size: 50.0,
                      );
                    }
                  },
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('my_courses').listenable(),
                  builder: (context, myCoursesBox, child) {
                    List<String> idList = myCoursesBox.get('idList') ?? [];

                    if (idList.isNotEmpty) {
                      isEnrolled = idList.contains(widget.channel.id);
                    }

                    return SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          if (!isLoading) {
                            setState(() {
                              isLoading = true;
                            });
                            LoadingDialog(context);

                            if (isEnrolled) {
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

                                  Fluttertoast.showToast(
                                    msg: "Channel deleted from your bookmarks.",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.indigo.shade500,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              });
                            } else {
                              ApiService()
                                  .addCourse(
                                id: widget.channel.id,
                                token: authInfoBox.get("authToken"),
                              )
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                                if (value["success"] == "Course Add Successfully To My Course" || value["error"] == "Already Add To My Course") {
                                  idList.add(widget.channel.id);

                                  myCoursesBox.put("idList", idList);

                                  Fluttertoast.showToast(
                                    msg: "Channel added to your bookmarks.",
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.indigo.shade500,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.indigo),
                        ),
                        child: Text(
                          isEnrolled ? "Unenroll" : "Enroll",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }
}
