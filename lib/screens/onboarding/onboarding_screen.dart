import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/providers/onboarding_provider.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_content.dart';
import 'package:tutopedia/screens/onboarding/components/page_view_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingProvider onboardingProvider = Provider.of<OnboardingProvider>(context);
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
                    onboardingProvider.setVisitStatus();
                    SharedPreferences.getInstance().then((perfs) {
                      perfs.setBool('visitStatus', true);
                    });
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
                  controller: onboardingProvider.pageController,
                  onPageChanged: (value) {
                    onboardingProvider.currentPage = value;
                  },
                  children: const [
                    PageViewContent(
                      image: 'assets/svg/onboarding_1.svg',
                      title: "Online Study is the",
                      subtitle: "Best choice for",
                      hightLightedText: "everyone.",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_2.svg',
                      title: "Best platform for both",
                      hightLightedText: "Teachers & Learners",
                    ),
                    PageViewContent(
                      image: 'assets/svg/onboarding_3.svg',
                      title: "Learn Anytime,",
                      subtitle: "Anywhere. Accelerate",
                      hightLightedText: "Your Future and beyond.",
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1, 2].map((page) {
                  return PageViewIndicator(
                    currentPage: onboardingProvider.currentPage,
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
                    if (onboardingProvider.currentPage == 2) {
                      onboardingProvider.setVisitStatus();

                      SharedPreferences.getInstance().then((perfs) {
                        perfs.setBool('visitStatus', true);
                      });
                    } else {
                      onboardingProvider.pageController.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: Text(
                    onboardingProvider.currentPage == 2 ? "Explore" : "Next",
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
