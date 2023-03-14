import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutopedia/components/main_categories.dart';
import 'package:tutopedia/components/header.dart';
import 'package:tutopedia/components/main_courses.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/mycourse_list.dart';
import 'package:tutopedia/components/theme_changer.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/screens/change_password_screen.dart';
import 'package:tutopedia/screens/search_course_screen.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  bool isLoading = false;

  String appName = "Tutopedia";
  String appVersion = "";

  @override
  void initState() {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        appName = info.appName;
        appVersion = info.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('auth_info').listenable(),
      builder: (context, authInfoBox, child) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                const SizedBox(height: 25.0),
                Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      authInfoBox.get("profilePhoto").isEmpty
                          ? const CircleAvatar(
                              radius: 70.0,
                              backgroundImage: AssetImage(
                                "assets/images/avatar.png",
                              ),
                            )
                          : CircleAvatar(
                              radius: 70.0,
                              backgroundImage: NetworkImage(
                                "https://sagecrm.thesagenext.com/tutoapi/${authInfoBox.get("profilePhoto")}",
                              ),
                            ),
                      authInfoBox.get("authToken").isEmpty
                          ? const SizedBox()
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  final ImagePicker picker = ImagePicker();
                                  picker.pickImage(source: ImageSource.gallery).then((image) {
                                    if (image != null) {
                                      if (!isLoading) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        LoadingDialog(context);
                                        ApiService()
                                            .changeProfilePhoto(
                                          imagePath: image.path,
                                          token: authInfoBox.get("authToken"),
                                        )
                                            .then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          if (value["status"] == "profile-updated") {
                                            // update profile photo url
                                            // authInfoBox.put('profilePhoto', "");
                                            Fluttertoast.showToast(
                                              msg: "Successfully updated the profile photo.",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: primaryColor.shade500,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Sorry, unable to update profile photo.",
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: primaryColor.shade500,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          }
                                        }).onError((error, stackTrace) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: "Error, unable to update profile photo.",
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: primaryColor.shade500,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        });
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please choose a profile photo.",
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: primaryColor.shade500,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.edit_rounded),
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(primaryColor),
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                authInfoBox.get("authToken").isEmpty ? const SizedBox(height: 5.0) : const SizedBox(height: 15.0),
                authInfoBox.get("authToken").isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextButton(
                          onPressed: () {
                            if (authInfoBox.get("authToken").isEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SigninScreen(),
                                ),
                              );
                            }
                          },
                          child: const Text("Signin"),
                        ),
                      )
                    : const SizedBox(),
                // username
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          authInfoBox.get("name"),
                          style: const TextStyle(
                            fontFamily: secondaryFont,
                            fontSize: 30.0,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                authInfoBox.get("authToken").isEmpty ? const SizedBox() : const SizedBox(height: 5.0),
                // email
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          authInfoBox.get("email"),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                authInfoBox.get("authToken").isEmpty ? const SizedBox() : const SizedBox(height: 15.0),
                // change password
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.password_rounded,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                        title: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                ListTile(
                  onTap: () {
                    AdaptiveThemeMode currentThemeMode = AdaptiveTheme.of(context).mode;
                    ThemeChange(context, currentThemeMode);
                  },
                  leading: Icon(
                    Icons.palette_outlined,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  title: const Text(
                    "Theme",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Share.share('Check out Tutopedia, a learning app for students');
                  },
                  leading: Icon(
                    Icons.share,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  title: const Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                // signout
                authInfoBox.get("authToken").isEmpty
                    ? const SizedBox()
                    : ListTile(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              isLoading = true;
                            });
                            LoadingDialog(context);
                            ApiService().signOut(authInfoBox.get("authToken")).then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              if (value["success"] == "logged out successfully") {
                                authInfoBox.put('name', "");
                                authInfoBox.put('email', "");
                                authInfoBox.put('profilePhoto', "");
                                authInfoBox.put('authToken', "");

                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                  msg: "Your are successfully sign out.",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: primaryColor.shade500,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Something went wrong"),
                                    content: const Text("Unable to sign out, please try again."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Okay"),
                                      )
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                                  ),
                                );
                              }
                            }).onError((error, stackTrace) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Something went wrong"),
                                  content: const Text("Unable to sign in, please try again."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Okay"),
                                    )
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
                                ),
                              );
                            });
                          }
                        },
                        leading: Icon(
                          Icons.login_rounded,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                        title: const Text(
                          "Signout",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                AboutListTile(
                  applicationName: appName,
                  applicationVersion: appVersion,
                  applicationIcon: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      child: Image.asset("assets/images/app_icon.png"),
                    ),
                  ),
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  child: const Text(
                    "About",
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                              primaryColor,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      actionsPadding: const EdgeInsets.only(bottom: 12.0, right: 15.0),
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
                          text: TextSpan(
                            text: authInfoBox.get("name").isEmpty ? "Welcome" : "Hi, ${authInfoBox.get("name").split(" ")[0]}",
                            style: TextStyle(
                              fontFamily: secondaryFont,
                              fontSize: 30.0,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "\nWhat do you wanna learn today?",
                                style: TextStyle(
                                  fontFamily: primaryFont,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 2,
                        ),
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: authInfoBox.get("profilePhoto").isEmpty
                                ? const CircleAvatar(
                                    radius: 25,
                                    backgroundImage: AssetImage(
                                      "assets/images/avatar.png",
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(
                                      "https://sagecrm.thesagenext.com/tutoapi/${authInfoBox.get("profilePhoto")}",
                                    ),
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSearch(context: context, delegate: SearchCourseScreen());
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.shade50,
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
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
                  currentIndex == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Header(title: 'Categories'),
                            MainCategories(),
                            Header(title: 'Main Courses'),
                            MainCourses(),
                          ],
                        )
                      : ValueListenableBuilder(
                          valueListenable: Hive.box('my_courses').listenable(),
                          builder: (context, myCoursesBox, child) {
                            Map<dynamic, dynamic> courseList = myCoursesBox.get('courseList') ?? {};
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                                  child: SizedBox(
                                    child: Text(
                                      "Your saved channels ${courseList.isEmpty ? "" : "(${courseList.length})"}",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const MyCourseList(),
                              ],
                            );
                          }),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: currentIndex,
            onTap: (i) {
              if (i == 1) {
                if (authInfoBox.get("authToken").isEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    currentIndex = i;
                  });
                }
              } else {
                setState(() {
                  currentIndex = i;
                });
              }
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.category_outlined),
                activeIcon: const Icon(Icons.home_rounded),
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
      },
    );
  }
}
