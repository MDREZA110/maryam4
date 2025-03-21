import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/costom_card.dart';
import 'package:provider/provider.dart';

class RMoreCards extends StatefulWidget {
  final List<Map<String, dynamic>> cardItems;
  final String title;
  final int menuId;

  const RMoreCards({
    super.key,
    required this.cardItems,
    required this.menuId,
    required this.title,
  });

  @override
  State<RMoreCards> createState() => _RMoreCardsState();
}

class _RMoreCardsState extends State<RMoreCards> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: widget.autoLeading!,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(widget.title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.cardItems
                  .where((item) =>
                      item['MenuId'].toString() == widget.menuId.toString())
                  .map((item) => MyCard(
                        image: item["ThumbnailImage"],
                        title: item["Title"],
                        contentId: item["ContentId"],
                        description: item["Description"] ?? "",
                        content: item["Content"] ?? "",
                        // date: item["PostOn"],
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
