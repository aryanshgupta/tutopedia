import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/course_list_screen.dart';
import 'package:tutopedia/screens/profile_screen.dart';
import 'package:tutopedia/screens/search_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            var result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Do you want to exit?"),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.indigo,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      child: const Text("Yes"),
                    ),
                  ],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            );
            return result;
          },
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: "Hola, harry!",
                        style: TextStyle(
                          fontFamily: secondaryFont,
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "\nWhat do you wanna learn today?",
                            style: TextStyle(
                              fontFamily: primaryFont,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ProfileScreen(
                          context,
                          name: "harry",
                          email: "harry@gmail.com",
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/profile.svg',
                        height: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: SearchScreen());
                },
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                        ),
                      ),
                      Icon(
                        Icons.search_rounded,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: const Text(
                    "Courses in our platform",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: ApiService().categoryList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CourseListScreen(
                                  category: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  child: Image.asset(
                                    snapshot.data![index].image,
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.width *
                                        0.40,
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.50,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Text(
                                  snapshot.data![index].title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const SpinKitThreeInOut(
                      color: Colors.indigo,
                      size: 50.0,
                    );
                  }
                },
              ),
              const SizedBox(height: 10.0),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 15.0),
                    Text(
                      "Try free trial to enhance your creative journey!",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25.0),
                    Text(
                      "Get free trial",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            title: const Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.book_outlined),
            activeIcon: const Icon(Icons.book_rounded),
            title: const Text("My Courses"),
          ),
        ],
      ),
    );
  }
}
