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
      ApiUrl.registerApi,
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
      ApiUrl.loginApi,
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

  Future<List<CourseModel>> courseList(String id) async {
    var response = await http.get(
      Uri.parse(
        "${ApiUrl.courseListApi.toString()}/$id",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI2M2VkN2VjYzkyZDhjYTI2OWMwZDdiMTIiLCJqdGkiOiI4OTAyM2E3MGQ5YmMwMDcxN2RmY2ZjOTEyNGJiNjg5MTc0ZDYyNWQ4MjUwN2Q1OWNkNGM1NWE4NGY3NTZlMGZiMWUwYzAyMmQzMTU0OTE0YiIsImlhdCI6MTY3Njk1NDM4My4wNDUzOTcwNDMyMjgxNDk0MTQwNjI1LCJuYmYiOjE2NzY5NTQzODMuMDQ1NDAxMDk2MzQzOTk0MTQwNjI1LCJleHAiOjE3MDg0OTAzODIuNzgzNDEzODg3MDIzOTI1NzgxMjUsInN1YiI6IjYzZjMyNTI4OTU3MDllMmQ4ZTA3NmUwMiIsInNjb3BlcyI6W119.ReuQidEdPd3yahj7QnD1T_Egi_boLVNH_DjDi_5EjrVxAov1m_7SA4Nhne91QFYjp9KwL2cecu_MOXnChgRGSzK5QMj1yPuNFEFuWnnTIUVEpEzdUXQyPiLMBOJLlNNTb_BYFiIuWdaNVJPX5IZdJtQrYuV-VQjGwxNQkvgr9rem89_Kis3QoPbkywRRPG0nvdfO2iA4l9T9A6C9xTfFD4T_R1iyGmcfBTdqB7g9TqgVbBaJM7dN9xtx7YEW1ErQZaoSbTVGB9CJCtned4-_KOLrsLleqxMaKoiFEv7WdxGNh4hrY2VmDPuAioAhu7v1wFdIt46VPTS2jJTdVrq-NJjtNO9Aa8443IDBC2eREEPAqavez-qVNpQlwNioP29wOddMNHCRbDsEumSsCBuJnphAcVbK4q-MBmI3TVTqIgFyBXyErnQJGoSawm3DN0OwkhW88CyuoTeRq18N2GxA8N-61FHc_UqPYvKEB-vWAbCV8ULGeiTDdiMRpSJnBnGaf9H-LpWANKgOxMFSAcEy6WfhrkSqfwRE--wkIMcB9rK5Ea8Lg2vTZgHFhOGaauQOFqgL83MA3Ym1uBwUNQIBTiYZZ26M9dCmJFRhyEFZkYNUbRCTgE2zKe5xMOA9XQkbRdqPYxGudf670DO7nQRmhdmsErlh4Wsr1TghH_J3pao',
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
