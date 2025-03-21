// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/tabs/more/masomeen_card_and_screen.dart';
import 'package:maryam/tabs/more/r_more_cards.dart';
import 'package:provider/provider.dart';

class MasoomeenScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cardItems;
  final int menuId;

  const MasoomeenScreen(
      {super.key, required this.cardItems, required this.menuId});

  @override
  State<MasoomeenScreen> createState() => _MasoomeenScreenState();
}

class _MasoomeenScreenState extends State<MasoomeenScreen> {
  List<Map<String, dynamic>> menuData = []; // Stores SubMenuId & SubMenuName
  List<Map<String, dynamic>> subMenuContentList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMenuData(); // Call API when screen initializes
  }

  void fetchMenuData() async {
    const String baseUrl =
        "https://api.emaryam.com/WebService.asmx/BindSubMenu"; // Replace with actual API URL
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"MenuId": /*widget.menuId*/ 9}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["d"]["status"] == "success") {
          List<Map<String, dynamic>> extractedData = responseData["d"]["data"]
              .map<Map<String, dynamic>>((item) => {
                    "SubMenuId": item["SubMenuId"],
                    "SubMenuName": item["SubMenuName"]
                  })
              .toList();

          setState(() {
            menuData = extractedData;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "API Error: ${responseData["d"]["status"]}";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch data: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: isDarkMode ? Colors.white : Colors.black)),
          title: Text(
            "14 Masoomeen",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.white),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menuData.length,
                  itemBuilder: (context, index) {
                    final item = menuData[index];
                    return MasoomeenTile(
                      title: item["SubMenuName"] ?? '',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MasomeenMoreCards(
                                menuId: widget.menuId,
                                title: item["SubMenuName"] ?? '',
                                subMenuId: item["SubMenuId"] ?? 0)));
                      },
                    );
                  },
                ),
    );
  }
}

class MasoomeenTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MasoomeenTile({
    super.key,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black)),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
      onTap: onTap,
    );
  }
}
