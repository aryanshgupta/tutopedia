import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/text_btn.dart';
import 'package:tutopedia/models/user_model.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/email_verify_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          splashRadius: 25.0,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              SvgPicture.asset(
                'assets/svg/forgot_password.svg',
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 15.0),
              const Text(
                "Please enter your email address to receive a verification code.",
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value == "") {
                    return "Please enter your email";
                  }
                  if (!EmailValidator.validate(value!)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20.0),
              TextBtn(
                onPressed: () {
                  if (formkey.currentState!.validate() == true) {
                    formkey.currentState!.save();
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      LoadingDialog(context);
                      ApiService().forgotPassword(emailController.text).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                        if (value["success"] == true) {
                          authProvider.user = User(
                            name: "",
                            email: emailController.text,
                            profilePhoto: "",
                            authToken: value["data"]["token"],
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const EmailVerifyScreen(),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Invalid email"),
                              content: const Text("Unable to verfiy email, please try again."),
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
                          isLoading = false;
                        });
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Something went wrong"),
                            content: const Text("Unable to proceed, please try again."),
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
