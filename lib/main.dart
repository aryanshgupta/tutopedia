import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool visitStatus = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((perfs) {
      setState(() {
        visitStatus = perfs.getBool('visitStatus') ?? false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingProvider onboardingProvider = Provider.of<OnboardingProvider>(context);
    return MaterialApp(
      title: 'Tutopedia',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        fontFamily: primaryFont,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: onboardingProvider.visitStatus || visitStatus ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
