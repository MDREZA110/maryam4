// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/providers/text_size_provider.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:maryam/widgets/costom_card.dart';
import 'package:provider/provider.dart';

class MasomeenMoreCards extends StatefulWidget {
  final String title;
  final int menuId;
  final int subMenuId;

  const MasomeenMoreCards(
      {super.key,
      required this.menuId,
      required this.title,
      required this.subMenuId});

  @override
  State<MasomeenMoreCards> createState() => MasomeenRMoreCardsState();
}

class MasomeenRMoreCardsState extends State<MasomeenMoreCards> {
  List<Map<String, dynamic>> submenuDetails = [];

  @override
  void initState() {
    super.initState();
    fetchSubMenuDetails();
  }

  Future<void> fetchSubMenuDetails() async {
    final url = Uri.parse(
        'https://api.emaryam.com/WebService.asmx/GetSubMenuIdyValues');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"SubMenuId": widget.subMenuId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final decodedData = json.decode(data['d']);

        if (decodedData['status'] == 'success' && decodedData['data'] is List) {
          setState(() {
            submenuDetails =
                List<Map<String, dynamic>>.from(decodedData['data']);
          });
        } else {
          print('No data available');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...submenuDetails
                  .where((item) =>
                      item['SubMenuId'].toString() ==
                      widget.subMenuId.toString())
                  .map((item) => MasomeenCard(
                      image: item["ThumbnailImage"] ?? '',
                      title: item["Title"] ?? '',
                      subMenuId: item["SubMenuId"] ?? 0,
                      subMenuDetail: submenuDetails)),
            ],
          ),
        ),
      ),
    );
  }
}

class MasomeenCard extends StatelessWidget {
  final String image;
  final String title;
  final int subMenuId;
  final List<Map<String, dynamic>> subMenuDetail;
  const MasomeenCard(
      {super.key,
      required this.image,
      required this.title,
      required this.subMenuDetail,
      required this.subMenuId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MasomeenCardScreen(
                subMenuDetail: subMenuDetail,
                subMenuId: subMenuId,
              ))),
      child: Card(
        color: const Color.fromARGB(255, 241, 241, 241),
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
                child: Image.network(image,
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
                          width: 170,
                        ),
                        Text(
                          " ", //date null
                          //subMenuDetail[0]["PostOn"],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Author",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Discription Discription Discription Discription Discription Discription ",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
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

class MasomeenCardScreen extends StatefulWidget {
  const MasomeenCardScreen(
      {super.key,
      this.date,
      required this.subMenuId,
      required this.subMenuDetail});
  final String? date;
  final int subMenuId;
  final List<Map<String, dynamic>> subMenuDetail;

  @override
  State<MasomeenCardScreen> createState() => _MasomeenCardScreenState();
}

class _MasomeenCardScreenState extends State<MasomeenCardScreen> {
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
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFCD3864),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 24,
                ),
                const SizedBox(
                  width: 200,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    widget.subMenuDetail.isNotEmpty
                        ? widget.subMenuDetail[0]["ThumbnailImage"].toString()
                        : '',
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Text(
                  widget.subMenuDetail.isNotEmpty
                      ? widget.subMenuDetail[0]["Title"].toString()
                      : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
                child: Html(
                  data: widget.subMenuDetail.isNotEmpty
                      ? widget.subMenuDetail[0]["Description"].toString()
                      : '',
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
          ],
        ),
      ),
    );
  }
}
