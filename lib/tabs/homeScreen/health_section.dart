import 'package:flutter/material.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';

class HealthSection extends StatefulWidget {
  final List<Map<String, dynamic>> cardItems;
  const HealthSection({super.key, required this.cardItems});

  @override
  State<HealthSection> createState() => _HealthSectionState();
}

class _HealthSectionState extends State<HealthSection> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    .where((item) => item['MenuId'].toString() == '5')
                    .map((item) // =>
                        {
                  if (count < 1) {
                    count++;
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WrCardScreen(
                                contentId: item["ContentId"],
                              ))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    18), // Rounded corners
                                child: Image.network(
                                  item["ThumbnailImage"],
                                  height: 150,
                                  width: 280,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
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
                          const Text(
                              'अब्बास असग़र शबरेज़ कुरआने मजीद, इस्लाम से पहले के ज़माने में\nलड़कियों की अफ़सोसनाक हालत को इस तरह बयान करता है,.....'),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    );
                  }

                  return MyCard(
                    image: item["ThumbnailImage"] ?? 'default_image_url',
                    title: item["Title"] ?? 'No Title',
                    contentId: item["ContentId"] ?? 0,
                    description: item["Description"] ?? "dd",
                    content: item["Content"] ?? "cc",
                    // description: item["Description"] ?? 'No Description',
                    // content: item["Content"] ?? 'No Content',
                    // date: item["PostOn"] ?? 'No Date',
                  );
                }),
              ],
            ),
          ),
          //^
        ],
      ),
    );
  }
}
