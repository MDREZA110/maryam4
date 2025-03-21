// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// class Mytabbar extends StatefulWidget {
//   const Mytabbar({super.key});

//   @override
//   State<Mytabbar> createState() => _MytabbarState();
// }

// class _MytabbarState extends State<Mytabbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           IconButton(
//               enableFeedback: false,
//               onPressed: () {
//                 setState(() {
//                   pageIndex = 0;
//                 });
//               },
//               icon: Image.asset(
//                 'assets/images/icon_tabhome.png',
//                 height: 25,
//                 color: pageIndex == 0 ? const Color(0xFFCD3864) : Colors.grey,
//               )),
//           IconButton(
//               enableFeedback: false,
//               onPressed: () {
//                 setState(() {
//                   pageIndex = 1;
//                 });
//               },
//               icon: Image.asset(
//                 'assets/images/icon_tabmagzine.png',
//                 color: pageIndex == 1 ? const Color(0xFFCD3864) : Colors.grey,
//                 height: 25,
//               )),
//           IconButton(
//               enableFeedback: false,
//               onPressed: () {
//                 setState(() {
//                   pageIndex = 2;
//                 });
//               },
//               icon: Image.asset(
//                 'assets/images/icon_tabsettinges.png',
//                 color: pageIndex == 2 ? const Color(0xFFCD3864) : Colors.grey,
//                 height: 30,
//               )),
//           IconButton(
//               enableFeedback: false,
//               onPressed: () {
//                 setState(() {
//                   pageIndex = 3;
//                 });
//               },
//               icon: Image.asset(
//                 'assets/images/icon_tabupdates.png',
//                 color: pageIndex == 3 ? const Color(0xFFCD3864) : Colors.grey,
//                 height: 30,
//               )),
//           IconButton(
//               enableFeedback: false,
//               onPressed: () {
//                 setState(() {
//                   pageIndex = 4;
//                 });
//               },
//               icon: Image.asset(
//                 'assets/images/icon_tabmore.png',
//                 height: 25,
//                 color: pageIndex == 4 ? const Color(0xFFCD3864) : Colors.grey,
//               )),
//         ],
//       ),
//     );
//   }
// }
