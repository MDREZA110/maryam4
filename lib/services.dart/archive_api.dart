// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maryam/screens/otp_screen.dart';

Future<List<Map<String, dynamic>>> fetchArchivedMagzine() async {
  List<Map<String, dynamic>> previousIssues = [];

  const String apiUrl =
      "https://api.emaryam.com/WebService.asmx/PreviousIssuesimage";

  try {
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> extractedData = data.map((item) {
        return {
          "CoverPageThumbnailImage": item["CoverPageThumbnailImage"] as String,
          "IssueId": item["IssueId"] as int,
          "YearName": item["YearName"],
          //as String,
          "MonthName": item["MonthName"],
          "Title": item["Title"],
          "MagazinePdf": item["MagazinePdf"],
          //   "MagazinePdf"
          // as String,
        };
      }).toList();

      previousIssues = extractedData;
    } else {
      print("Failed to load data");
    }
  } catch (e) {
    print("Error: $e");
  }

  // finally {
  //   // setState(() {
  //   //  isLoading = false;
  //   // });
  // }

  return previousIssues;
}

//List<Map<String, dynamic>> previousIssues = [];
