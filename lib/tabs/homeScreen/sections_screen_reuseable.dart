import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
import 'package:provider/provider.dart';

class SectionTemplate extends StatefulWidget {
  final List cardItems;
  final String menuId;
  const SectionTemplate(
      {super.key, required this.cardItems, required this.menuId});

  @override
  State<SectionTemplate> createState() => SectionTemplateState();
}

class SectionTemplateState extends State<SectionTemplate> {
  late String cleanContent;

//  @override
//   void initState() {
//     super.initState();
//     // Strip HTML tags from content when widget initializes
//     cleanContent = _stripHtmlTags(widget.content);
//   }

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

  int count = 0;
  @override
  Widget build(BuildContext context) {
    count = 0; // Reset count before building the widget
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: widget.cardItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                        ...widget.cardItems
                            .where((item) =>
                                item['MenuId'].toString() == widget.menuId)
                            .map((item) // =>
                                {
                          if (count < 1) {
                            count++;
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => WrCardScreen(
                                            contentId: item["ContentId"],
                                          ))),
                              child: Column(
                                children: [
                                  Card(
                                    color: isDarkMode
                                        ? const Color.fromARGB(255, 91, 91, 91)
                                        : Colors.white,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    elevation: 6,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16), // Rounded corners
                                              child: Image.network(
                                                item["ThumbnailImage"],
                                                height: 150,
                                                width: 280,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        // const SizedBox(
                                        //   height: 4,
                                        // ),
                                        Text(
                                          item["Title"],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Text(
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            _stripHtmlTags(item["Content"]),
                                            // 'अब्बास असग़र शबरेज़ कुरआने मजीद, इस्लाम से पहले के ज़माने में\nलड़कियों की अफ़सोसनाक हालत को इस तरह बयान करता है,.....',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Color(0xFFF3F3F3)
                                                  : Color.fromARGB(
                                                      255, 32, 32, 32),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 9,
                                  )
                                ],
                              ),
                            );
                          }

                          return MyCard(
                            image: item["ThumbnailImage"],
                            title: item["Title"],
                            contentId: item["ContentId"],
                            description: item["Description"] ?? "",
                            content: item["Content"] ?? "",
                            //    date: item["PostOn"],
                          );
                        }),
                        SizedBox(
                          height: 80,
                        )
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
