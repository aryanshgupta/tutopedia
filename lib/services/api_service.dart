import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tutopedia/constants/api_url.dart';
import 'package:tutopedia/models/category_model.dart';
import 'package:tutopedia/models/course_model.dart';

class ApiService {
  Future<dynamic> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    var response = await http.post(
      ApiUrl.signUpApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "c_password": confirmPassword
      }),
    );
    return json.decode(response.body);
  }

  Future<dynamic> signin({
    required String email,
    required String password,
  }) async {
    var response = await http.post(
      ApiUrl.signInApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return json.decode(response.body);
  }

  Future<dynamic> signOut(String token) async {
    var response = await http.post(
      ApiUrl.signOutApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body);
  }

  Future<dynamic> changePassword({
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    var response = await http.post(
      ApiUrl.changePasswordApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "new_password": password,
        "confirm_password": confirmPassword,
      }),
    );

    return json.decode(response.body);
  }

  Future<List<CategoryModel>> categoryList() async {
    var response = await http.get(
      ApiUrl.categoryListApi,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    List body = json.decode(response.body);

    List<CategoryModel> categoryList = [];

    for (var category in body) {
      categoryList.add(CategoryModel.fromJson(category));
    }

    return categoryList;
  }

  Future<List<CourseModel>> courseList({
    required String id,
    required String token,
  }) async {
    var response = await http.get(
      Uri.parse(
        "${ApiUrl.courseListApi.toString()}/$id",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    List body = json.decode(response.body);

    List<CourseModel> courseList = [];

    for (var course in body) {
      courseList.add(CourseModel.fromJson(course));
    }

    return courseList;
  }
}
