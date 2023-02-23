import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/providers/onboarding_provider.dart';
import 'package:tutopedia/screens/home_screen.dart';
import 'package:tutopedia/screens/onboarding/onboarding_screen.dart';
import 'constants/styling.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnboardingProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingProvider onboardingProvider =
        Provider.of<OnboardingProvider>(context);
    return MaterialApp(
      title: 'Tutopedia',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: primaryFont,
      ),
      debugShowCheckedModeBanner: false,
      home: onboardingProvider.isVisited
          ? const HomeScreen()
          : const OnboardingScreen(),
    );
  }
}
