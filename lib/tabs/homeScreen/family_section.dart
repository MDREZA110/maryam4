// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:maryam/issue_flip_effect.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/tabs/homeScreen/ontap_previousissue.dart';
import 'package:maryam/screens/pdfview_screen.dart';
import 'package:maryam/ttt.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/widgets/cardAndOpen/container_reuseable.dart';
import 'package:maryam/widgets/homeappbar.dart';
import 'package:maryam/widgets/ontap_slider_screen.dart';

import 'package:maryam/widgets/suscribe/subscribe_screen.dart';
import 'package:provider/provider.dart';

class HomeSection extends StatefulWidget {
  final List<Map<String, dynamic>> cardItems;
  const HomeSection({super.key, required this.cardItems});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> sliderItems = [];
  List<Map<String, dynamic>> previousIssues = [];
  List<Map<String, dynamic>> currentIssues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSliderData();
    fetchCoverPageImages();
    fetchCurrentIssue();
  }

  Future<void> fetchSliderData() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://api.emaryam.com/WebService.asmx/HomePageSliderDetails"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Raw API Response: ${response.body}");

        String cleanedJson = _extractJson(response.body);
        List<dynamic> jsonData = jsonDecode(cleanedJson);

        setState(() {
          sliderItems = jsonData.map<Map<String, dynamic>>((item) {
            return {
              "image":
                  item["ThumbnailImage"] ?? "assets/images/sliderImage.png",
              "heading": item["Title"] ?? "",
              "text": item["Description"] ?? ""
            };
          }).toList();

          print("Successfully parsed slider items: ${sliderItems.length}");
        });
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching slider data: $e");
      setState(() {
        sliderItems = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch previous issues from API

  Future<void> fetchCoverPageImages() async {
    const String apiUrl =
        "https://api.emaryam.com/WebService.asmx/PreviousIssuesimage";

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Map<String, dynamic>> extractedData = data.map((item) {
          return {
            "CoverPageThumbnailImage":
                item["CoverPageThumbnailImage"] as String,
            "IssueId": item["IssueId"] as int,
            "YearName": item["YearName"],
            //as String,
            "MonthName": item["MonthName"],
            // as String,
          };
        }).toList();

        setState(() {
          previousIssues = extractedData;
          print("Updated previousIssues: $previousIssues");
        });
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCurrentIssue() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.emaryam.com/WebService.asmx/CurrentIssusMagazine '));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Map<String, dynamic>> filteredData = data
            .where((item) => item["CurrentIssue"] == true)
            .map((item) => {
                  "IssueId": item["IssueId"],
                  "YearId": item["YearId"],
                  "CoverPageFullImage": item["CoverPageFullImage"]
                })
            .toList();

        setState(() {
          currentIssues = filteredData;
        });
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
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

  String removeHtmlTags(String htmlText) {
    return htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: sliderItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: SizedBox(
                    height: 360,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: sliderItems.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : PageView.builder(
                                  itemCount: sliderItems.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      // Navigate to OnTapSliderScreen
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              OnTapSliderScreen(
                                                  imgUrl: sliderItems[index]
                                                      ["image"]!,
                                                  title: sliderItems[index]
                                                      ["heading"]!,
                                                  text: sliderItems[index]
                                                      ["text"]!),
                                        ));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.network(
                                              sliderItems[index]["image"]!,
                                              height: 200,
                                              width: 350,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return CircularProgressIndicator();
                                              },
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              removeHtmlTags(sliderItems[index]
                                                  ["heading"]!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFFCD3864),
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Center(
                                            child: Text(
                                              removeHtmlTags(
                                                  sliderItems[index]["text"]!),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              sliderItems.isEmpty ? 0 : sliderItems.length,
                              (index) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? _currentIndex == index
                                        ? const Color.fromARGB(
                                            255, 240, 240, 240)
                                        : const Color.fromARGB(
                                            255, 141, 141, 141)
                                    : _currentIndex == index
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: isDarkMode
                      ? Color.fromARGB(255, 32, 32, 32)
                      : Color(0xFFF3F3F3),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Previous Issues',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: isDarkMode
                                    ? Color(0xFFF3F3F3)
                                    : Color.fromARGB(255, 32, 32, 32),
                              ),
                            ),
                            Text(
                              'Show more',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode
                                    ? Color(0xFFF3F3F3)
                                    : Color.fromARGB(255, 32, 32, 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,

                          //  previousIssues[i]["MagazinePdf"]
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Handle previous issue tap
                              for (int i = 0;
                                  i < previousIssues.length - 1;
                                  i++) ...[
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => FlipBookScreen(
                                    //           pdfUrl: previousIssues[i]
                                    //                   ["MagazinePdf"]
                                    //               .toString(),
                                    //         )));

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PageFlipBookScreen(
                                        issueId: previousIssues[i]["IssueId"]!,
                                      ),
                                    ));
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        previousIssues[i]
                                                ["CoverPageThumbnailImage"]
                                            .toString(),
                                        // ["CoverPageFullImage"],
                                        fit: BoxFit.contain,
                                        height: 160,
                                        //!120
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.broken_image,
                                          size: 100,
                                          color: const Color.fromARGB(
                                              47, 145, 145, 145),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 4),
                                            Text(
                                              "${previousIssues[i]["MonthName"]}",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${previousIssues[i]["YearName"]}",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            )

                                            // Display issue date

                                            //  "YearName": item["YearId"] ,
                                            //   "MonthName" : item["MonthName"]
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 8),
                        child: Container(
                          color: const Color.fromARGB(255, 205, 56, 101),
                          height: 370,
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                'Current Issue',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              GestureDetector(
                                // Handle current issue tap
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PageFlipBookScreen(
                                      issueId: previousIssues[1]["IssueId"],
                                    ),
                                  ));
                                },
                                child: Image.network(
                                  previousIssues[1]
                                          ["CoverPageThumbnailImage"] ??
                                      '',
                                  fit: BoxFit.contain,
                                  height: 250,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SubscribeScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFCD29),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 4),
                                ),
                                child: const Text("Subscribe",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                ReusableContainer(
                  title: "FAMILY",
                  menuId: 2,
                  cardItems: widget.cardItems,
                  onclick: () {},
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "PARVARISH",
                  menuId: 4,
                  cardItems: widget.cardItems,
                  onclick: null,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "STORY",
                  menuId: 10,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "TAFSEER-e-QURAN",
                  menuId: 6,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "HEALTH",
                  menuId: 5,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "AQAID",
                  menuId: 7,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "Women Rights",
                  menuId: 3,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "News",
                  menuId: 12,
                  cardItems: widget.cardItems,
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableContainer(
                  title: "ARTICLES",
                  menuId: 11,
                  cardItems: widget.cardItems,
                ),
              ],
            ),
    );
  }
}
