import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/components/text_btn.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/signup_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool isSigningIn = false;

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
                    text: "Welcome back!",
                    children: [
                      TextSpan(text: "\nSign in to continue!"),
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
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15.0),
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
              const SizedBox(height: 5.0),
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              TextBtn(
                onPressed: () {
                  if (formkey.currentState!.validate() == true) {
                    formkey.currentState!.save();
                    if (!isSigningIn) {
                      setState(() {
                        isSigningIn = true;
                      });
                      LoadingDialog(context);
                      ApiService()
                          .signin(
                        email: emailController.text,
                        password: passwordController.text,
                      )
                          .then((value) {
                        setState(() {
                          isSigningIn = false;
                        });
                        Navigator.pop(context);
                        if (value["success"] == true) {
                          authProvider.name = value["data"]["name"];
                          authProvider.email = value["data"]["email"];
                          authProvider.authToken = value["data"]["token"];
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Your are successfully sign in.",
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Signing failed"),
                              content: const Text(
                                  "That email and password combination didn't work. Try again."),
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
                          isSigningIn = false;
                        });
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Something went wrong"),
                            content: const Text(
                                "Unable to sign in, please try again."),
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
              const SizedBox(height: 50.0),
              const Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
