import 'package:flutter/material.dart';
import 'package:tutopedia/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User _user = User(
    name: "",
    email: "",
    profilePhoto: "",
    authToken: "",
  );

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }
}
