import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutopedia/providers/auth_provider.dart';
import 'package:tutopedia/screens/course_list_screen.dart';
import 'package:tutopedia/screens/signup_screen.dart';
import 'package:tutopedia/services/api_service.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      future: ApiService().categoryList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  onTap: () {
                    if (authProvider.authToken.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CourseListScreen(
                            category: snapshot.data![index],
                          ),
                        ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: Image.asset(
                            snapshot.data![index].image,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width * 0.40,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.50,
                        width: MediaQuery.of(context).size.width * 0.50,
                        padding: const EdgeInsets.only(bottom: 15.0),
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black12,
                              Colors.black26,
                              Colors.black45,
                              Colors.black,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height - 305.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/no_data.svg',
                    width: MediaQuery.of(context).size.width * 0.50,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Sorry, no category found",
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
