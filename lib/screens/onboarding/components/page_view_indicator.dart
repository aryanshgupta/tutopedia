import 'package:flutter/material.dart';

class PageViewIndicator extends StatelessWidget {
  final int currentPage;
  final int page;
  const PageViewIndicator({
    super.key,
    required this.currentPage,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: currentPage == page ? Colors.white : Colors.grey,
        border: Border.all(
          color: currentPage == page ? Colors.black : Colors.grey,
          width: currentPage == page ? 2.5 : 0,
        ),
        shape: BoxShape.circle,
      ),
      width: currentPage == page ? 10.0 : 6.0,
      height: currentPage == page ? 10.0 : 6.0,
    );
  }
}
