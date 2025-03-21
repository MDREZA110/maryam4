import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:maryam/providers/text_size_provider.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/services.dart/cardscreen_comntent.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OnTapSliderScreen extends StatefulWidget {
  const OnTapSliderScreen(
      {super.key,
      required this.text,
      required this.imgUrl,
      required this.title});
  final String imgUrl;
  final String title;
  final String text;

  @override
  State<OnTapSliderScreen> createState() => _OnTapSliderScreenState();
}

class _OnTapSliderScreenState extends State<OnTapSliderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final textSizeProvider = context.watch<TextSizeProvider>();
    context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode state
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

//^ AppBar

        child: AppBar(
          backgroundColor: const Color(0xFFCD3864),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 24,
                  // fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  width: 80,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/icon_search.png',
                        height: 20,
                      ),
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/icon_subscribe.png',
                        height: 20,
                      ),
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

//^ BODY

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18), // Rounded corners
                  child: Image.network(
                    widget.imgUrl,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Expanded(
                    child: Html(
                      data: widget.text,
                      style: {
                        "*": Style(
                          fontSize: FontSize(textSizeProvider.textSize),
                          color: isDarkMode ? Colors.white : Colors.black,
                          // Change font color to red (Modify as needed)
                          backgroundColor: Colors.transparent,
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
