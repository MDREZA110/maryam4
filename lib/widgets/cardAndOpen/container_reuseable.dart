import 'package:flutter/material.dart';
import 'package:maryam/tabs/more/r_more_cards.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
import 'package:http/http.dart' as http;

class ReusableContainer extends StatelessWidget {
  final String title;
  final int menuId;
  final List<Map<String, dynamic>> cardItems;
  final VoidCallback? onclick;

  const ReusableContainer({
    super.key,
    required this.title,
    required this.menuId,
    required this.cardItems,
    this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    final filteredItems = cardItems
        .where((item) => item['MenuId'].toString() == menuId.toString())
        .toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(54, 197, 150, 255),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding:
            //const EdgeInsets.all(16),
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCD3864),
              ),
            ),
            const SizedBox(height: 10),
            ...filteredItems.take(4).map(
                  (item) => MyCard(
                    image: item["ThumbnailImage"] ?? 'default_image_url',
                    title: item["Title"] ?? 'No Title',
                    contentId: item["ContentId"] ?? 0,
                    description: item["Description"] ?? "",
                    content: item["Content"] ?? "",
                  ),
                ),
            const SizedBox(height: 6),
            Center(
              child: SizedBox(
                height: 30,
                width: 90,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RMoreCards(
                              cardItems: cardItems,
                              menuId: menuId,
                              title: title,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCD3864),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: const Color(0xFFCD3864),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'View More',
                    style: TextStyle(
                      fontSize: 12,
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
