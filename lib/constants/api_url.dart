class ApiUrl {
  static Uri baseUrl = Uri.parse(
    "https://sagecrm.thesagenext.com",
  );

  static Uri registerApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/register",
  );

  static Uri loginApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/login",
  );

  static Uri categoryListApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/courses",
  );

  static Uri courseListApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/channel",
  );
}
