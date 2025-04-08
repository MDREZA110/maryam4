// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/widgets/cardAndOpen/card_screen.dart';
import 'package:provider/provider.dart';

class ArchiveSectionTemplate extends StatefulWidget {
  final List cardItems;
  final String menuId;

  const ArchiveSectionTemplate(
      {super.key, required this.cardItems, required this.menuId});

  @override
  State<ArchiveSectionTemplate> createState() => ArchiveSectionTemplateState();
}

class ArchiveSectionTemplateState extends State<ArchiveSectionTemplate> {
  int selectedYearId = -1; // Dynamically select the current year

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode;

    // final filteredItems = widget.cardItems.where((item) {
    //   if (selectedYearId == 0) {
    //     return item['MenuId'].toString() == widget.menuId;
    //   }
    //   final itemYearId = item['YearId'] != null ? item['YearId'] ?? 0 : 0;
    //   return item['MenuId'].toString() == widget.menuId &&
    //       itemYearId == selectedYearId;
    // }).toList();

    final filteredItems = widget.cardItems.where((item) {
      if (selectedYearId == -1) {
        return item['MenuId'].toString() == widget.menuId;
      }
      final itemYearId = item['YearId'] ?? -1;
      return item['MenuId'].toString() == widget.menuId &&
          itemYearId == (selectedYearId + 10);
    }).toList();

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // DropdownButton<int>(
                  //   value: (selectedYearId >= 0 && selectedYearId <= 14)
                  //       ? selectedYearId
                  //       : 0,
                  //   items: [
                  //     DropdownMenuItem<int>(
                  //       value: 0,
                  //       child: Text("Select"),
                  //     ),
                  //     ...List.generate(14, (index) {
                  //       int startYear = 2010 + index;
                  //       int endYear = startYear + 1;
                  //       return DropdownMenuItem<int>(
                  //         value: index + 1,
                  //         child: Text('$startYear-$endYear'),
                  //       );
                  //     }),
                  //   ],
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedYearId = value!;
                  //     });
                  //   },
                  // )

                  DropdownButton<int>(
                    value: selectedYearId,
                    items: [
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text("Select"),
                      ),
                      ...List.generate(15, (index) {
                        int startYear = 2010 + index;
                        int endYear = startYear + 1;
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$startYear-$endYear'),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedYearId = value!;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No data available for the selected year',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 25,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, i) {
                        final item = filteredItems[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  WrCardScreen(contentId: item["ContentId"]),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color.fromARGB(255, 91, 91, 91)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      item["ThumbnailImage"],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  size: 100,
                                                  color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item["Title"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
