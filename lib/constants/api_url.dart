class ApiUrl {
  static Uri baseUrl = Uri.parse(
    "https://sagecrm.thesagenext.com",
  );

  static Uri signUpApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/register",
  );

  static Uri signInApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/login",
  );

  static Uri signOutApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/logout",
  );

  static Uri changePasswordApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/forgetPassword/otp/changePassword",
  );

  static Uri categoryListApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/courses",
  );

  static Uri courseListApi = Uri.parse(
    "${baseUrl.toString()}/tutoapi/api/channel",
  );
}
