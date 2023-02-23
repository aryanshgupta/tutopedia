import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyCourseList extends StatelessWidget {
  const MyCourseList({super.key});

  @override
  Widget build(BuildContext context) {
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
}
