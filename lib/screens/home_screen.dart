import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tutopedia/components/categories_list.dart';
import 'package:tutopedia/components/mycourse_list.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/profile_screen.dart';
import 'package:tutopedia/screens/search_screen.dart';
import 'package:tutopedia/screens/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
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
                      text: TextSpan(
                        text: authProvider.name.isEmpty
                            ? "Welcome :)"
                            : "Hi, ${authProvider.name.length > 12 ? authProvider.name.substring(0, 12) : authProvider.name} :)",
                        style: const TextStyle(
                          fontFamily: secondaryFont,
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                        children: const [
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
                    GestureDetector(
                      onTap: () {
                        if (authProvider.authToken.isEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        } else {
                          ProfileScreen(context);
                        }
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
                  child: Text(
                    currentIndex == 0
                        ? "Categories available in our platform"
                        : "Your saved courses",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              currentIndex == 0 ? const CategoriesList() : const MyCourseList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
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
