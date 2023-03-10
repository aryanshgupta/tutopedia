// import 'package:flutter/material.dart';

// class LectureSearch extends StatelessWidget {
//   const LectureSearch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () async {
//         var result = await showDialog(
//           context: context,
//           builder: (context) {
//             return StatefulBuilder(
//               builder: (context, setState) {
//                 return Dialog(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: lectureController,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.search_rounded),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.clear_rounded),
//                             splashRadius: 20.0,
//                           ),
//                           border: searchedLectureList.isEmpty ? InputBorder.none : null,
//                           hintText: "Search Lectures",
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             if (lectureController.text.isNotEmpty) {
//                               searchedLectureList = lectureList
//                                   .where(
//                                     (element) => element.title.toLowerCase().contains(lectureController.text.toLowerCase()),
//                                   )
//                                   .toList();
//                             } else {
//                               searchedLectureList.clear();
//                             }
//                           });
//                         },
//                         keyboardType: TextInputType.text,
//                       ),
//                       if (searchedLectureList.isEmpty)
//                         const SizedBox()
//                       else
//                         ListView.separated(
//                           shrinkWrap: true,
//                           physics: const ScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(
//                                 searchedLectureList[index].title,
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context, searchedLectureList[index]);
//                               },
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return const Divider();
//                           },
//                           itemCount: searchedLectureList.length,
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//         if (result != null && result is LectureModel) {
//           setState(() {
//             currentLectureIndex = lectureList.indexOf(result);

//             ytPlayerController.pause();

//             ytPlayerController.load(lectureList[currentLectureIndex].link.substring(30, 41));
//           });
//         }
//       },
//       icon: const Icon(
//         Icons.search_rounded,
//         color: Colors.black,
//       ),
//       splashRadius: 20.0,
//     );
//   }
// }
