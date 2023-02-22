import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/models/category_model.dart';
import 'package:tutopedia/screens/course_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class CourseListScreen extends StatelessWidget {
  final CategoryModel category;
  const CourseListScreen({super.key, required this.category});

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
          category.title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: ApiService().courseList(category.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return GridView.builder(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(15.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.25,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CourseScreen(
                                course: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                              child: Image.network(
                                "https://i.ytimg.com/vi/${snapshot.data![index].link.substring(30, 41)}/maxresdefault.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                const SizedBox(width: 10.0),
                                const Icon(
                                  Icons.live_tv_rounded,
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].title,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2.5),
                                      Text(
                                        snapshot.data![index].channelName,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black45,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/no_data.svg',
                        width: MediaQuery.of(context).size.width * 0.50,
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
              return const SpinKitThreeInOut(
                color: Colors.indigo,
                size: 50.0,
              );
            }
          },
        ),
      ),
    );
  }
}
