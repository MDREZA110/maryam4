// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/tab.dart';
import '../screens/otp_screen.dart';

class SliderApi {
  Future<void> sliderApi(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          "https://api.emaryam.com/WebService.asmx/HomePageSliderDetails"),
      headers: {'Content-Type': 'application/json'},
    );
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data[0]["MenuId"] != null && data[0].isNotEmpty) {
          print(data[0]["MenuId"]);
          print(data[0]["Description1"]);
          print(data[0]["ThumbnailImage"]);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('MenuId  not available')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
