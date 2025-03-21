// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
// import 'dart:convert';

// class MyCard extends StatefulWidget {
//   final String image;
//   final String title;
//   final int contentId;
//   final String description;
//   final String content;

//   //final String date;
//   // final String author;
//   const MyCard(
//       {super.key,
//       required this.image,
//       required this.title,
//       required this.description,
//       required this.content,
//       //required this.date,
//       //  required this.author,
//       required this.contentId});

//   @override
//   State<MyCard> createState() => _MyCardState();
// }

// class _MyCardState extends State<MyCard> {
//   // List<Map<String, dynamic>> contentList = [];

//   bool isLoading = true;
//   String errorMessage = '';

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   fetchData();
//   // }

//   // Future<void> fetchData() async {
//   //   final url = Uri.parse(
//   //       'https://api.emaryam.com/WebService.asmx/GetContentImageDetails');

//   //   try {
//   //     final response = await http.post(
//   //       url,
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode({"ContentId": widget.contentId.toString()}),
//   //     );
//   //     if (response.statusCode == 200) {
//   //       final data = json.decode(response.body);
//   //       if (data['d']['status'] == 'success' && data['d']['data'] is List) {
//   //         setState(() {
//   //           contentList = List<Map<String, dynamic>>.from(data['d']['data']);
//   //           isLoading = false;
//   //         });
//   //       } else {
//   //         setState(() {
//   //           errorMessage = 'No data available';
//   //           isLoading = false;
//   //         });
//   //       }
//   //     } else {
//   //       setState(() {
//   //         errorMessage = 'Error: ${response.statusCode}';
//   //         isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       errorMessage = 'Failed to load data';
//   //       isLoading = false;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // String decodedTitle =
//     //     utf8.decode(title.runes.toList(), allowMalformed: true);

//     return GestureDetector(
//       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => WrCardScreen(
//                 contentId: widget.contentId,
//                 // date: date,
//               ))),
//       child: Card(
//         color: const Color.fromARGB(255, 241, 241, 241),
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(70),
//                 child: Image.network(widget.image,
//                     width: 70, height: 70, fit: BoxFit.cover),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const SizedBox(
//                           width: 152,
//                         ),
//                         // Text(
//                         //   // contentList.isNotEmpty
//                         //   //     ? contentList[0]["PostOn"].toString()
//                         //   //     :
//                         //   'date',
//                         //   // date,
//                         //   textAlign: TextAlign.right,
//                         //   style: const TextStyle(
//                         //       fontSize: 10,
//                         //       fontWeight: FontWeight.w700,
//                         //       color: Colors.teal),
//                         // ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       widget.title,
//                       overflow: TextOverflow.ellipsis,
//                       //title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         // 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.pink,
//                       ),
//                     ),
//                     // const SizedBox(height: 2),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.description != ''
//                           ? widget.description
//                           : 'Maryam Magazine',
//                       // widget.description,
//                       // contentList.isNotEmpty
//                       //     ? contentList[0]["Description"].toString()
//                       //     : '',
//                       overflow: TextOverflow.ellipsis,
//                       //title,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         // 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.teal,
//                       ),
//                     ),

//                     const SizedBox(height: 5),

//                     Builder(
//                       builder: (context) {
//                         debugPrint("Title: ${widget.title}");
//                         debugPrint("Description: ${widget.description}");
//                         debugPrint("Content: ${widget.content}");
//                         return Container(); // This does nothing, just for debugging
//                       },
//                     ),
//                     Text(
//                       widget.content,
//                       // widget.content,
//                       overflow: TextOverflow.ellipsis,
//                       //title,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         // 20,
//                         //fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),

//                     // Container(
//                     //   height: 5,
//                     //   color: const Color.fromARGB(39, 0, 150, 135),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// //  "PostBy": "maryam Magazine",

//^_____________________________________________________________________________

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class MyCard extends StatefulWidget {
  final String image;
  final String title;
  final int contentId;
  final String description;
  final String content;

  const MyCard(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.content,
      required this.contentId});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isLoading = true;
  String errorMessage = '';
  late String cleanContent;

  @override
  void initState() {
    super.initState();
    // Strip HTML tags from content when widget initializes
    cleanContent = _stripHtmlTags(widget.content);
  }

  // Function to strip HTML tags
  String _stripHtmlTags(String htmlString) {
    // Remove HTML tags
    String result = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');

    // Replace common HTML entities
    result = result
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&lsquo;', ''')
        .replaceAll('&rsquo;', ''')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–');

    // Trim extra whitespace
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WrCardScreen(
                contentId: widget.contentId,
              ))),
      child: Card(
        color:
            isDarkMode ? const Color.fromARGB(255, 91, 91, 91) : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.network(widget.image,
                    width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 152,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description != ''
                          ? widget.description
                          : 'Maryam Magazine',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Display the cleaned content instead of original widget.content
                    Text(
                      cleanContent,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Color(0xFFF3F3F3)
                            : Color.fromARGB(255, 32, 32, 32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
