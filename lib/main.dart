import 'package:flutter/material.dart';
import 'package:tutopedia/screens/onboarding/onboarding_screen.dart';
import 'constants/styling.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutopedia',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: primaryFont,
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
