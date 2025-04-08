// //TODO  flip book

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:maryam/widgets/suscribe/subscribe_screen.dart';
// import 'package:page_flip/page_flip.dart';

// Future<List<String>> fetchImages(int issueId) async {
//   final url = Uri.parse(
//       'http://emaryam.com/Webservice.asmx/GetMagazineImageList?IssueId=$issueId');

//   try {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       List<String> issueId =
//           data.map<String>((item) => item['ImageUpload'] as String).toList();
//       return issueId;
//     } else {
//       throw Exception('Failed to load images');
//     }
//   } catch (e) {
//     throw Exception('Error fetching images: $e');
//   }
// }
// //^_________

// class PageFlipBookScreen extends StatefulWidget {
//   final int issueId;
//   const PageFlipBookScreen({super.key, required this.issueId});

//   @override
//   _PageFlipBookScreenState createState() => _PageFlipBookScreenState();
// }

// class _PageFlipBookScreenState extends State<PageFlipBookScreen> {
//   late Future<List<String>> issueId;
//   final _pageFlipController = GlobalKey<PageFlipWidgetState>();
//   bool _showComingSoon = false;

//   @override
//   void initState() {
//     super.initState();
//     issueId = fetchImages(widget.issueId);

//     Timer(Duration(milliseconds: 500), () {
//       if (!mounted) return;
//       setState(() {
//         _showComingSoon = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (!_showComingSoon)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(
//                         Icons.cancel,
//                         color: Colors.red,
//                         size: 35,
//                       )),
//                   SizedBox(
//                     width: 20,
//                   )
//                 ],
//               ),
//             SizedBox(
//               height: 4,
//             ),
//             Container(
//               color: Colors.black,
//               height: 480,
//               width: 360,
//               child: FutureBuilder<List<String>>(
//                 future: issueId,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text("Error: ${snapshot.error}"));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(
//                       child: _showComingSoon
//                           ? Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 if (_showComingSoon)
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       IconButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           icon: Icon(
//                                             Icons.cancel,
//                                             color: Colors.red,
//                                             size: 35,
//                                           )),
//                                       SizedBox(
//                                         width: _showComingSoon ? 16 : 20,
//                                       )
//                                     ],
//                                   ),
//                                 Image.asset(
//                                   "assets/gifs/comingSoon.gif",
//                                   // height: 125.0,
//                                   width: 340,
//                                 ),
//                                 SizedBox(
//                                   height: 50,
//                                 )
//                               ],
//                             )
//                           : const CircularProgressIndicator(),
//                     );
//                   }

//                   return PageFlipWidget(
//                     key: _pageFlipController,
//                     backgroundColor: Colors.white,
//                     //Colors.black,
//                     lastPage: Container(
//                       color: Colors.black,
//                       child: Center(
//                           child: Container(
//                               height: 480,
//                               width: 300,
//                               color: const Color.fromARGB(58, 158, 158, 158),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Subscribe Now!",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 12,
//                                   ),
//                                   Center(
//                                     child: Text(
//                                       "To access the full content, please subscribe to Maryam Magazine. ",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           color: const Color.fromARGB(
//                                               255, 228, 228, 228),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 23,
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.of(context)
//                                           .push(MaterialPageRoute(
//                                         builder: (context) => SubscribeScreen(),
//                                       ));
//                                     },
//                                     style: ButtonStyle(
//                                         backgroundColor:
//                                             WidgetStateProperty.all(
//                                                 Colors.amber)),
//                                     child: const Text(
//                                       "Subscribe",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ))),
//                     ),
//                     children: snapshot.data!
//                         .map((imageUrl) => Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(imageUrl),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//TODO  flip book

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/widgets/suscribe/subscribe_screen.dart';
import 'package:page_flip/page_flip.dart';

Future<List<String>> fetchImages(int issueId) async {
  final url = Uri.parse(
      'http://emaryam.com/Webservice.asmx/GetMagazineImageList?IssueId=$issueId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> issueId =
          data.map<String>((item) => item['ImageUpload'] as String).toList();

      return issueId;
    } else {
      throw Exception('Failed to load images');
    }
  } catch (e) {
    throw Exception('Error fetching images: $e');
  }
}
//^_________

class PageFlipBookScreen extends StatefulWidget {
  final int issueId;
  const PageFlipBookScreen({super.key, required this.issueId});

  @override
  _PageFlipBookScreenState createState() => _PageFlipBookScreenState();
}

class _PageFlipBookScreenState extends State<PageFlipBookScreen> {
  late Future<List<String>> issueId;
  final _pageFlipController = GlobalKey<PageFlipWidgetState>();
  bool _showComingSoon = false;

  @override
  void initState() {
    super.initState();
    issueId = fetchImages(widget.issueId);

    Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _showComingSoon = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          // Colors.white,
          Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showComingSoon)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 35,
                      )),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.black,
              height: 480,
              width: 360,
              child: FutureBuilder<List<String>>(
                future: issueId,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: _showComingSoon
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_showComingSoon)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 35,
                                          )),
                                      SizedBox(
                                        width: _showComingSoon ? 16 : 20,
                                      )
                                    ],
                                  ),
                                Image.asset(
                                  "assets/gifs/comingSoon.gif",
                                  // height: 125.0,
                                  width: 340,
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            )
                          // ? const Text(
                          //     "Coming Soon",
                          //     style: TextStyle(color: Colors.white),
                          //   )
                          : const CircularProgressIndicator(),
                    );
                  }

//    comingSoon.gif

                  return PageFlipWidget(
                    key: _pageFlipController,
                    backgroundColor:
                        //Colors.white,
                        Colors.black,
                    lastPage: Container(
                      color: Colors.black,
                      child: Center(
                          child: Container(
                              height: 480,
                              width: 300,
                              color: const Color.fromARGB(58, 158, 158, 158),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Subscribe Now!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Center(
                                    child: Text(
                                      "To access the full content, please subscribe to Maryam Magazine. ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 228, 228, 228),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => SubscribeScreen(),
                                      ));
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.amber)),
                                    child: const Text(
                                      "Subscribe",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                    children: snapshot.data!
                        .map((imageUrl) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
