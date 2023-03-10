import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutopedia/screens/home_screen.dart';
import 'package:tutopedia/screens/onboarding/onboarding_screen.dart';
import 'constants/styling.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox("app_log");
  await Hive.openBox("auth_info");
  await Hive.openBox("my_courses");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutopedia',
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: primaryFont,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ValueListenableBuilder(
        valueListenable: Hive.box('app_log').listenable(),
        builder: (context, appLogBox, child) {
          bool? visitStatus = appLogBox.get('visitStatus');
          if (visitStatus != null && visitStatus) {
            return const HomeScreen();
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}
