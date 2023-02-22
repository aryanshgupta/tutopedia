import 'package:flutter/material.dart';
import 'package:tutopedia/screens/home_screen.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_content.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  children: const [
                    PageViewContent(
                      image: 'assets/svg/onboarding_1.svg',
                      title: "Better way to learning is calling you!",
                      subtitle:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_2.svg',
                      title: "Find yourself by doing whatever you do!",
                      subtitle:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_3.svg',
                      title: "It's not just learning, It's a promise!",
                      subtitle:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2].map((page) {
                  return PageViewIndicator(
                    currentPage: currentPage,
                    page: page,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    if (currentPage == 2) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: Text(
                    currentPage == 2 ? "Explore" : "Next",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
