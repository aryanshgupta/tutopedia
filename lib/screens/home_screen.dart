import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutopedia/components/course_list.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/mycourse_list.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/models/user_model.dart';
import 'package:tutopedia/providers/auth_provider.dart';
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

  int totalNumberOfMyCourses = 0;

  bool isLoading = false;

  String name = "";
  String email = "";
  String authToken = "";
  String profilePhoto = "";

  String appName = "Tutopedia";
  String appVersion = "";

  @override
  void initState() {
    SharedPreferences.getInstance().then((perfs) {
      setState(() {
        name = perfs.getString('name') ?? "";
        email = perfs.getString('email') ?? "";
        authToken = perfs.getString('authToken') ?? "";
        profilePhoto = perfs.getString('profilePhoto') ?? "";
      });
    });
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
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 25.0),
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  authProvider.user.profilePhoto.isEmpty
                      ? CircleAvatar(
                          radius: 70.0,
                          child: Icon(
                            Icons.person,
                            size: 75.0,
                            color: Colors.indigo.shade600,
                          ),
                        )
                      : CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                            "https://sagecrm.thesagenext.com/tutoapi/${authProvider.user.profilePhoto}",
                          ),
                        ),
                  Positioned(
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
                                token: authProvider.user.authToken,
                              )
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                                if (value["status"] == "profile-updated") {
                                  authProvider.user = User(
                                    name: authProvider.user.name,
                                    email: authProvider.user.email,
                                    profilePhoto: profilePhoto,
                                    authToken: authProvider.user.authToken,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Sorry, unable to update profile photo.",
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
                                Fluttertoast.showToast(
                                  msg: "Error, unable to update profile photo.",
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.indigo.shade500,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please choose a profile photo.",
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.indigo.shade500,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        });
                      },
                      icon: const Icon(Icons.edit_rounded),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.indigo),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                authProvider.user.name,
                style: const TextStyle(
                  fontFamily: secondaryFont,
                  fontSize: 30.0,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                authProvider.user.email,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15.0),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
              leading: const Icon(Icons.password_rounded, color: Colors.black),
              title: const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                if (!isLoading) {
                  setState(() {
                    isLoading = true;
                  });
                  LoadingDialog(context);
                  ApiService().signOut(authProvider.user.authToken).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                    if (value["success"] == "logged out successfully") {
                      authProvider.user = User(
                        name: "",
                        email: "",
                        profilePhoto: "",
                        authToken: "",
                      );

                      SharedPreferences.getInstance().then((perfs) {
                        perfs.setString('name', "");
                        perfs.setString('email', "");
                        perfs.setString('profilePhoto', "");
                        perfs.setString('authToken', "");
                      });

                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "Your are successfully sign out.",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.indigo.shade500,
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
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  });
                }
              },
              leading: const Icon(Icons.login_rounded, color: Colors.black),
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
              icon: const Icon(Icons.info_outline_rounded, color: Colors.black),
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
                        text: "Welcome",
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
                      maxLines: 2,
                    ),
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          if (authToken.isNotEmpty) {
                            authProvider.user = User(
                              name: name,
                              email: email,
                              profilePhoto: profilePhoto,
                              authToken: authToken,
                            );

                            setState(() {
                              name = "";
                              email = "";
                              authToken = "";
                            });
                          }

                          if (authProvider.user.authToken.isEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SigninScreen(),
                              ),
                            );
                          } else {
                            Scaffold.of(context).openDrawer();
                          }
                        },
                        child: CircleAvatar(
                          radius: 25.0,
                          child: Icon(
                            Icons.person,
                            size: 30.0,
                            color: Colors.indigo.shade600,
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
                    color: Colors.indigo.shade50,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                child: Text(
                  currentIndex == 0 ? "Courses in our platform" : "Your saved channels ${totalNumberOfMyCourses == 0 ? "" : "($totalNumberOfMyCourses)"}",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              currentIndex == 0
                  ? CourseList(
                      name: name,
                      email: email,
                      profilePhoto: profilePhoto,
                      authToken: authToken,
                    )
                  : MyCourseList(
                      name: name,
                      email: email,
                      authToken: authToken,
                      profilePhoto: profilePhoto,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) {
          if (i == 1) {
            if (authToken.isEmpty && authProvider.user.authToken.isEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SigninScreen(),
                ),
              );
            } else {
              SharedPreferences.getInstance().then((perfs) {
                setState(() {
                  currentIndex = i;
                  totalNumberOfMyCourses = perfs.getStringList("my_courses") == null ? 0 : perfs.getStringList("my_courses")!.length;
                });
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
            activeIcon: const Icon(Icons.category_rounded),
            title: const Text("All Category"),
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
