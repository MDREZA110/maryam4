// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:maryam/providers/theme_provider.dart';
// import 'package:maryam/services.dart/archive_api.dart';
// import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
// import 'package:provider/provider.dart';

// class ArchiveScreen extends StatefulWidget {
//   final List cardItems;
//   final int menuId;
//   final String title;

//   const ArchiveScreen({
//     super.key,
//     required this.cardItems,
//     required this.menuId,
//     required this.title,
//   });

//   @override
//   State<ArchiveScreen> createState() => _ArchiveScreenState();
// }

// class _ArchiveScreenState extends State<ArchiveScreen> {
//   List<Map<String, dynamic>> previousIssues = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final fetchedData =
//         await fetchArchivedMagzine(); // phone number can be dynamic
//     setState(() {
//       previousIssues = fetchedData;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();
//     bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

//     int selectedYearId = -1; // Dynamically select the current year

//     // final filteredItems = widget.cardItems.where((item) {
//     //   if (selectedYearId == -1) {
//     //     return item['MenuId'].toString() == widget.menuId.toString();
//     //   }
//     //   final itemYearId = item['YearId'] ?? -1;
//     //   return item['MenuId'].toString() == widget.menuId.toString() &&
//     //       itemYearId == (selectedYearId + 10);
//     // }).toList();

//     // print("card Items: ${widget.cardItems}");

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back,
//                 color: isDarkMode ? Colors.white : Colors.black)),
//         title: Text('Archive',
//             style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
//       ),
//       body: Container(
//         color: isDarkMode ? Colors.black : Colors.white,
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // DropdownButton<int>(
//                     //   value: (selectedYearId >= 0 && selectedYearId <= 14)
//                     //       ? selectedYearId
//                     //       : 0,
//                     //   items: [
//                     //     DropdownMenuItem<int>(
//                     //       value: 0,
//                     //       child: Text("Select"),
//                     //     ),
//                     //     ...List.generate(14, (index) {
//                     //       int startYear = 2010 + index;
//                     //       int endYear = startYear + 1;
//                     //       return DropdownMenuItem<int>(
//                     //         value: index + 1,
//                     //         child: Text('$startYear-$endYear'),
//                     //       );
//                     //     }),
//                     //   ],
//                     //   onChanged: (value) {
//                     //     setState(() {
//                     //       selectedYearId = value!;
//                     //     });
//                     //   },
//                     // )

