import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutopedia/constants/styling.dart';

class PageViewContent extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const PageViewContent({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),
        SvgPicture.asset(
          image,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 20.0),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 30.0,
            fontFamily: secondaryFont,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15.0),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
