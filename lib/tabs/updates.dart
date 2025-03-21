import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
import 'package:maryam/widgets/costom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class UpdatesTab extends StatefulWidget {
  const UpdatesTab({super.key});

  @override
  State<UpdatesTab> createState() => _UpdatesTabState();
}

class _UpdatesTabState extends State<UpdatesTab> {
  bool isLoading = true; // Add loading state
  List<dynamic> cardItems = [];
  Future<void> fetchContent() async {
    final url = Uri.parse(
        "https://api.emaryam.com/WebService.asmx/AccSp_LetestUpdateMagazineAndBlogTittle"); // Replace with your API link

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          cardItems = jsonDecode(response.body);
          isLoading = false;
        });

        // ignore: avoid_print
        print(cardItems[0]["Title"]);
      } else {
        setState(() {
          isLoading = false; // Stop loading if response is not 200
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContent();
  }

  // String decodedTitle =
  //       utf8.decode(title.runes.toList(), allowMalformed: true);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader while fetching data
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...cardItems.map((item) {
                          return MyCard(
                            image: item["ThumbnailImage"],
                            title: utf8.decode(item["Title"].runes.toList(),
                                allowMalformed: true),
                            // item["Title"],
                            contentId: item["ContentId"],
                            description: '',
                            content: '',

                            // description: utf8.decode(
                            //     item["Description"]!.runes.toList(),
                            //     allowMalformed: true),
                            // content: utf8.decode(item["Content"]!.runes.toList(),
                            //     allowMalformed: true),

                            //date: item["PostOn"],
                          );
                        }),
                      ],
                    ),
                  ),
                  //^
                ],
              ),
            ),
    );
  }
}
