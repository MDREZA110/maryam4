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
