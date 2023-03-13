import 'package:flutter/material.dart';
import 'package:tutopedia/constants/styling.dart';

class Header extends StatelessWidget {
  final String title;
  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: RichText(
        text: TextSpan(
          text: "Choose by",
          style: const TextStyle(
            fontSize: 15.0,
            fontFamily: primaryFont,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "\n$title",
              style: const TextStyle(
                fontFamily: secondaryFont,
                fontSize: 25.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
        maxLines: 2,
      ),
    );
  }
}
