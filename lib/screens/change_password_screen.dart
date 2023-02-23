import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/text_btn.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isChangingPassword = false;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              const SizedBox(height: 40.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  text: const TextSpan(
                    text: "Hi,",
                    children: [
                      TextSpan(text: "\nCreate new password!"),
                    ],
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: secondaryFont,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                validator: (value) {
                  if (value == "") {
                    return "Please enter your password";
                  }
                  if (value!.length < 8) {
                    return "Password should more than 7 character";
                  }
                  return null;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: hidePassword
                        ? const Icon(Icons.visibility_rounded)
                        : const Icon(Icons.visibility_off_rounded),
                    splashRadius: 20.0,
                  ),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                ),
                obscureText: hidePassword,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == "") {
                    return "Please confirm your password";
                  }
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    return "Password do not match";
                  }
                  return null;
                },
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hideConfirmPassword = !hideConfirmPassword;
                      });
                    },
                    icon: hideConfirmPassword
                        ? const Icon(Icons.visibility_rounded)
                        : const Icon(Icons.visibility_off_rounded),
                    splashRadius: 20.0,
                  ),
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                ),
                obscureText: hideConfirmPassword,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15.0),
              TextBtn(
                onPressed: () {
                  if (formkey.currentState!.validate() == true) {
                    formkey.currentState!.save();
                    if (!isChangingPassword) {
                      setState(() {
                        isChangingPassword = true;
                      });
                      LoadingDialog(context);
                      ApiService()
                          .changePassword(
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                        token: authProvider.authToken,
                      )
                          .then((value) {
                        setState(() {
                          isChangingPassword = false;
                        });
                        Navigator.pop(context);
                        if (value["message"] ==
                            "Your password has been changed") {
                          authProvider.name = "";
                          authProvider.email = "";
                          authProvider.authToken = "";
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Password Changed"),
                              content: const Text(
                                  "Your password has been successfully changed, please sign in again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                )
                              ],
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Something went wrong"),
                              content: const Text(
                                  "Unable to change password, please try again."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Okay"),
                                )
                              ],
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        setState(() {
                          isChangingPassword = false;
                        });
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Something went wrong"),
                            content: const Text(
                                "Unable to change password, please try again."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Okay"),
                              )
                            ],
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      });
                    }
                  }
                },
                label: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
