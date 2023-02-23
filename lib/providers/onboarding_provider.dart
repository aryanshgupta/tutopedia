import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  bool _isVisited = false;

  bool get isVisited => _isVisited;

  set isVisited(bool value) {
    _isVisited = value;
    notifyListeners();
  }
}
