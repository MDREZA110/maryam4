// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maryam/tabs/more/masoomeen_screen.dart';
import 'package:maryam/tabs/more/r_more_cards.dart';
import 'package:maryam/widgets/mylistile.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({super.key});

  @override
  State<MoreTab> createState() => _MoreTabState();
}

List<String> options = [
  'Stories',
  'Health',
  'Parvarish',
  'Family',
  'Tafseer',
  'Women Rights',
  'Articles',
  '14 Masoomeen',
  'Recipe',
  'Ahkam',
  'Aqaid',
  'News',
  'Archive'
];

Map<String, int> map = {
  'Stories': 10,
  'Health': 5,
  'Parvarish': 4,
  'Family': 2,
  'Tafseer': 6,
  'Women Rights': 3,
  'Articles': 11,
  '14 Masoomeen': 9,
  'Recipe': 13,
  'Ahkam': 8,
  'Aqaid': 7,
  'News': 12,
  'Archive': 14,
};

class _MoreTabState extends State<MoreTab> {
  List<Map<String, dynamic>> cardItems = [];

  @override
  void initState() {
    super.initState();
    fetchDardDetail();
  }

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
              "Title": item["Title"] ?? "",
              "MenuId": item["MenuId"] ?? "",
              "ContentId": item["ContentId"] ?? "",

              // "text": item["Description1"] ?? ""
            };
          }).toList();

          print("Successfully parsed slider items: ${cardItems.length}");
        });
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

  /// Helper function to extract valid JSON from API response
  String _extractJson(String responseBody) {
    try {
      // Try parsing as full JSON
      final outerJson = jsonDecode(responseBody);
      if (outerJson is Map<String, dynamic> && outerJson.containsKey('d')) {
        return outerJson['d']; // Extract and return actual JSON content
      }
    } catch (_) {}

    // Fallback: Find first '[' and last ']' to extract JSON array
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
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (int i = 0; i < options.length; i++)
            SettingsTile(
                imgpath: 'assets/images/more_icon${i + 1}.png',
                title: options[i],
                onTap: i == 7
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MasoomeenScreen(
                                  cardItems: cardItems,
                                  menuId: map[options[i]]!,
                                )));
                      }
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RMoreCards(
                                  cardItems: cardItems,
                                  menuId: map[options[i]]!,
                                  title: options[i],
                                )));
                      })
        ],
      ),
    );
  }
}
