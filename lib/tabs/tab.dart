import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/tabs/magzine.dart';
import 'package:maryam/tabs/more/more.dart';
import 'package:maryam/tabs/settings/settings.dart';
import 'package:maryam/tabs/updates.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/homeappbar.dart';
import 'package:page_flip/page_flip.dart';
import 'package:provider/provider.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  int pageIndex = 0;
  var isSearching = false;
  List<Map<String, dynamic>> cardItems = [];
  List<Map<String, dynamic>> filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    fetchDardDetail().then((_) {
      setState(() {
        filteredList = List.from(cardItems);
      });
    });
    pages = [
      HomeScreen(
        isSearching: isSearching,
        filteredList: filteredList,
      ),
      const MagzineTab(),
      const SettingsTab(),
      const UpdatesTab(),
      const MoreTab(),
    ];
  }

  final appbarTitle = [
    'Home',
    'Magazine',
    'Setting',
    'Updates',
    'explor',
  ];

  final List<Map<String, dynamic>> iconInfo = [
    {
      "title": 'Home',
      "imgPath": 'assets/images/icon_tabhome.png',
      "height": 20.5
    },
    {
      "title": 'Magazine', //^ magzine --> magazine
      "imgPath": 'assets/images/icon_tabmagzine.png',
      "height": 25.0
    },
    {
      "title": 'Settings',
      "imgPath": 'assets/images/icon_tabsettinges.png',
      "height": 30.0
    },
    {
      "title": 'Updates',
      "imgPath": 'assets/images/icon_tabupdates.png',
      "height": 30.0
    },
    {
      "title": 'More',
      "imgPath": 'assets/images/icon_tabmore.png',
      "height": 25.0
    }
  ];

  Future<void> fetchDardDetail() async {
    try {
      final response = await http.post(
        Uri.parse("https://api.emaryam.com/WebService.asmx/HomePageDetails"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Raw API Response: ${response.body}");

        // Clean and parse JSON
        String cleanedJson = _extractJson(response.body);
        List<dynamic> jsonData = jsonDecode(cleanedJson);

        setState(() {
          cardItems = jsonData.map<Map<String, dynamic>>((item) {
            return {
              "ThumbnailImage":
                  item["ThumbnailImage"] ?? "assets/images/sliderImage.png",
              "Title": item["Title"] ?? "No Title",
              "MenuId": item["MenuId"] ?? "",
              "ContentId": item["ContentId"] ?? "",
              "Description": item["Description"] ?? "No",
              "Content": item["Content"] ?? "No",
            };
          }).toList();

          filteredList = List.from(cardItems); // Reset list properly
        });
        print("Card Items: $cardItems");
        print("Filtered List: $filteredList");

        // if (cardItems.isNotEmpty) {
        //   print("First Card Content: ${cardItems[0]["Content"]}");
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content:
        //           Text("First Card Content: ${filteredList[0]["Description"]}"),
        //       duration: Duration(seconds: 7),
        //     ),
        //   );
        // }
        print("Successfully parsed slider items: ${cardItems.length}");
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching slider data: $e");
      setState(() {
        cardItems = [];
      });
    }
  }

  String _extractJson(String responseBody) {
    try {
      final outerJson = jsonDecode(responseBody);
      if (outerJson is Map<String, dynamic> && outerJson.containsKey('d')) {
        return outerJson['d'];
      }
    } catch (_) {}

    int start = responseBody.indexOf("[");
    int end = responseBody.lastIndexOf("]") + 1;

    if (start != -1 && end != -1) {
      return responseBody.substring(start, end);
    } else {
      throw FormatException("Invalid JSON format");
    }
  }

  void updatePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void toggleSearching() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredList = List.from(cardItems);
      } else {
        isSearching = true;
        filteredList = cardItems.where((item) {
          return (item["Title"] ?? "")
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return ClipRect(
      child: Scaffold(
        extendBody: true,
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        appBar: pageIndex == 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: HomeAppBar(
                  toggleSearching: toggleSearching,
                ),
              )
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: isDarkMode ? Colors.black38 : Colors.white,
                title: Text(
                  appbarTitle[pageIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
        body: Column(
          children: [
            if (isSearching && pageIndex == 0)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Container(
                  height: 53,
                  color: const Color(0xFFCD3864),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.white,
                      controller: _searchController,
                      onChanged: (query) => _search(query),
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        hintText: "   SEARCH",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            isSearching && pageIndex == 0
                ? Expanded(
                    child: filteredList.isEmpty
                        ? const Center(child: Text("No results found"))
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return MyCard(
                                  image: filteredList[index]
                                          ["ThumbnailImage"] ??
                                      'default_image_url',
                                  title: filteredList[index]["Title"] ??
                                      'No Title',
                                  contentId:
                                      filteredList[index]["ContentId"] ?? 0,
                                  description:
                                      filteredList[index]["Description"] ?? "",
                                  content: filteredList[index]["Content"] ?? "",
                                );
                              },
                            ),
                          ),
                  )
                : Expanded(
                    child: ClipRect(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 75.0),
                        child: pages[pageIndex],
                      ),
                    ),
                  ),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 49, 49, 49)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < iconInfo.length; i++)
                    Column(
                      children: [
                        IconButton(
                            enableFeedback: false,
                            onPressed: () {
                              setState(() {
                                pageIndex = i;
                              });
                            },
                            icon: Image.asset(
                              iconInfo[i]["imgPath"],
                              height: iconInfo[i]["height"],
                              color: pageIndex == i
                                  ? const Color(0xFFCD3864)
                                  : Colors.grey,
                            )),
                        Text(
                          iconInfo[i]["title"],
                          style: TextStyle(
                            fontSize: 10,
                            color: isDarkMode ? Colors.grey : Colors.black,
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}








//^-----------------------------------------------------------------------------------






// ignore_for_file: avoid_print

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:maryam/providers/theme_provider.dart';
// import 'package:maryam/tabs/magzine.dart';
// import 'package:maryam/tabs/more/more.dart';
// import 'package:maryam/tabs/settings/settings.dart';
// import 'package:maryam/tabs/updates.dart';
// import 'package:maryam/tabs/homeScreen/home_screen.dart';
// import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
// import 'package:maryam/widgets/homeappbar.dart';
// import 'package:page_flip/page_flip.dart';
// import 'package:provider/provider.dart';

// class MyTabBar extends StatefulWidget {
//   const MyTabBar({super.key});

//   @override
//   State<MyTabBar> createState() => _MyTabBarState();
// }

// class _MyTabBarState extends State<MyTabBar> {
//   int pageIndex = 0;
//   var isSearching = false;
//   List<Map<String, dynamic>> cardItems = [];
//   List<Map<String, dynamic>> filteredList = [];
//   final TextEditingController _searchController = TextEditingController();

//   late final List<Widget> pages;

//   @override
//   void initState() {
//     super.initState();
//     fetchDardDetail().then((_) {
//       setState(() {
//         filteredList = List.from(cardItems);
//       });
//     });
//     pages = [
//       HomeScreen(
//         isSearching: isSearching,
//         filteredList: filteredList,
//       ),
//       const MagzineTab(),
//       const SettingsTab(),
//       const UpdatesTab(),
//       const MoreTab(),
//     ];
//   }

//   final appbarTitle = [
//     'Home',
//     'Magazine',
//     'Setting',
//     'Updates',
//     'explor',
//   ];

//   final List<Map<String, dynamic>> iconInfo = [
//     {
//       "title": 'Home',
//       "imgPath": 'assets/images/icon_tabhome.png',
//       "height": 20.5
//     },
//     {
//       "title": 'Magazine', //^ magzine --> magazine
//       "imgPath": 'assets/images/icon_tabmagzine.png',
//       "height": 25.0
//     },
//     {
//       "title": 'Settings',
//       "imgPath": 'assets/images/icon_tabsettinges.png',
//       "height": 30.0
//     },
//     {
//       "title": 'Updates',
//       "imgPath": 'assets/images/icon_tabupdates.png',
//       "height": 30.0
//     },
//     {
//       "title": 'More',
//       "imgPath": 'assets/images/icon_tabmore.png',
//       "height": 25.0
//     }
//   ];

//   Future<void> fetchDardDetail() async {
//     try {
//       final response = await http.post(
//         Uri.parse("https://api.emaryam.com/WebService.asmx/HomePageDetails"),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         print("Raw API Response: ${response.body}");

//         // Clean and parse JSON
//         String cleanedJson = _extractJson(response.body);
//         List<dynamic> jsonData = jsonDecode(cleanedJson);

//         setState(() {
//           cardItems = jsonData.map<Map<String, dynamic>>((item) {
//             return {
//               "ThumbnailImage":
//                   item["ThumbnailImage"] ?? "assets/images/sliderImage.png",
//               "Title": item["Title"] ?? "No Title",
//               "MenuId": item["MenuId"] ?? "",
//               "ContentId": item["ContentId"] ?? "",
//               "Description": item["Description"] ?? "No",
//               "Content": item["Content"] ?? "No",
//             };
//           }).toList();

//           filteredList = List.from(cardItems); // Reset list properly
//         });
//         print("Card Items: $cardItems");
//         print("Filtered List: $filteredList");

//         // if (cardItems.isNotEmpty) {
//         //   print("First Card Content: ${cardItems[0]["Content"]}");
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(
//         //       content:
//         //           Text("First Card Content: ${filteredList[0]["Description"]}"),
//         //       duration: Duration(seconds: 7),
//         //     ),
//         //   );
//         // }
//         print("Successfully parsed slider items: ${cardItems.length}");
//       } else {
//         print("API Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching slider data: $e");
//       setState(() {
//         cardItems = [];
//       });
//     }
//   }

//   String _extractJson(String responseBody) {
//     try {
//       final outerJson = jsonDecode(responseBody);
//       if (outerJson is Map<String, dynamic> && outerJson.containsKey('d')) {
//         return outerJson['d'];
//       }
//     } catch (_) {}

//     int start = responseBody.indexOf("[");
//     int end = responseBody.lastIndexOf("]") + 1;

//     if (start != -1 && end != -1) {
//       return responseBody.substring(start, end);
//     } else {
//       throw FormatException("Invalid JSON format");
//     }
//   }

//   void updatePageIndex(int index) {
//     setState(() {
//       pageIndex = index;
//     });
//   }

//   void toggleSearching() {
//     setState(() {
//       isSearching = !isSearching;
//     });
//   }

//   void _search(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         isSearching = false;
//         filteredList = List.from(cardItems);
//       } else {
//         isSearching = true;
//         filteredList = cardItems.where((item) {
//           return (item["Title"] ?? "")
//               .toLowerCase()
//               .contains(query.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();
//     bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

//     return ClipRect(
//       child: Scaffold(
//         extendBody: true,
//         backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
//         appBar: pageIndex == 0
//             ? PreferredSize(
//                 preferredSize: Size.fromHeight(kToolbarHeight),
//                 child: HomeAppBar(
//                   toggleSearching: toggleSearching,
//                 ),
//               )
//             : AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: isDarkMode ? Colors.black38 : Colors.white,
//                 title: Text(
//                   appbarTitle[pageIndex],
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               if (isSearching && pageIndex
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(15),
//                   bottomRight: Radius.circular(15),
//                 ),
//                 child: Container(
//                   height: 53,
//                   color: const Color(0xFFCD3864),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Center(
//                     child: TextField(
//                       autofocus: true,
//                       cursorColor: Colors.white,
//                       controller: _searchController,
//                       onChanged: (query) => _search(query),
//                       decoration: InputDecoration(
//                         prefixIcon:
//                             const Icon(Icons.search, color: Colors.white),
//                         hintText: "   SEARCH",
//                         hintStyle: TextStyle(color: Colors.white),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             isSearching && pageIndex == 0
//                 ? Expanded(
//                     child: filteredList.isEmpty
//                         ? const Center(child: Text("No results found"))
//                         : Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 20),
//                             child: ListView.builder(
//                               itemCount: filteredList.length,
//                               itemBuilder: (context, index) {
//                                 return MyCard(
//                                   image: filteredList[index]
//                                           ["ThumbnailImage"] ??
//                                       'default_image_url',
//                                   title: filteredList[index]["Title"] ??
//                                       'No Title',
//                                   contentId:
//                                       filteredList[index]["ContentId"] ?? 0,
//                                   description:
//                                       filteredList[index]["Description"] ?? "",
//                                   content: filteredList[index]["Content"] ?? "",
//                                 );
//                               },
//                             ),
//                           ),
//                   )
//                 : Expanded(
//                     child: ClipRect(
//                       child: pages[pageIndex],
//                       // const SizedBox(height: 60),
//                     ),
//                   ),
//           ],
//         ),
//         bottomNavigationBar: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: Container(
//             height: 75,
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? const Color.fromARGB(255, 49, 49, 49)
//                   : Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   for (int i = 0; i < iconInfo.length; i++)
//                     Column(
//                       children: [
//                         IconButton(
//                             enableFeedback: false,
//                             onPressed: () {
//                               setState(() {
//                                 pageIndex = i;
//                               });
//                             },
//                             icon: Image.asset(
//                               iconInfo[i]["imgPath"],
//                               height: iconInfo[i]["height"],
//                               color: pageIndex == i
//                                   ? const Color(0xFFCD3864)
//                                   : Colors.grey,
//                             )),
//                         Text(
//                           iconInfo[i]["title"],
//                           style: TextStyle(
//                             fontSize: 10,
//                             color: isDarkMode ? Colors.grey : Colors.black,
//                           ),
//                         )
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



















