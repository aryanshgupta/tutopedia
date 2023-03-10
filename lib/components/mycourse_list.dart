import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/components/channel_view.dart';
import 'package:tutopedia/models/user_model.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/signin_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class MyCourseList extends StatelessWidget {
  final String name;
  final String email;
  final String authToken;
  final String profilePhoto;

  const MyCourseList({
    super.key,
    required this.name,
    required this.email,
    required this.authToken,
    required this.profilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (authToken.isNotEmpty) {
      authProvider.user = User(
        name: name,
        email: email,
        profilePhoto: profilePhoto,
        authToken: authToken,
      );
    }
    if (authProvider.user.authToken.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 305.0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SigninScreen(),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/authentication.svg',
                width: MediaQuery.of(context).size.width * 0.80,
              ),
              const SizedBox(height: 20.0),
              const Text(
                "Sigin to view my courses",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: ApiService().myCourses(authProvider.user.authToken),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ChannelView(
                channelList: snapshot.data!,
                name: name,
                email: email,
                profilePhoto: profilePhoto,
                authToken: authToken,
                shrinkWrap: true,
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 305.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/no_data.svg',
                      width: MediaQuery.of(context).size.width * 0.70,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Sorry, no saved courses found",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/error.svg',
                    width: MediaQuery.of(context).size.width * 0.80,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, something went wrong!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              child: const SpinKitThreeInOut(
                color: Colors.indigo,
                size: 50.0,
              ),
            );
          }
        },
      );
    }
  }
}
