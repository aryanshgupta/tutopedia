import 'package:flutter/material.dart';
import 'package:tutopedia/models/course_model.dart';
import 'package:tutopedia/screens/channel_list_screen.dart';

class CourseView extends StatelessWidget {
  final List<CourseModel> courseList;
  final bool shrinkWrap;
  const CourseView({
    super.key,
    required this.courseList,
    required this.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const ScrollPhysics() : null,
      itemCount: courseList.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChannelListScreen(
                  course: courseList[index],
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  child: Image.asset(
                    courseList[index].image,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.40,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.50,
                width: MediaQuery.of(context).size.width * 0.50,
                padding: const EdgeInsets.only(bottom: 15.0),
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black12,
                      Colors.black26,
                      Colors.black45,
                      Colors.black,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Text(
                  courseList[index].title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
