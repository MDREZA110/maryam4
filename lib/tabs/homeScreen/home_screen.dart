// ignore_for_file: unused_import, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/tabs/homeScreen/archive_sections_screen_reuseable.dart';
import 'package:maryam/tabs/homeScreen/sections_screen_reuseable.dart';

import 'package:maryam/tabs/magzine.dart';
import 'package:maryam/tabs/more/more.dart';
import 'package:maryam/tabs/homeScreen/home_section.dart';
import 'package:maryam/tabs/homeScreen/health_section.dart';
import 'package:maryam/tabs/homeScreen/parvarish_section.dart';
import 'package:maryam/tabs/homeScreen/tafseer_section.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/mytabbar.dart';
import 'package:maryam/tabs/settings/settings.dart';
import 'package:maryam/tabs/updates.dart';
import 'package:maryam/tabs/homeScreen/womensright_screen.dart';
import 'package:maryam/widgets/myicons_homepage.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  bool isSearching;
  List<Map<String, dynamic>> filteredList;
  HomeScreen({
    super.key,
    required this.isSearching,
    required this.filteredList,
    /*required String userName*/
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sectionIndex = 0;
  List<Map<String, dynamic>> cardItems = [];

  late ScrollController _scrollController;
  bool _showBackToTopButton = false;

//List<Map<String, dynamic>>  widget.filteredList = [];
  //bool isSearching = false; // Toggle variable

  List<Widget> sectionsInHome = [];

  @override
  void initState() {
    super.initState();
    fetchDardDetail(); // Initially, show all items

//^  _scrollController controller
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = true;
        });
      } else if (_scrollController.offset <= 300 && _showBackToTopButton) {
        setState(() {
          _showBackToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  final title = ['Family', 'Women Rights', 'Parvarish', 'Health', 'Tafseer'];

  List<Widget> getSections() {
    return [
      HomeSection(cardItems: cardItems),
      // WomensRightSection(cardItems: cardItems),
      // ParvarishSection(cardItems: cardItems),
      // HealthSection(cardItems: cardItems),
      // TafseerSection(cardItems: cardItems),

      //icon_tabhome.png

      SectionTemplate(cardItems: cardItems, menuId: '2'),
      SectionTemplate(cardItems: cardItems, menuId: '3'),
      SectionTemplate(cardItems: cardItems, menuId: '4'),
      SectionTemplate(cardItems: cardItems, menuId: '5'),
      SectionTemplate(cardItems: cardItems, menuId: '6'),

      SectionTemplate(cardItems: cardItems, menuId: '7'),
      SectionTemplate(cardItems: cardItems, menuId: '8'),
      SectionTemplate(cardItems: cardItems, menuId: '9'),
      SectionTemplate(cardItems: cardItems, menuId: '10'),
      SectionTemplate(cardItems: cardItems, menuId: '11'),
      SectionTemplate(cardItems: cardItems, menuId: '12'),
      SectionTemplate(cardItems: cardItems, menuId: '13'),
      ArchiveSectionTemplate(cardItems: cardItems, menuId: '14'),
    ];
  }

//&  SEARCH FUNC

  //^   API call to fetch CardData

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
              "Description": item["Description"] ?? "",
              "Content": item["Content"] ?? "",
            };
          }).toList();
        });
        print("Card Items: $cardItems");

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: isDarkMode ? Colors.black : Colors.white,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyIcons(
                      changecolor: sectionIndex == 0,
                      imagePath: 'assets/images/icon_tabhome.png',
                      text: 'Home',
                      iconSize: 25,
                      boxHeight: 13.4,
                      // changecolor: false,
                      onClick: () {
                        setState(() {
                          sectionIndex = 0;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 1,
                      imagePath: 'assets/images/icon_family.png',
                      text: 'Family',
                      onClick: () {
                        setState(() {
                          sectionIndex = 1;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 2,
                      imagePath: 'assets/images/icon_womenrights.png',
                      text: 'Women Rights',
                      onClick: () {
                        setState(() {
                          sectionIndex = 2;
                        });
                      },
                    ),
                    MyIcons(
                      changecolor: sectionIndex == 3,
                      imagePath: 'assets/images/icon_parvarish.png',
                      text: 'Parvarish',
                      onClick: () {
                        setState(() {
                          sectionIndex = 3;
                        });
                      },
                    ),
                    MyIcons(
                      changecolor: sectionIndex == 4,
                      imagePath: 'assets/images/icon_health.png',
                      text: 'Health',
                      boxHeight: 3.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 4;
                        });
                      },
                    ),
                    MyIcons(
                      changecolor: sectionIndex == 5,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Tafseer',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 5;
                        });
                      },
                    ),

                    //^ 8 more copied (MyIcon)

                    MyIcons(
                      changecolor: sectionIndex == 6,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Aqaid',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 6;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 7,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Ahkam',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 7;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 8,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: '14 Masoomeen',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 8;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 9,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Story',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 9;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 10,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Articles',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 10;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 11,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'News',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 11;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 12,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Recipe',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 12;
                        });
                      },
                    ),

                    MyIcons(
                      changecolor: sectionIndex == 13,
                      imagePath: 'assets/images/icon_tafseer.png',
                      text: 'Archive',
                      boxHeight: 5.5,
                      onClick: () {
                        setState(() {
                          sectionIndex = 13;
                        });
                      },
                    ),
                  ],
                ),
              ),

              widget.isSearching
                  ? widget.filteredList.isEmpty
                      ? const Center(child: Text("No results found"))
                      : ListView.builder(
                          itemCount: widget.filteredList.length,
                          itemBuilder: (context, index) {
                            return MyCard(
                              image: widget.filteredList[index]["image"],
                              title: widget.filteredList[index]["title"],
                              contentId: widget.filteredList[index]
                                  ["contentId"],
                              description: widget.filteredList[index]
                                  ["Description"]!,
                              content: widget.filteredList[index]["Content"]!,
                              //  date: widget.filteredList[index]["PostOn"],
                            );
                          },
                        )
                  : getSections()[sectionIndex]

              //sectionsInHome[sectionIndex],
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _showBackToTopButton ? 1.0 : 0.0, //&& sectionIndex == 0
        duration: Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !_showBackToTopButton,
          child: FloatingActionButton(
            onPressed: _scrollToTop,
            child: Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }
}
