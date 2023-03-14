import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/course_preview_screen.dart';
import 'package:tutopedia/screens/course_screen.dart';

class CourseView extends StatefulWidget {
  final List<CourseModel> courseList;
  final bool shrinkWrap;

  const CourseView({
    super.key,
    required this.courseList,
    required this.shrinkWrap,
  });

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.shrinkWrap ? const ScrollPhysics() : null,
      itemCount: widget.courseList.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 5.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () {
            var myCoursesBox = Hive.box('my_courses');
            Map<dynamic, dynamic> courseList = myCoursesBox.get('courseList') ?? {};
            bool isEnrolled = false;
            if (courseList.isNotEmpty) {
              isEnrolled = courseList.containsKey(widget.courseList[index].id);
            }
            if (isEnrolled) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CourseScreen(
                    course: widget.courseList[index],
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CoursePreviewScreen(
                    course: widget.courseList[index],
                  ),
                ),
              );
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.width * 0.28,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.network(
                      "https://i.ytimg.com/vi/${widget.courseList[index].link.substring(30, 41)}/maxresdefault.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.courseList[index].title,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.courseList[index].channelName,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(widget.courseList[index].rating),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rate_rounded,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 12.0,
                          direction: Axis.horizontal,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 12.0,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              int.parse(widget.courseList[index].studentEnrolled) >= 2 ? "${widget.courseList[index].studentEnrolled} students" : "${widget.courseList[index].studentEnrolled} student",
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