//                     DropdownButton<int>(
//                       value: selectedYearId,
//                       items: [
//                         DropdownMenuItem<int>(
//                           value: -1,
//                           child: Text("Select"),
//                         ),
//                         ...List.generate(15, (index) {
//                           int startYear = 2010 + index;
//                           int endYear = startYear + 1;
//                           return DropdownMenuItem<int>(
//                             value: index,
//                             child: Text('$startYear-$endYear'),
//                           );
//                         }),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           selectedYearId = value!;
//                         });
//                       },
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 previousIssues.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No data available for the selected year',
//                           style: TextStyle(
//                             color: isDarkMode ? Colors.white : Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     : GridView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 25,
//                           childAspectRatio: 0.75,
//                         ),
//                         itemCount: previousIssues.length,
//                         itemBuilder: (context, i) {
//                           final item = previousIssues[i];
//                           return GestureDetector(
//                             onTap: () {
//                               // Navigator.of(context).push(MaterialPageRoute(
//                               //   builder: (context) =>
//                               //       WrCardScreen(contentId: item["ContentId"]),
//                               // ));
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: isDarkMode
//                                     ? const Color.fromARGB(255, 91, 91, 91)
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: isDarkMode
//                                         ? Colors.black.withOpacity(0.5)
//                                         : Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 1,
//                                     blurRadius: 6,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                       child: Image.network(
//                                         item["ThumbnailImage"],
//                                         fit: BoxFit.cover,
//                                         errorBuilder:
//                                             (context, error, stackTrace) =>
//                                                 const Icon(Icons.broken_image,
//                                                     size: 100,
//                                                     color: Colors.grey),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       item["Title"],
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: isDarkMode
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                 const SizedBox(height: 80),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/services.dart/archive_api.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<Map<String, dynamic>> previousIssues = [];
  bool isLoading = true;
  int selectedYearId = -1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final fetchedData = await fetchArchivedMagzine();
    setState(() {
      previousIssues = fetchedData;
      isLoading = false;

      print("previousIssues  list: $previousIssues");
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   final themeProvider = context.watch<ThemeProvider>();
  //   bool isDarkMode = themeProvider.isDarkMode;

  //   // final filteredIssues = selectedYearId == -1
  //   //     ? previousIssues
  //   //     : previousIssues.where((item) {
  //   //         final yearId = item['YearId'];
  //   //         return yearId == (selectedYearId + 10);
  //   //       }).toList();

  // // Filter the list based on the selected year
  // final filteredIssues = selectedYearId == -1
  //     ? previousIssues
  //     : previousIssues.where((item) {
  //         final yearName = item['YearName']?.toString();
  //         return yearName == (2010 + selectedYearId).toString();
  //       }).toList();

  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: IconButton(
  //         onPressed: () => Navigator.pop(context),
  //         icon: Icon(Icons.arrow_back,
  //             color: isDarkMode ? Colors.white : Colors.black),
  //       ),
  //       title: Text('Archive',
  //           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
  //     ),
  //     body: Container(
  //       color: isDarkMode ? Colors.black : Colors.white,
  //       child: isLoading
  //           ? const Center(child: CircularProgressIndicator())
  //           : SingleChildScrollView(
  //               physics: const BouncingScrollPhysics(),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const SizedBox(height: 10),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         DropdownButton<int>(
  //                           value: selectedYearId,
  //                           items: [
  //                             const DropdownMenuItem<int>(
  //                               value: -1,
  //                               child: Text("Select"),
  //                             ),
  //                             ...List.generate(15, (index) {
  //                               int startYear = 2010 + index;
  //                               int endYear = startYear + 1;
  //                               return DropdownMenuItem<int>(
  //                                 value: index,
  //                                 child: Text('$startYear-$endYear'),
  //                               );
  //                             }),
  //                           ],
  //                           onChanged: (value) {
  //                             setState(() {
  //                               selectedYearId = value!;
  //                             });
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //                     // filteredIssues.isEmpty
  //                     //     ? Center(
  //                     //         child: Text(
  //                     //           'No data available for the selected year',
  //                     //           style: TextStyle(
  //                     //             color:
  //                     //                 isDarkMode ? Colors.white : Colors.black,
  //                     //             fontSize: 16,
  //                     //           ),
  //                     //         ),
  //                     //       )
  //                     //     :

  //                     GridView.builder(
  //                       shrinkWrap: true,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       gridDelegate:
  //                           const SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: 2,
  //                         crossAxisSpacing: 12,
  //                         mainAxisSpacing: 25,
  //                         childAspectRatio: 0.75,
  //                       ),
  //                       itemCount: previousIssues.length,
  //                       itemBuilder: (context, i) {
  //                         final item = previousIssues[i];
  //                         return GestureDetector(
  //                           onTap: () {
  //                             // Implement navigation if needed
  //                           },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               color: isDarkMode
  //                                   ? const Color.fromARGB(255, 91, 91, 91)
  //                                   : Colors.white,
  //                               borderRadius: BorderRadius.circular(8),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: isDarkMode
  //                                       ? Colors.black.withOpacity(0.5)
  //                                       : Colors.grey.withOpacity(0.5),
  //                                   spreadRadius: 1,
  //                                   blurRadius: 6,
  //                                   offset: const Offset(0, 3),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(12),
  //                               child: Column(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Image.network(
  //                                       item["CoverPageThumbnailImage"],
  //                                       fit: BoxFit.cover,
  //                                       errorBuilder:
  //                                           (context, error, stackTrace) =>
  //                                               const Icon(Icons.broken_image,
  //                                                   size: 100,
  //                                                   color: Colors.grey),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(height: 8),
  //                                   Text(
  //                                     item["Title"] != null
  //                                         ? utf8.decode(item["Title"]
  //                                             .toString()
  //                                             .runes
  //                                             .toList())
  //                                         : "No Title Available",
  //                                     //?? "No Title Available"
  //                                     maxLines: 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: TextStyle(
  //                                       color: isDarkMode
  //                                           ? Colors.white
  //                                           : Colors.black,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                     const SizedBox(height: 80),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode;

    // Filter the list based on the selected year
    final filteredIssues = selectedYearId == -1
        ? previousIssues
        : previousIssues.where((item) {
            final yearName = item['YearName']?.toString();
            return yearName == (2010 + selectedYearId).toString();
          }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
        ),
        title: Text('Archive',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      ),
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<int>(
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            dropdownColor: isDarkMode
                                ? const Color.fromARGB(255, 97, 97, 97)
                                : const Color.fromARGB(255, 255, 241, 241),
                            value: selectedYearId,
                            items: [
                              const DropdownMenuItem<int>(
                                value: -1,
                                child: Text("Select"),
                              ),
                              // ...List.generate(15, (index) {
                              //   int startYear = 2010 + index;
                              //   return DropdownMenuItem<int>(
                              //     value: index,
                              //     child: Text('$startYear'),
                              //   );
                              // }),

                              ...List.generate(DateTime.now().year - 2010 + 1,
                                  (index) {
                                int year = 2010 + index;
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$year'),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedYearId = value!;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      filteredIssues.isEmpty
                          ? Center(
                              child: Text(
                                'No data available for the selected year',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 25,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: filteredIssues.length,
                              itemBuilder: (context, i) {
                                final item = filteredIssues[i];
                                return GestureDetector(
                                  onTap: () {
                                    // Implement navigation if needed
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255, 91, 91, 91)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDarkMode
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Image.network(
                                              item["CoverPageThumbnailImage"],
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 100,
                                                      color: Colors.grey),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item["Title"] != null
                                                ? utf8.decode(item["Title"]
                                                    .toString()
                                                    .runes
                                                    .toList())
                                                : "...",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
