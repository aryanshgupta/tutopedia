import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/components/loading_dialog.dart';
import 'package:tutopedia/constants/styling.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/change_password_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class ProfileScreen {
  ProfileScreen(context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    bool isSigningOut = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.80),
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                            ),
                            splashRadius: 25.0,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: SvgPicture.asset(
                              'assets/svg/profile.svg',
                              height: 100.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      authProvider.name,
                      style: const TextStyle(
                        fontFamily: secondaryFont,
                        fontSize: 30.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      authProvider.email,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (!isSigningOut) {
                              setState(() {
                                isSigningOut = true;
                              });
                              LoadingDialog(context);
                              ApiService()
                                  .signOut(authProvider.authToken)
                                  .then((value) {
                                setState(() {
                                  isSigningOut = false;
                                });
                                Navigator.pop(context);
                                if (value["success"] ==
                                    "logged out successfully") {
                                  authProvider.name = "";
                                  authProvider.email = "";
                                  authProvider.authToken = "";
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Your are successfully sign out.",
                                      ),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Something went wrong"),
                                      content: const Text(
                                          "Unable to sign out, please try again."),
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
                                  isSigningOut = false;
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
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.indigo,
                            ),
                          ),
                          child: const Text(
                            "Signout",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
